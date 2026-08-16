#!/usr/bin/env bash
# lyco skill 一键安装脚本
# 用法: bash install.sh [目标目录]
#   默认目标: ~/.agents/skills/lyco
#   支持: Linux / macOS / Windows(Git Bash / WSL / Termux)
set -euo pipefail

SKILL_NAME="lyco"
REPO="https://github.com/lilyco-42/lyco-skill.git"
TARGET="${1:-$HOME/.agents/skills/$SKILL_NAME}"

info()  { printf '\033[32m[lyco]\033[0m %s\n' "$*"; }
warn()  { printf '\033[33m[lyco]\033[0m %s\n' "$*" >&2; }
die()   { printf '\033[31m[lyco] 失败: %s\033[0m\n' "$*" >&2; exit 1; }

# 目标目录已存在 → 检查是否为已装技能，是则 git pull 更新
install_via_git() {
    info "git 可用，开始克隆 $REPO"
    if [[ -d "$TARGET/.git" ]]; then
        info "检测到已安装，git pull 更新..."
        git -C "$TARGET" pull --ff-only || warn "git pull 失败，保留现有内容"
    else
        git clone --depth 1 "$REPO" "$TARGET" || die "克隆失败，请检查网络/代理"
    fi
}

install_via_curl() {
    info "git 不可用，改用 tarball 下载..."
    command -v curl >/dev/null 2>&1 || die "既没有 git 也没有 curl，无法安装"
    local tmp; tmp="$(mktemp -d)"
    curl -fsSL "https://github.com/lilyco-42/lyco-skill/archive/refs/heads/main.tar.gz" \
        -o "$tmp/lyco.tar.gz" || die "下载失败"
    mkdir -p "$TARGET"
    tar -xzf "$tmp/lyco.tar.gz" -C "$tmp"
    # tarball 解出来是 lyco-skill-main/，把内容平铺进目标
    cp -r "$tmp"/lyco-skill-main/. "$TARGET/"
    rm -rf "$tmp"
}

# --- 主流程 ---
if [[ -e "$TARGET/SKILL.md" ]]; then
    if command -v git >/dev/null 2>&1 && [[ -d "$TARGET/.git" ]]; then
        install_via_git
    else
        info "目标已存在且非 git 克隆，跳过覆盖（如需强制更新请先手动删除 $TARGET）"
    fi
else
    if command -v git >/dev/null 2>&1; then
        install_via_git
    else
        install_via_curl
    fi
fi

# 校验 frontmatter name 与目录名一致（Agent Skills 规范）
if [[ -f "$TARGET/SKILL.md" ]]; then
    if grep -q "^name: $SKILL_NAME$" "$TARGET/SKILL.md"; then
        info "校验通过: name: $SKILL_NAME == 目录名 $(basename "$TARGET")"
    else
        warn "SKILL.md 的 frontmatter name 不是 $SKILL_NAME，请检查"
    fi
    info "安装完成: $TARGET"
    info "重启 agent 会话后可用 /$SKILL_NAME 调用"
else
    die "未找到 SKILL.md，安装不完整"
fi
