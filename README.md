[English](README.md) | [简体中文](README.zh-CN.md)

# ClaimScope

**Strong claims. Exact boundaries. Evidence first.**

A modular academic-writing skill that aligns claims, evidence, scientific scope,
paper narrative, and reviewer response.

![ClaimScope: claim, evidence, scope and narrative](assets/cover.svg)

![Codex Skill](https://img.shields.io/badge/Codex-Skill-167D63)
![Academic Writing](https://img.shields.io/badge/Academic-Writing-374151)
[![MIT License](https://img.shields.io/badge/License-MIT-A64059)](LICENSE)

**Write the strongest claim your evidence can actually support.**

ClaimScope is not designed merely to make academic prose sound more human. It helps
researchers decide not only *how to write a sentence*, but *what the evidence actually
allows the paper to claim*.

## A better claim, not just a stronger sentence

*Fictional illustration: the supplied observations establish an X–Y association in
the tested conditions, not a causal mechanism.*

| Defensive | Overstated | ClaimScope |
| --- | --- | --- |
| Although the present study provides useful observations, only the investigated loading conditions were considered, so the results should be interpreted cautiously. | The results universally establish the governing mechanism. | Under the investigated loading conditions, the results identify a consistent relationship between X and Y. |

**Not weaker. Not overstated. Precisely scoped.**

Start with six decisions: What can the paper claim? What evidence supports it? What
scope is justified? What belongs in the main narrative? What should this section do?
Does the reviewer concern really require more experiments?

## Why another academic-writing skill?

| Tool type | Primary focus | Typical level |
| --- | --- | --- |
| Humanizer | AI-like wording, rhythm, repetition and stylistic artifacts | Sentence |
| Academic polishing | Grammar, fluency, formal tone and readability | Sentence / paragraph |
| Anti-defensive writing | Unnecessary hedging, disclaimers and self-weakening | Sentence / framing |
| ClaimScope | Claim–evidence–scope–narrative alignment | Sentence → paragraph → section → paper → rebuttal |

This is a difference in scope and workflow, not a ranking. These categories overlap
and can complement one another. **ClaimScope operates from sentence-level revision
to paper-level scientific argumentation.** It is not an empirical fact checker,
grammar engine, plagiarism service or guarantee of publication acceptance.

## Core philosophy

Scientific integrity comes first. Claim–evidence alignment determines how far a claim
can go. The Press-Release Principle gives the strongest supported contribution a
clear narrative. Scientific boundaries preserve real limitations. Section-specific
logic gives each part a job. Reviewer-response realism avoids inventing completed
work or committing the author to unnecessary research.

Priority: truth and evidence boundaries → user facts and constraints → claim–evidence
consistency → Press-Release Principle → anti-defensive writing → section logic →
concision → style. No rule authorizes hiding decisive negative results.

## Architecture

![ClaimScope architecture](assets/architecture.svg)

Scientific Integrity → Claim–Evidence Alignment → Press-Release Principle + Scientific
Boundaries → Thesis Style + Reviewer Response → Evidence-based Academic Revision.
The entrypoint loads only applicable references, rather than the whole instruction library.

## Five modules

### 01 · [Press-Release Principle](skill/claimscope/references/press-release-principle.md)
**What deserves the spotlight?**
- Frame the strongest supported contribution.
- Assign an argumentative duty to each experiment.
- Replace the project diary with a paper narrative.
- Report relevant adverse results without inventing a global failure.

### 02 · [Scientific Boundaries](skill/claimscope/references/scientific-boundaries.md)
**How strong can this claim legitimately be?**
- Classify disclaimers, scope, limitations, uncertainty, contrasts and repetition.
- Convert negative framing into positive scope.
- Retain decisive methodological limitations.
- Calibrate causal strength and extrapolation.

### 03 · [Doctoral Thesis Style](skill/claimscope/references/doctoral-thesis-style.md)
**What should this section actually do?**
- Connect the question, gap and contribution.
- Distinguish methods, observations and interpretations.
- Keep chapter-level and thesis-level claims aligned.
- Preserve the language and terminology of the discipline.

### 04 · [Reviewer Response](skill/claimscope/references/reviewer-response.md)
**Does this reviewer comment really require another experiment?**
- Clarify the actual concern.
- Reorganize existing evidence and define scope.
- Adjust unsupported claims before expanding research.
- Distinguish completed edits from proposed commitments.

### 05 · [Rewrite Examples](skill/claimscope/references/rewrite-examples.md)
**What does a better revision actually look like?**
- Follow Before → Diagnosis → After → Why.
- Compare empty caution with necessary uncertainty.
- Practice English and Chinese scope calibration.
- Include cases where no deletion is warranted.

![Five-module map](assets/module-map.svg)

## Repository structure

```text
ClaimScope/
├── README.md
├── README.zh-CN.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
├── .gitignore
├── .gitattributes
├── skill/
│   └── claimscope/
│       ├── SKILL.md
│       ├── LICENSE
│       └── references/
│           ├── press-release-principle.md
│           ├── scientific-boundaries.md
│           ├── doctoral-thesis-style.md
│           ├── reviewer-response.md
│           └── rewrite-examples.md
├── examples/
│   ├── 01-defensive-writing.md
│   ├── 02-abstract.md
│   ├── 03-introduction.md
│   ├── 04-results.md
│   ├── 05-discussion.md
│   ├── 06-conclusion.md
│   └── 07-reviewer-response.md
├── prompts/
│   ├── quick-prompt.md
│   └── quick-prompt-zh.md
├── assets/
│   ├── cover.svg
│   ├── architecture.svg
│   ├── workflow.svg
│   ├── module-map.svg
│   └── social-preview.png
├── docs/
│   ├── github-metadata.md
│   ├── branch-strategy.md
│   ├── release-v1.0.0.md
│   ├── acknowledgements.md
│   └── validation.md
├── scripts/
│   └── validate.py
├── install.ps1
├── install.sh
└── skill.json
```

Only `skill/claimscope/` is installed. Examples, prompts, visuals and documentation
are repository resources, not extra loaded instructions. `skill.json` is descriptive
project metadata, not an official Codex plugin manifest.

## Installation

Download or clone the repository, open its folder and inspect the installer before
running it. No network downloads, model dependencies or credentials are needed by the
installers. PowerShell 5.1+ or Bash 3.2+ with standard filesystem utilities is required.

### Windows

```powershell
.\install.ps1
```

Default: `%USERPROFILE%\.codex\skills\claimscope\`.
If Windows blocks a downloaded script, inspect it and follow your organization's
execution-policy process; this project does not change machine-wide security settings.

### macOS / Linux

```bash
bash install.sh
```

Default: `~/.codex/skills/claimscope/`. Both installers respect `CODEX_HOME` when set.

### Discovery-path compatibility

This package retains the requested `.codex/skills` default used by the source setup.
[Current Codex documentation](https://learn.chatgpt.com/docs/build-skills) lists
`~/.agents/skills` for user skills. If that is the directory your version scans, use:

```powershell
.\install.ps1 -SkillsRoot (Join-Path $HOME '.agents/skills')
```

```bash
bash install.sh --skills-root "$HOME/.agents/skills"
```

Install into one scanned location, not both. Confirm discovery in your own Codex version.
Open a new session; restart Codex if an updated skill does not appear. Automatic selection
depends on the task and other installed skills; explicit invocation is the clearest check.

### Backup and manual installation

Existing `claimscope` installations are moved to the skills root's sibling
`skill-backups/claimscope.backup-YYYYMMDD-HHMMSS-…` before replacement. Backups stay
outside the scanned skills folder. Files are staged and checked before replacement;
failed installation attempts retain diagnostic staging files and attempt restoration.
Installers refuse linked targets and do not delete skill content. They never modify
the local source skill `academic-writing` or unrelated skills.

For manual installation, back up an existing destination first, then copy the entire
`skill/claimscope/` folder, including its LICENSE, to `~/.codex/skills/claimscope/`
(or the actual user skill directory for your version). Do not copy the repository root.

## How to use

### Automatic discovery

```text
Revise this PhD thesis paragraph while preserving all data and scientific meaning.
```

### Explicit use

```text
Use $claimscope to revise this discussion section.
```

```text
使用 $claimscope 修改这段博士论文，保持数据和科学含义不变。
```

Provide the passage and relevant evidence. Missing evidence is flagged, not invented.
By default, a revision returns usable text; request rationale or an audit when needed.

![Revision workflow](assets/workflow.svg)

## Usage scenarios

| Task | Intended outcome |
| --- | --- |
| PhD thesis revision | Coherent chapter and thesis claims |
| Abstract | Problem, method, key findings and bounded contribution |
| Introduction | Question, verified gap and contribution |
| Literature review | Question-led synthesis, not an author list |
| Methods | Reproducible procedure and accurate boundaries |
| Results | Observations and quantitative evidence, including adverse findings |
| Discussion | Mechanism reasoning proportionate to evidence |
| Conclusions | Answers supported by the body of the paper |
| Reviewer response | Evidence-based replies without invented commitments |
| Defensive-writing audit | Functional classification before deletion |
| Scientific-boundary audit | Accurate uncertainty, causality and scope |
| Conservative revision | Minimal edits with meaning preserved |
| Deep restructuring | A contribution-led argument without evidence loss |

Use the [English prompts](prompts/quick-prompt.md) or [中文提示词](prompts/quick-prompt-zh.md).

## Examples

Seven fictional cases in [examples/](examples/): [defensive wording](examples/01-defensive-writing.md),
[abstract](examples/02-abstract.md), [introduction](examples/03-introduction.md),
[results](examples/04-results.md), [discussion](examples/05-discussion.md),
[conclusion](examples/06-conclusion.md) and [reviewer response](examples/07-reviewer-response.md).
They contain no private manuscripts or actual research data.

## Branches and release

`main` is for stable releases; `dev` is for active development. The five components
above are **modules, not Git branches**. See the [branch strategy](docs/branch-strategy.md).
The first release package is **v1.0.0**; [release notes](docs/release-v1.0.0.md) and
[changelog](CHANGELOG.md) are prepared. A version label here does not claim a remote
release has already been published.

## Validation

Run `python scripts/validate.py` with Python 3.9+ and PyYAML. See the
[validation record](docs/validation.md) for tested environments and remaining limits.
Static package checks are not a guarantee of model behavior or automatic invocation.

## Acknowledgements and license

Inspired by [Adkid-Zephyr's Press-Release Principle](https://github.com/Adkid-Zephyr/anti-defensive-writing-Skill)
and [Kiterlin's scientific-boundary distinctions](https://github.com/Kiterlin/anti-defensive-writing).
See [provenance and preserved notices](docs/acknowledgements.md).
ClaimScope is distributed under the [MIT License](LICENSE).

## Contribute

Star the project if it is useful. Open an issue, propose a focused pull request, or
contribute a privacy-safe example. Read [CONTRIBUTING](CONTRIBUTING.md) before sharing material.
