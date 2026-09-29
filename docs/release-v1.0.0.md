# ClaimScope v1.0.0 — Strong claims. Exact boundaries. Evidence first.

First public release. These notes accompany the reviewed `v1.0.0` tag;
publishing the GitHub Release is a separate maintainer action.

ClaimScope is a modular academic-writing skill for claim–evidence–scope alignment.
It helps researchers decide what their evidence permits them to claim, how to organize
that claim, and where necessary scientific boundaries belong.

## Included

- Five modules: Press-Release Principle, Scientific Boundaries, Doctoral Thesis Style,
  Reviewer Response and Rewrite Examples.
- Doctoral-thesis and journal-paper revision, from sentences to whole-paper structure.
- Function-based defensive-writing review that preserves real methodological limits.
- Scientific scope calibration and evidence-first contribution framing.
- Reviewer responses without automatic research expansion or fictional revisions.
- English and Chinese documentation and reusable prompts.
- Seven fictional examples, including negative results and necessary uncertainty.
- Four editable SVG visuals and a social-preview PNG.
- Backup-first PowerShell and Bash installation with an isolated-test option.
- GitHub Actions validation for package structure, references, links and SVGs.
- CFF 1.2.0 citation metadata and bilingual validation badges.

## Install

Download the repository contents, inspect the scripts, then run `./install.ps1` in
PowerShell or `bash install.sh` on macOS/Linux from the repository folder. The package
targets `~/.codex/skills/claimscope/` by default, or `$CODEX_HOME/skills/claimscope/`
when that environment variable is set. See the [README](../README.md) for compatibility
and manual installation details.

## Limits and attribution

ClaimScope is an instruction-based skill, not an empirical fact checker or a guarantee
of publication acceptance. Human authors must verify evidence, citations and final claims.
Packaging and installer checks do not constitute a model-behavior benchmark.

Released under [MIT](../LICENSE), with attribution to
[Adkid-Zephyr and Kiterlin](acknowledgements.md).
