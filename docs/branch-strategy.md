# Branch strategy

| Git branch | Responsibility |
| --- | --- |
| `main` | Reviewed, stable release content |
| `dev` | Active development and integration |

Use focused feature branches from `dev` for larger changes. Review evidence boundaries,
examples, installer safety and both languages before merging a release into `main`.
For the first commit, bootstrap `main`, then create `dev` from the same commit.

Release tags identify reviewed snapshots: `v1.0.0`, `v1.1.0`, `v2.0.0`.
Use patch releases for corrections, minor releases for compatible additions, and major
releases for incompatible behavior or packaging changes.

Press-Release Principle, Scientific Boundaries, Doctoral Thesis Style, Reviewer
Response and Rewrite Examples are **modules**, not Git branches. Keep them together
in each release so relative references resolve consistently.

Branch names here describe policy. They do not imply a remote, commits, tags or releases
have already been created. A local initialization alone does not publish this project.
