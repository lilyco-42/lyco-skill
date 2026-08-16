# lyco skill installer - works BOTH as a file and via `iex (irm ...)`
# (param() blocks only work in script files; iex treats them as expressions,
#  so we parse $args manually and keep everything ASCII-safe.)
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File install.ps1                # install to ~/.agents/skills/lyco
#   powershell -ExecutionPolicy Bypass -File install.ps1 -AllAgents     # install to ALL agents (needs node/npm)
#   iex (irm https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.ps1)   # one-line remote
$ErrorActionPreference = "Stop"

# --- parse args manually (works in both file and iex contexts) ---
$AllAgents = $false
foreach ($a in $args) {
    if ($a -eq "-AllAgents" -or $a -eq "-all" -or $a -eq "--all-agents") { $AllAgents = $true }
}

$Repo = "lilyco-42/lyco-skill"
$Branch = "main"
$SkillName = "lyco"
$Canonical = Join-Path $HOME ".agents\skills\$SkillName"
$TarballUrl = "https://github.com/$Repo/archive/refs/heads/$Branch.tar.gz"
$Info = "lyco: "

function Write-Step([string]$msg) { Write-Host "$Info$msg" -ForegroundColor Green }

# --- download & extract skill body (curl.exe / tar.exe ship with Win10+) ---
$tmp = Join-Path $env:TEMP "lyco-install"
if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
New-Item -ItemType Directory -Path $tmp -Force | Out-Null

Write-Step "Downloading $TarballUrl ..."
& curl.exe -fsSL $TarballUrl -o (Join-Path $tmp "lyco.tar.gz")
if ($LASTEXITCODE -ne 0) { throw "Download failed - check network/proxy" }

& tar.exe -xzf (Join-Path $tmp "lyco.tar.gz") -C $tmp
if ($LASTEXITCODE -ne 0) { throw "Extract failed" }

$src = Join-Path $tmp "$($Repo.Split('/')[1])-$Branch"
if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
    $src = Get-ChildItem $tmp -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } | Select-Object -First 1 -ExpandProperty FullName
}
if (-not $src) { throw "SKILL.md not found in archive" }

# --- install to canonical dir ---
$parent = Split-Path $Canonical -Parent
New-Item -ItemType Directory -Path $parent -Force | Out-Null
if (Test-Path $Canonical) { Remove-Item $Canonical -Recurse -Force }
Copy-Item $src $Canonical -Recurse
Remove-Item $tmp -Recurse -Force

# validate frontmatter
$fm = Get-Content (Join-Path $Canonical "SKILL.md") -TotalCount 5 | Where-Object { $_ -match "^name:" }
if ($fm -notmatch $SkillName) { throw "SKILL.md frontmatter check failed: $fm" }
Write-Step "Installed -> $Canonical (universal agents read this natively)"

# --- optional: all-agent install via skills CLI (vercel-labs) ---
if ($AllAgents) {
    if (-not (Get-Command skills -ErrorAction SilentlyContinue)) {
        Write-Step "skills CLI not found, installing (npm install -g skills) ..."
        npm install -g skills
        if ($LASTEXITCODE -ne 0) { throw "npm install skills failed" }
    }
    Write-Step "Installing to all agents (60+) ..."
    skills add "$Repo" --global --agent '*' --yes
    Write-Step "Done. Update: skills update lyco -g ; Remove: skills remove lyco --global --agent '*' --yes"
}

Write-Step "Install complete. Restart each agent session, then use /lyco"
