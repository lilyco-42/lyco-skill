# lyco — 预研先行 + OODA 军事指导融合

项目预研先行（Research Before Building）—— 写任何代码之前，先钉需求、搜现成方案、挖论坛冷门知识、做 build-vs-buy 决策，最后用 ≤12 行简短汇报收尾。
融合 OODA（Observe-Orient-Decide-Act）军事决策循环，以"观察-分析-进攻"闭环驱动调研与决策。

符合 [Agent Skills](https://agentskills.io) 开放标准（`SKILL.md` + frontmatter），按 SSL-lite 结构编写。

## 何时使用

- 开新项目 / 新功能 / 新工具，还没动手之前
- "有没有现成的方案 / github 上有没有人做过 / 要不要自己造轮子"
- 方案调研 / 可行性分析 / 预研
- 官方文档没写的坑，需要去 Reddit / Stack Overflow / 吾爱破解 找
- OODA / TDOO 军事指导，用"观察-分析-进攻"闭环跑项目预研

**不要用于**：需求已明确且方案已定的直接开发（走对应 specialist 技能）、纯市场竞品调研（oma-market）、已知库的 API 查询（oma-search）。

## 工作流

```
1. PREPARE  需求钉成一句话（目标 + 约束 + 验收），没确认禁止写代码；长任务挂 goal
2. ACQUIRE  gh search repos 近义词循环 → 候选健康度检查 → 论坛 site: 过滤挖冷门知识
3. REASON   候选 vs 需求打分；主流方案 ≥80% 覆盖默认采用，自研必须写明被哪条硬约束逼的
4. ACT      克隆候选验证 or 最小脚手架（本技能到此为止）
5. FINALIZE ≤12 行 bullet 汇报：需求 / 候选 / 冷门知识 / 决策 / 下一步
OODA 模式：ACQUIRE=Observe 侦察 → REASON=Orient 研判 → DECIDE 决策 → ACT 进攻 → VERIFY=Re-observe 复盘
```

## 安装

### Windows（PowerShell 原生，无 bash 依赖）

```powershell
# 一行安装（推荐）
iex (irm https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.ps1)

# 装到所有 agent（60+，需 node/npm）
iex (irm https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.ps1) ; powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.ps1 -OutFile $env:TEMP\lyco-install.ps1; & $env:TEMP\lyco-install.ps1 -AllAgents"
```

> 注意：`bash <(...)` 进程替换语法在 Windows 原生终端不可用，Windows 请用上面的 PowerShell 命令。

### Linux / macOS（bash）

```bash
# 一键安装
bash <(curl -fsSL https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.sh)

# 全支持模式：装到所有 agent（内部用 vercel-labs/skills CLI）
bash <(curl -fsSL https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.sh) --all-agents

# 手动：克隆到全局技能目录（universal agents 原生读取）
git clone https://github.com/lilyco-42/lyco-skill.git ~/.agents/skills/lyco
```

**全支持原理**（Agent Skills 生态，[spec-weave 分析](https://spec-weave.com/docs/guides/agent-skills-extensibility-analysis/)）：

- **Universal agents**（Codex / Gemini CLI / GitHub Copilot / OpenCode / Kimi / Amp / Replit）原生读取 `~/.agents/skills/`——装一次即全通，无需链接
- **其余 30+ agent**（Claude Code / Cursor / Windsurf / Qwen / Cline / Roo 等）各读自己的目录，由 `skills` CLI 从 canonical 源建 junction/symlink 打通
- 更新技能只需改 `~/.agents/skills/lyco` 一处，所有 agent 同步生效

要求：`gh` CLI 已认证（`gh auth status`），可选 `jq`。论坛知识用 web search 的 `site:` 过滤获取，只读不爬墙内内容。

## 文件结构

```
lyco/
├── SKILL.md                        # 技能主体：Scheduling / Structural Flow / Logical Operations / References
└── resources/
    ├── preflight-search.md         # gh 命令速查、同义词扩展规则、论坛站点清单、build-vs-buy 矩阵
    ├── ooda-guidance.md            # OODA 军事指导提示词模板、阶段映射、检索速查
    └── skill-radar.md              # 外部热门技能雷达（资源路由：只引用不吸收，专项能力按需 npx skills add）
```

## 设计原则

- **CLI-first**：每一步都是可复现的命令（gh / curl / web_search）
- **反 NIH 默认**：现成方案覆盖 ≥80% 就用现成的；自研必须列出被违反的硬约束（license / 性能 / 离线 / 安全）
- **不编造候选**：报告里的每个项目都来自真实 `gh search` 结果，带 URL
- **输出简短**：bullet 汇报，砍掉啰嗦
