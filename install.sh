#!/usr/bin/env bash
# lyco skill 一键安装脚本
# 用法:
#   bash install.sh [dsh|opencode|claude]   # 单装（默认 all: 三个主环境）
#   bash install.sh --all-agents            # 全支持: 用 skills CLI (vercel-labs) 装到 60+ agent
# 支持: Linux / macOS / Windows(Git Bash / WSL / Termux)
set -euo pipefail

SKILL_NAME="lyco"
REPO_URL="https://github.com/lilyco-42/lyco-skill.git"
TARBALL_URL="https://github.com/lilyco-42/lyco-skill/archive/refs/heads/main.tar.gz"

declare -A TARGETS=(
  [dsh]="$HOME/.agents/skills/$SKILL_NAME"
  [opencode]="$HOME/.config/opencode/skills/$SKILL_NAME"
  [claude]="$HOME/.claude/skills/$SKILL_NAME"
)

info() { printf '\033[32m[lyco]\033[0m %s\n' "$*"; }
warn() { printf '\033[33m[lyco]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[31m[lyco] 失败: %s\033[0m\n' "$*" >&2; exit 1; }

# --- 下载源技能到临时目录 ---
fetch_src() {
    local src; src="$(mktemp -d)"
    if command -v git >/dev/null 2>&1; then
        git clone --depth 1 "$REPO_URL" "$src/repo" >/dev/null 2>&1 \
            || die "git clone 失败，请检查网络/代理"
        mv "$src/repo" "$src/skill"
    elif command -v curl >/dev/null 2>&1; then
        curl -fsSL "$TARBALL_URL" -o "$src/lyco.tar.gz" || die "tarball 下载失败"
        tar -xzf "$src/lyco.tar.gz" -C "$src"
        mv "$src/lyco-skill-main" "$src/skill"
    else
        die "既没有 git 也没有 curl，无法安装"
    fi
    # 只取技能本体（SKILL.md + resources），不带 README/install.sh
    mkdir -p "$src/body"
    cp -r "$src/skill/SKILL.md" "$src/body/"
    [[ -d "$src/skill/resources" ]] && cp -r "$src/skill/resources" "$src/body/"
    printf '%s' "$src/body"
}

# --- 安装到单个目标（覆盖式同步） ---
install_one() {
    local agent="$1" target="$2" src="$3"
    mkdir -p "$(dirname "$target")"
    rm -rf "$target"
    cp -r "$src" "$target"
    if [[ -f "$target/SKILL.md" ]] && grep -q "^name: $SKILL_NAME$" "$target/SKILL.md"; then
        info "✓ $agent -> $target (校验通过)"
    else
        warn "✗ $agent -> $target (SKILL.md 校验失败)"
    fi
}

# --- 主流程 ---
AGENT="${1:-all}"

# 全支持模式：用 vercel-labs/skills CLI 装到所有 agent（universal 目录 + 各 agent junction）
if [[ "$AGENT" == "--all-agents" ]]; then
    if command -v skills >/dev/null 2>&1; then
        skills add lilyco-42/lyco-skill --global --agent '*' --yes
        info "已装到所有支持的 agent。"
        info "更新: skills update lyco -g ; 卸载: skills remove lyco --global --agent '*' --yes"
        exit 0
    else
        info "未检测到 skills CLI，先安装: npm install -g skills"
        npm install -g skills
        skills add lilyco-42/lyco-skill --global --agent '*' --yes
        exit 0
    fi
fi

SRC="$(fetch_src)"

case "$AGENT" in
    dsh)     install_one dsh     "${TARGETS[dsh]}"     "$SRC" ;;
    opencode) install_one opencode "${TARGETS[opencode]}" "$SRC" ;;
    claude)  install_one claude  "${TARGETS[claude]}"  "$SRC" ;;
    all)
        for agent in dsh opencode claude; do
            install_one "$agent" "${TARGETS[$agent]}" "$SRC"
        done
        ;;
    *) die "未知目标: $AGENT (可选 dsh / opencode / claude / all)" ;;
esac

rm -rf "$(dirname "$SRC")"
info "完成。各 agent 重启会话后可用 /$SKILL_NAME 调用"
info "dsh: 装于 ~/.agents/skills ; opencode: 自动发现 ~/.agents/skills 或 ~/.config/opencode/skills ; claude code: ~/.claude/skills"
