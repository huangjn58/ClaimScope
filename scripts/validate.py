"""Validate the public package, not the model's behavior. Requires PyYAML."""

import json
import re
import sys
from datetime import date
from pathlib import Path
from urllib.parse import unquote, urlsplit
import xml.etree.ElementTree as ET

try:
    import yaml
except ImportError:
    raise SystemExit("Install the validation dependency with: python -m pip install PyYAML")

ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "skill" / "claimscope"
MODULES = [
    "press-release-principle.md", "scientific-boundaries.md",
    "doctoral-thesis-style.md", "reviewer-response.md", "rewrite-examples.md",
]
REQUIRED = [
    "README.md", "README.zh-CN.md", "LICENSE", "CHANGELOG.md", "CONTRIBUTING.md",
    ".gitignore", ".gitattributes", "install.ps1", "install.sh", "skill.json",
    "CITATION.cff", ".github/workflows/validate.yml",
    "skill/claimscope/SKILL.md", "skill/claimscope/LICENSE",
    "prompts/quick-prompt.md", "prompts/quick-prompt-zh.md",
    "docs/github-metadata.md", "docs/branch-strategy.md", "docs/release-v1.0.0.md",
    "docs/acknowledgements.md", "docs/validation.md", "assets/social-preview.png",
] + [f"skill/claimscope/references/{name}" for name in MODULES]
REQUIRED += [f"examples/{name}.md" for name in [
    "01-defensive-writing", "02-abstract", "03-introduction", "04-results",
    "05-discussion", "06-conclusion", "07-reviewer-response",
]]
REQUIRED += [f"assets/{name}.svg" for name in ["cover", "architecture", "workflow", "module-map"]]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    for name in REQUIRED:
        require((ROOT / name).is_file(), f"Missing file: {name}")
        require((ROOT / name).stat().st_size > 0, f"Empty file: {name}")
    texts = {}
    for path in ROOT.rglob("*"):
        relative = path.relative_to(ROOT)
        if any(part in {".git", ".qa", "__pycache__"} for part in relative.parts):
            continue
        if path.is_file() and (path.suffix in {".md", ".svg", ".json", ".sh", ".ps1", ".py", ".cff", ".yml"}
                               or path.name in {"LICENSE", ".gitignore", ".gitattributes"}):
            text = path.read_text(encoding="utf-8")
            require(text.strip(), f"Empty text: {relative}")
            require("\ufffd" not in text, f"Invalid replacement character: {relative}")
            if path.suffix != ".py":
                require(not re.search(r"[A-Za-z]:[\\/]Users[\\/]|/Users/[^/\s]+/|/home/[^/\s]+/", text),
                        f"Potential personal absolute path: {relative}")
                require(not re.search(r"\b(?:TODO|FIXME|YOUR_USERNAME|YOUR_REPO)\b", text),
                        f"Unfinished scaffold: {relative}")
            texts[path] = text
    entry = texts[SKILL / "SKILL.md"]
    match = re.match(r"\A---\n(.*?)\n---\n", entry, re.S)
    require(match is not None, "Missing YAML frontmatter")
    front = yaml.safe_load(match.group(1))
    require(isinstance(front, dict) and front.get("name") == "claimscope", "Incorrect skill name")
    description = front.get("description")
    require(isinstance(description, str) and 0 < len(description) <= 1024, "Invalid description")
    require(len(entry.splitlines()) <= 120, "Entrypoint has grown beyond this package's 120-line budget")
    metadata = json.loads(texts[ROOT / "skill.json"])
    require(metadata["name"] == "claimscope" and metadata["display_name"] == "ClaimScope", "Brand mismatch")
    require(metadata["version"] == "1.0.0" and metadata["license"] == "MIT", "Release metadata mismatch")
    for name in [metadata["entrypoint"], *metadata["modules"]]:
        require((ROOT / name).is_file(), f"Broken metadata path: {name}")
    require(len(metadata["modules"]) == 5, "Expected five modules")
    citation = yaml.safe_load(texts[ROOT / "CITATION.cff"])
    require(citation.get("cff-version") == "1.2.0", "Incorrect CFF version")
    require(citation.get("version") == metadata["version"], "Citation version differs")
    require(citation.get("type") == "software" and citation.get("license") == "MIT",
            "Citation type or license differs")
    for key in ["title", "message"]:
        require(isinstance(citation.get(key), str) and citation[key].strip(), f"Missing citation {key}")
    for key in ["repository-code", "url"]:
        require(citation.get(key) == metadata["repository"], f"Citation {key} differs")
    require(citation.get("authors") == [{"alias": "huangjn58"}], "Unexpected citation identity")
    date.fromisoformat(str(citation["date-released"]))
    # BaseLoader avoids YAML 1.1 interpreting GitHub's 'on' key as a boolean.
    workflow = yaml.load(texts[ROOT / ".github/workflows/validate.yml"], Loader=yaml.BaseLoader)
    require(workflow["name"] == "ClaimScope Validation", "Unexpected workflow name")
    require(set(workflow["on"]["push"]["branches"]) == {"main", "dev"}
            and "pull_request" in workflow["on"], "Missing workflow triggers")
    require(workflow["permissions"] == {"contents": "read"}, "Unexpected CI permissions")
    steps = workflow["jobs"]["validate"]["steps"]
    require(any(step.get("run") == "python scripts/validate.py" for step in steps),
            "Workflow does not run package validation")
    require((ROOT / "LICENSE").read_bytes() == (SKILL / "LICENSE").read_bytes(), "License copy differs")
    if metadata["repository"] is None:
        print("NOTE: repository URL awaits maintainer-created remote; no URL was invented.")
    else:
        require(urlsplit(metadata["repository"]).scheme == "https", "Repository URL must use HTTPS")

    links = 0
    for path, text in texts.items():
        if path.suffix != ".md":
            continue
        require(sum(line.startswith("```") for line in text.splitlines()) % 2 == 0,
                f"Unclosed code fence: {path.relative_to(ROOT)}")
        targets = re.findall(r"\]\(([^)\s]+)\)", text)
        targets += re.findall(r'(?:src|href)=[\"\']([^\"\']+)[\"\']', text)
        for target in targets:
            parsed = urlsplit(target)
            if parsed.scheme or target.startswith("#"):
                continue
            resolved = (path.parent / unquote(parsed.path)).resolve()
            require(resolved == ROOT or ROOT in resolved.parents, f"Link escapes repository: {target}")
            require(resolved.exists(), f"Broken relative link in {path.name}: {target}")
            links += 1
    ns = "{http://www.w3.org/2000/svg}"
    for path in (ROOT / "assets").glob("*.svg"):
        svg = ET.fromstring(texts[path])
        require(svg.tag == ns + "svg" and svg.get("viewBox"), f"Invalid SVG root: {path.name}")
        for node in svg.iter():
            require(node.tag not in {ns + "script", ns + "foreignObject", ns + "image"},
                    f"Non-self-contained SVG: {path.name}")
            for key, value in node.attrib.items():
                require(not key.lower().startswith("on"), "SVG event handler found")
                if key.endswith("href"):
                    require(value.startswith("#"), "External SVG resource found")
                require("url(http" not in value, "External SVG URL found")
    for path in (ROOT / "examples").glob("*.md"):
        for heading in ["Problem", "Original", "Diagnosis", "Rewrite", "Why this works", "Rules activated"]:
            require(f"# {heading}\n" in texts[path], f"Missing example section: {path.name}: {heading}")
    require(b"\r\n" not in (ROOT / "install.sh").read_bytes(), "Bash installer requires LF line endings")
    print(f"PASS: {len(texts)} text files read; {links} relative links; YAML/JSON; four SVGs; examples; licenses.")
    print(f"Entrypoint: {len(entry.splitlines())} lines; description: {len(description)} characters.")
    print("Static validation does not prove automatic discovery, writing quality or native OS compatibility.")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, KeyError, ET.ParseError, yaml.YAMLError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        sys.exit(1)
