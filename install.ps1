[CmdletBinding()]
param(
    [string]$SkillsRoot = $(if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME 'skills' } else { Join-Path $HOME '.codex/skills' })
)

$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'skill/claimscope'
$required = @('SKILL.md', 'LICENSE', 'references/press-release-principle.md',
    'references/scientific-boundaries.md', 'references/doctoral-thesis-style.md',
    'references/reviewer-response.md', 'references/rewrite-examples.md')
foreach ($relative in $required) {
    $file = Join-Path $source $relative
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw "Missing package file: $relative" }
}
if ((Get-Content -LiteralPath (Join-Path $source 'SKILL.md') -Encoding UTF8 -Raw) -notmatch '(?m)^name: claimscope\s*$') {
    throw 'Invalid skill name in source package.'
}

function Assert-NoReparsePoint([string]$Path) {
    $cursor = [IO.Path]::GetFullPath($Path)
    while ($cursor) {
        if (Test-Path -LiteralPath $cursor) {
            $item = Get-Item -LiteralPath $cursor -Force
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Refusing a symlink or junction: $cursor"
            }
        }
        $next = [IO.Path]::GetDirectoryName($cursor)
        if ($next -eq $cursor) { break }
        $cursor = $next
    }
}

$root = [IO.Path]::GetFullPath($SkillsRoot)
$parent = [IO.Path]::GetDirectoryName($root)
if (-not $parent) { throw 'SkillsRoot must not be a filesystem root.' }
$target = Join-Path $root 'claimscope'
if ($target.Equals($source, [StringComparison]::OrdinalIgnoreCase) -or
    $source.StartsWith($target + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase) -or
    $target.StartsWith($source + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Source and installation target must not overlap.'
}
$backupRoot = Join-Path $parent 'skill-backups'
$lock = Join-Path $parent '.claimscope-install.lock'
Assert-NoReparsePoint $source
Assert-NoReparsePoint $target
Assert-NoReparsePoint $backupRoot
if (Test-Path -LiteralPath $target) {
    if (-not (Test-Path -LiteralPath $target -PathType Container)) { throw "Target is not a directory: $target" }
}
Get-ChildItem -LiteralPath $source -Force -Recurse | ForEach-Object {
    if ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Linked source file refused: $($_.FullName)" }
}
[IO.Directory]::CreateDirectory($root) | Out-Null
# The lock and staging folder sit outside skills discovery, as do retained backups.
New-Item -ItemType Directory -Path $lock -ErrorAction Stop | Out-Null
$stage = Join-Path $parent ('.claimscope-stage-' + [guid]::NewGuid().ToString('N'))
$backup = $null
try {
    Copy-Item -LiteralPath $source -Destination $stage -Recurse
    $sourceFiles = @(Get-ChildItem -LiteralPath $source -Recurse -Force -File)
    $stageFiles = @(Get-ChildItem -LiteralPath $stage -Recurse -Force -File)
    if ($sourceFiles.Count -ne $stageFiles.Count) { throw 'Staging file count mismatch.' }
    foreach ($file in $sourceFiles) {
        $relative = $file.FullName.Substring($source.Length + 1)
        if ((Get-FileHash -LiteralPath $file.FullName).Hash -ne
            (Get-FileHash -LiteralPath (Join-Path $stage $relative)).Hash) {
            throw "Staging verification failed: $relative"
        }
    }
    if (Test-Path -LiteralPath $target) {
        [IO.Directory]::CreateDirectory($backupRoot) | Out-Null
        $backup = Join-Path $backupRoot ('claimscope.backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
        Move-Item -LiteralPath $target -Destination $backup
        Write-Output "Previous installation preserved at: $backup"
    }
    Move-Item -LiteralPath $stage -Destination $target
    Write-Output "Installed ClaimScope: $target"
    Write-Output 'Open a new Codex session and explicitly invoke $claimscope to check discovery.'
} catch {
    if ($backup -and (Test-Path -LiteralPath $backup) -and -not (Test-Path -LiteralPath $target)) {
        Move-Item -LiteralPath $backup -Destination $target
        Write-Warning 'Restored previous installation.'
    }
    if (Test-Path -LiteralPath $stage) { Write-Warning "Staging files retained for inspection: $stage" }
    throw
} finally {
    # Non-recursive removal of our empty lock only; no skill content is deleted.
    [IO.Directory]::Delete($lock, $false)
}
