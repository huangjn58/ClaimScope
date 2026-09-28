# Contributing to ClaimScope

Contributions are welcome: bug reports, stronger rewrite examples, rule refinements,
additional academic-writing scenarios, documentation fixes and improved translations.

## Propose a focused change

Open an issue describing the scientific-writing problem, the current behavior and the
desired behavior. Use a fictional or explicitly authorized excerpt. For a pull request,
branch from `dev` once that branch exists; use `main` for the initial bootstrap.
Explain which module changes and how the change preserves scientific boundaries.

## Evidence before style

Do not make examples persuasive by inventing supporting facts. State a fictional
evidence premise, then keep the rewrite within it. Include both a false-positive case
(a necessary qualification that must remain) and a positive case for a new deletion rule.
Keep entrypoint instructions short and place conditional details in references.

Do not submit private manuscripts, confidential review reports, unauthorized full-text
publications, personal information, credentials or fabricated citations. Contributions
must be yours to share. This project does not promise AI-detector evasion or publication
acceptance. Authors remain responsible for the accuracy of resulting manuscripts.

## Check before submitting

- Run `python scripts/validate.py` (Python 3.9+ with PyYAML installed).
- Inspect both READMEs and all relative links changed by your patch.
- Open modified SVGs in a browser and inspect text at README size.
- Test installer changes against an isolated skills root, including a second install.
- Ensure backups preserve local changes and unrelated skills remain untouched.
- Update the changelog for user-visible changes and retain attribution.

Contributions are provided under the project's MIT license. No new test may require
private research data, external credentials or changes to a real user's skill directory.
