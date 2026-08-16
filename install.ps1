# lyco skill 一键安装脚本 (Windows / PowerShell 原生, 无 bash 依赖)
# 用法:
#   powershell -ExecutionPolicy Bypass -File install.ps1            # 装到 ~/.agents/skills/lyco (universal)
#   powershell -ExecutionPolicy Bypass -File install.ps1 -AllAgents # 装到所有 agent (需 node/npm)
#   iex (irm https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.ps1)   # 一行远程执行
param(
    [switch]$AllAgents,
    [string]$Repo = "lilyco-42/lyco-skill",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
$SkillName = "lyco"
$Canonical = Join-Path $HOME ".agents\skills\$SkillName"
$TarballUrl = "https://github.com/$Repo/archive/refs/heads/$Branch.tar.gz"
$Info = "lyco: "

function Write-Step([string]$msg) { Write-Host "$Info$msg" -ForegroundColor Green }

# --- 下载并解压技能本体 (curl.exe / tar.exe 均为 Win10+ 自带) ---
$tmp = Join-Path $env:TEMP "lyco-install"
if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
New-Item -ItemType Directory -Path $tmp -Force | Out-Null

Write-Step "下载 $TarballUrl ..."
& curl.exe -fsSL $TarballUrl -o (Join-Path $tmp "lyco.tar.gz")
if ($LASTEXITCODE -ne 0) { throw "下载失败, 请检查网络/代理" }

& tar.exe -xzf (Join-Path $tmp "lyco.tar.gz") -C $tmp
if ($LASTEXITCODE -ne 0) { throw "解压失败" }

$src = Join-Path $tmp "$($Repo.Split('/')[1])-$Branch"
if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
    # 分支名含 / 时 tar 目录名可能是 lyco-skill-main, 兜底扫描
    $src = Get-ChildItem $tmp -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } | Select-Object -First 1 -ExpandProperty FullName
}
if (-not $src) { throw "未找到 SKILL.md" }

# --- 安装到 canonical 目录 ---
$parent = Split-Path $Canonical -Parent
New-Item -ItemType Directory -Path $parent -Force | Out-Null
if (Test-Path $Canonical) { Remove-Item $Canonical -Recurse -Force }
Copy-Item $src $Canonical -Recurse
Remove-Item $tmp -Recurse -Force

# 校验 frontmatter
$fm = Get-Content (Join-Path $Canonical "SKILL.md") -TotalCount 5 | Where-Object { $_ -match "^name:" }
if ($fm -notmatch $SkillName) { throw "SKILL.md frontmatter 校验失败: $fm" }
Write-Step "已安装 -> $Canonical (universal agents: Codex/Gemini CLI/Copilot/OpenCode/Kimi 等原生读取)"

# --- 可选: 全支持 (skills CLI, vercel-labs) ---
if ($AllAgents) {
    if (-not (Get-Command skills -ErrorAction SilentlyContinue)) {
        Write-Step "未检测到 skills CLI, 正在安装 (npm install -g skills) ..."
        npm install -g skills
        if ($LASTEXITCODE -ne 0) { throw "npm 安装 skills 失败" }
    }
    Write-Step "安装到所有 agent (60+) ..."
    skills add "$Repo" --global --agent '*' --yes
    Write-Step "完成. 更新: skills update lyco -g ; 卸载: skills remove lyco --global --agent '*' --yes"
}

Write-Step "安装完成. 各 agent 重启会话后可用 /lyco 调用"
