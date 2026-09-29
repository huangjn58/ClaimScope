# Validation record

Checked on 2026-09-28. These are packaging and installer checks, not a writing-quality
benchmark or proof that every Codex version will automatically select this skill.

## Package

- The bundled skill-creator validator accepted `skill/claimscope/SKILL.md`.
- The public validator reads UTF-8 text, checks YAML and JSON, local Markdown links,
  required files, example structure, SVG XML, license copies and obvious private paths.
- The entrypoint remains modular; five references resolve within the installable folder.
- Public examples are fictional and explicitly label their evidence premises.
- The source skill's six file hashes were compared before and after packaging.
- `repository` points to the maintainer-provided `https://github.com/huangjn58/ClaimScope`.

## Installation tests

Windows PowerShell 5.1 and PowerShell 7.6.5 were exercised on Windows. Bash was exercised with Git Bash on Windows,
using standard Unix utilities and isolated fixture directories with spaces in their names.
The tests covered first install, a second install, preservation of a local edit in
backup, removal of stale files from the new version by replacement rather than merging,
preservation of an unrelated sibling skill, existing-lock refusal, missing-source
refusal and source/target-overlap refusal.
Both installers also restored the previous version after an injected failure of the
staging-to-target move and released their lock. PowerShell refused a junction target.

PowerShell syntax was checked with its parser; Bash syntax was checked with `bash -n`.
No test installed ClaimScope into the actual global skills directory. No private
source skill, user configuration, remote repository or credentials were modified.
The Windows PowerShell 5.1 test used an authorized process-only execution-policy override;
the machine's persistent execution policy was not changed.

The initial Git Bash launch lacked Unix utilities on PATH; adding `/usr/bin` and
`/bin` to that test process resolved tool discovery. Its sandbox also denied traversal
of a Windows parent directory, so the same isolated tests were rerun with authorized
host execution. These were test-environment issues, not changes to installation logic.

Native macOS and native Linux have **not** been exercised. Bash portability is based
on the script's use of Bash 3.2-compatible syntax and common filesystem utilities,
not an actual native-platform test. Power loss, forced process termination and hostile
concurrent filesystem changes are outside the checks; a stale lock or staging directory
may need inspection before retrying. Never delete them blindly.

## Visual assets

All four SVGs were opened in headless Microsoft Edge through Playwright. Text bounding
boxes stayed inside their viewBoxes, screenshots were nonblank, and rendered images
were visually inspected at README width for overflow, collisions and legibility.
They use no scripts, images, local font files or external resources.

`social-preview.png` is an aspect-preserving, padded render of the cover at 1280 × 640,
below GitHub's 1 MB limit. SVG syntax checks do not replace visual inspection after edits.

## Discovery review

The description covers thesis revision, abstracts, introductions, results, discussions,
conclusions, reviewer response, defensive language and scope calibration in English
and Chinese. An audit-only request is explicitly distinct from a rewrite request.
This is a semantic review, **not** an independently measured invocation success rate.
Automatic selection can overlap other writing skills; use `$claimscope` when selection
must be explicit. Verify the scanned user directory for the installed Codex version.

## v1.0.0 release closeout

- A fresh clone from the public GitHub remote was tested, rather than installing
  from the development tree. The cloned PowerShell installer ran twice with an
  isolated `CODEX_HOME`; all seven installed files and the retained backup matched
  the cloned package by SHA-256. No actual global skill was replaced.
- Git Bash accepted the cloned `install.sh` with `bash -n`.
- The package validator now checks citation fields and workflow triggers as well
  as the existing package checks. CI runs the same validator on `main`, future
  `dev` pushes and pull requests, with read-only repository permissions.
- `CITATION.cff` passed the official CFF 1.2.0 JSON Schema with format checking.
  Its author is the public alias `huangjn58`, not an inferred legal name.
  The offline package validator checks required citation fields and consistency;
  it does not claim to implement the complete CFF schema.
- The GitHub README cover was visually inspected in Edge. Existing SVG embeddings
  were retained. The social preview is 1280 by 640 pixels and 153132 bytes.
- Examples and prompts were reread: they use fictional premises and `$claimscope`,
  with no private manuscript, unpublished dataset or confidential reviewer text found.

## Recheck commands

```bash
python -m pip install PyYAML
python scripts/validate.py
bash -n install.sh
```

The first command is needed only when PyYAML is absent. Validation has no network
requirement once dependencies exist. Test installers using their custom skills-root
option and a disposable directory; do not use the actual global directory for tests.
No automatic publication, remote configuration or first commit is performed by validation.
