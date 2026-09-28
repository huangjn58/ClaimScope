#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source_dir="$script_dir/skill/claimscope"
skills_root="${CODEX_HOME:-$HOME/.codex}/skills"
if [[ $# -gt 0 ]]; then
  if [[ $# -ne 2 || "$1" != '--skills-root' || -z "$2" ]]; then
    printf 'Usage: bash install.sh [--skills-root PATH]\n' >&2
    exit 2
  fi
  skills_root="$2"
fi

for file in SKILL.md LICENSE references/press-release-principle.md \
  references/scientific-boundaries.md references/doctoral-thesis-style.md \
  references/reviewer-response.md references/rewrite-examples.md; do
  [[ -f "$source_dir/$file" ]] || { printf 'Missing package file: %s\n' "$file" >&2; exit 1; }
done
grep -Eq '^name: claimscope[[:space:]]*$' "$source_dir/SKILL.md" || { printf 'Invalid skill name.\n' >&2; exit 1; }
[[ -z "$(find "$source_dir" -type l -print)" ]] || { printf 'Linked source refused.\n' >&2; exit 1; }

assert_no_links() {
  local cursor="$1"
  [[ "$cursor" = /* ]] || cursor="$PWD/$cursor"
  while [[ "$cursor" != / && "$cursor" != . ]]; do
    [[ ! -L "$cursor" ]] || { printf 'Symlink refused: %s\n' "$cursor" >&2; exit 1; }
    cursor="$(dirname -- "$cursor")"
  done
}
assert_no_links "$source_dir"
assert_no_links "$skills_root"
mkdir -p -- "$skills_root"
skills_root="$(cd -- "$skills_root" && pwd -P)"
[[ "$skills_root" != / ]] || { printf 'Skills root cannot be /.\n' >&2; exit 1; }
parent="$(dirname -- "$skills_root")"
target="$skills_root/claimscope"
case "$target/" in "$source_dir/"*) printf 'Source and target overlap.\n' >&2; exit 1;; esac
case "$source_dir/" in "$target/"*) printf 'Source and target overlap.\n' >&2; exit 1;; esac
backup_root="$parent/skill-backups"
assert_no_links "$target"
assert_no_links "$backup_root"
[[ ! -e "$target" || -d "$target" ]] || { printf 'Target is not a directory.\n' >&2; exit 1; }
lock="$parent/.claimscope-install.lock"
mkdir -- "$lock" || { printf 'Install lock exists; check for another installer.\n' >&2; exit 1; }
stage=''
backup=''
finish() {
  local status=$?
  trap - EXIT
  if [[ $status -ne 0 ]]; then
    if [[ -n "$backup" && -d "$backup" && ! -e "$target" && ! -L "$target" ]]; then
      mv -- "$backup" "$target" || printf 'Automatic restore failed; backup: %s\n' "$backup" >&2
    fi
    [[ -z "$stage" || ! -d "$stage" ]] || printf 'Staging files retained: %s\n' "$stage" >&2
  fi
  rmdir -- "$lock" || true
  exit "$status"
}
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
stage="$(mktemp -d "$parent/.claimscope-stage.XXXXXX")"
cp -R -- "$source_dir/." "$stage/"
diff -r -- "$source_dir" "$stage" >/dev/null
if [[ -d "$target" ]]; then
  mkdir -p -- "$backup_root"
  backup="$backup_root/claimscope.backup-$(date +%Y%m%d-%H%M%S)-$$"
  [[ ! -e "$backup" ]] || { printf 'Backup collision; retry.\n' >&2; exit 1; }
  mv -- "$target" "$backup"
  printf 'Previous installation preserved at: %s\n' "$backup"
fi
mv -- "$stage" "$target"
printf 'Installed ClaimScope: %s\n' "$target"
printf 'Open a new Codex session and explicitly invoke $claimscope to check discovery.\n'
