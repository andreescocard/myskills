# myskills installer - PowerShell (Windows)
# Every folder holding a SKILL.md is a skill. The folder name is the command name.
#   Claude Code -> ~\.claude\skills\<name>\    (whole folder)
#   Codex       -> ~\.codex\skills\<name>\     (whole folder)
#   Cursor      -> ~\.cursor\commands\<name>.md (flattened: Cursor has commands, not skills)
# Options: -WithAgents    also copy agents\*.md to ~\.claude\agents
#          -WithSettings  print the settings snippet to merge by hand (never overwrites anything)
param([switch]$WithAgents, [switch]$WithSettings)
$ErrorActionPreference = 'Stop'
$src = Split-Path -Parent $MyInvocation.MyCommand.Path

$claudeSkills  = Join-Path $HOME '.claude\skills'
$claudeCmds    = Join-Path $HOME '.claude\commands'
$codexSkills   = Join-Path $HOME '.codex\skills'
$codexPrompts  = Join-Path $HOME '.codex\prompts'
$cursorCmds    = Join-Path $HOME '.cursor\commands'

# every SKILL.md outside hidden folders
$files = Get-ChildItem -Path $src -Recurse -File -Filter SKILL.md |
  Where-Object { $_.FullName.Substring($src.Length) -notmatch '[\\/]\.' } |
  Sort-Object FullName

function Install-Skills($dir, $label) {
  New-Item -ItemType Directory -Force $dir | Out-Null
  foreach ($f in $files) {
    $name = $f.Directory.Name
    $dest = Join-Path $dir $name
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse -Force $f.Directory.FullName $dest
  }
  Write-Host "  [$label] $($files.Count) skills -> $dir"
}

Write-Host 'myskills installer'
Install-Skills $claudeSkills 'Claude Code'
Install-Skills $codexSkills 'Codex'

New-Item -ItemType Directory -Force $cursorCmds | Out-Null
foreach ($f in $files) { Copy-Item -Force $f.FullName (Join-Path $cursorCmds "$($f.Directory.Name).md") }
Write-Host "  [Cursor] $($files.Count) commands -> $cursorCmds"

# older versions installed flat .md commands; remove those copies so a skill is not listed twice
foreach ($f in $files) {
  $n = "$($f.Directory.Name).md"
  Remove-Item -Force -ErrorAction SilentlyContinue (Join-Path $claudeCmds $n), (Join-Path $codexPrompts $n)
}

if ($WithAgents) {
  $agentDir = Join-Path $HOME '.claude\agents'
  New-Item -ItemType Directory -Force $agentDir | Out-Null
  $agents = Get-ChildItem (Join-Path $src 'agents') -Filter *.md
  Copy-Item -Force $agents.FullName $agentDir
  Write-Host "  [Agents] $($agents.Count) agents -> $agentDir"
}

if ($WithSettings) {
  Write-Host ''
  Write-Host 'Merge this into ~\.claude\settings.json by hand (nothing was changed):'
  Get-Content (Join-Path $src 'setup\settings.snippet.json')
  Write-Host ''
  Write-Host "Routing rules for your CLAUDE.md: $(Join-Path $src 'setup\CLAUDE.model-routing.md')"
}
Write-Host 'Done.'
