# myskills installer - PowerShell (Windows)
# Installs prompt files as slash commands for Claude Code, Cursor, Codex.
$ErrorActionPreference = 'Stop'
$src = Split-Path -Parent $MyInvocation.MyCommand.Path

$targets = @{
  'Claude Code' = Join-Path $HOME '.claude\commands'
  'Cursor'      = Join-Path $HOME '.cursor\commands'
  'Codex'       = Join-Path $HOME '.codex\prompts'
}

# source -> renamed destination (avoids safetoship collision)
$map = @(
  @{ s = 'frontend\angular\safetoship.md';     d = 'ng-safetoship.md' }
  @{ s = 'frontend\angular\safetoshiplite.md'; d = 'ng-safetoshiplite.md' }
  @{ s = 'frontend\hybris\safetoship.md';      d = 'hybris-safetoship.md' }
  @{ s = 'frontend\hybris\safetoshiplite.md';  d = 'hybris-safetoshiplite.md' }
  @{ s = 'general\befable\befablefull.md';      d = 'befablefull.md' }
  @{ s = 'general\befable\befablelite.md';       d = 'befablelite.md' }
  @{ s = 'general\befable\befableplan.md';       d = 'befableplan.md' }
  @{ s = 'general\befable\befablerun.md';        d = 'befablerun.md' }
)

Write-Host 'myskills installer'
foreach ($t in $targets.GetEnumerator()) {
  $dir = $t.Value
  New-Item -ItemType Directory -Force $dir | Out-Null
  $n = 0
  foreach ($m in $map) {
    $from = Join-Path $src $m.s
    if (Test-Path $from) {
      Copy-Item -Force $from (Join-Path $dir $m.d)
      $n++
    } else {
      Write-Host "  ! missing: $($m.s)"
    }
  }
  Write-Host "  [$($t.Key)] $n files -> $dir"
}
Write-Host 'Done. Use: /ng-safetoship /hybris-safetoship /befablefull etc.'
