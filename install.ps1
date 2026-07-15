# myskills installer - PowerShell (Windows)
# Installs ALL prompt .md files as slash commands for Claude Code, Cursor, Codex.
# New .md files are picked up automatically — no per-file list to maintain.
$ErrorActionPreference = 'Stop'
$src = Split-Path -Parent $MyInvocation.MyCommand.Path

$targets = @{
  'Claude Code' = Join-Path $HOME '.claude\commands'
  'Cursor'      = Join-Path $HOME '.cursor\commands'
  'Codex'       = Join-Path $HOME '.codex\prompts'
}

# dest name from relative path: frontend\angular\* -> ng-*, frontend\hybris\* -> hybris-*, else basename
function Get-DestName($rel) {
  $base = Split-Path -Leaf $rel
  $r = $rel -replace '\\', '/'
  if ($r -like 'frontend/angular/*') { return "ng-$base" }
  if ($r -like 'frontend/hybris/*')  { return "hybris-$base" }
  return $base
}

$files = @()
foreach ($root in @('frontend', 'general')) {
  $rootPath = Join-Path $src $root
  if (Test-Path $rootPath) {
    $files += Get-ChildItem -Path $rootPath -Recurse -File -Filter *.md
  }
}

Write-Host 'myskills installer'
foreach ($t in $targets.GetEnumerator()) {
  $dir = $t.Value
  New-Item -ItemType Directory -Force $dir | Out-Null
  $n = 0
  foreach ($f in $files) {
    $rel = $f.FullName.Substring($src.Length).TrimStart('\', '/')
    Copy-Item -Force $f.FullName (Join-Path $dir (Get-DestName $rel))
    $n++
  }
  Write-Host "  [$($t.Key)] $n files -> $dir"
}
Write-Host 'Done.'
