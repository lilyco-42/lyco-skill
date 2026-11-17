# 参赛作品说明 · lyco 预研先行

> 2026 华为开发者大赛 · 小红书 Skill 创新赛
> 赛道：通用赛道 / 开发工具
> 作品：`lyco`（Agent Skill，MIT，https://github.com/lilyco-42/lyco-skill）

## 一句话

让 AI 写代码前先做一次「项目预研」：把需求钉成一句话，用 `gh` 近义词搜索找现成方案，
去论坛挖官方文档没写的坑，算出 build-vs-buy，再决定要不要动手——把「造轮子」变成
「先调查、再决策」。

## 真实场景

AI 编码助手最常见的浪费不是写错代码，而是**根本没确认要写什么、有没有人已经写过**：

- 用户说「帮我做个下载器」，AI 直接脚手架，三天后才发现 `yt-dlp` 已覆盖 90% 需求。
- 用户说「做个网盘客户端」，AI 从零写 API，踩了上游风控、登录态、CDN 403 的坑，
  而这些在论坛里早有人写过。
- 需求里带着「这里 / 这样」的模糊指代，AI 假装看懂，返工三轮。

lyco 把这个过程固化成一条可复现的流程，并在「决策」之前**禁止写代码**。

## 五维评审对齐

| 评审维度 | 本作品的做法 | 可核验证据 |
|---------|-------------|-----------|
| 场景真实性 | 来自真实开发痛点：先调研再动手，避免 80% 重复造轮子 | `SKILL.md` 五条核心信条 + `resources/preflight-search.md` 的同义词循环 |
| 作品可用性 | 一行安装；无 `gh` 时自动降级到 GitHub API；输出 ≤12 行不废话 | `install.sh` / `install.ps1`；`SKILL.md` 的 Failure and recovery 表 |
| Skill 复用率 | 通用开发工具，不绑定语言/框架；装一次对 60+ Agent 生效；可被其他 Skill 通过 `skill-radar` 路由 | `resources/skill-radar.md`；`README.md` 的全支持原理 |
| 技术完成度 | 完整 Agent Skills 规范：Scheduling / Structural Flow / Logical Operations / References；11 条 guardrails；SDLC 闭环；MIT | `SKILL.md` 333 行；仓库 CI 与安装脚本 |
| 内容传播力 | 「少造 80% 轮子」是可演示、可复述的钩子；附小红书笔记与演示脚本 | `docs/competition/xiaohongshu-note.md` |

## 怎么用（三步）

1. 安装：Linux/macOS `curl -fsSL https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.sh | bash`；
   Windows `iex (irm https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.ps1)`。
2. 对 Agent 说：「先别写代码，帮我预研一下 XXX 有没有现成方案」。
3. 拿到 ≤12 行结论：需求 / 候选 / 冷门知识 / 决策 / 下一步，再决定开工。

## 开发工具声明（参赛硬性门槛）

本作品的规则设计、`SKILL.md` 迭代、脚本编写与发布校验均在 **华为云码道 CodeArts**
中完成；作品为纯 Markdown + Shell/PowerShell 脚本，无外部运行时依赖。

## 复用与许可

- License：MIT（可商用、可修改，保留版权声明）。
- 复用方式：`git clone`、`skills add`、或直接把 `SKILL.md` 放进任意 Agent 的技能目录。
- 不采集用户数据；所有调研命令只读（`gh search` / `gh repo view` / 搜索引擎查询）。

## 版本

- v1.0.0（参赛提交版）：SKILL.md 333 行、resources 3 篇、双平台安装脚本、MIT。