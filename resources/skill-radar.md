# Skill Radar — 外部技能雷达（资源路由）

热门/好用的外部 Agent Skills 清单。**lyco 不直接吸收他人技能代码**，
只建立**资源路由**：需要某类专项能力时，从这里挑一个专门 skill 引用
（`npx skills add owner/repo/skill` 或按分类检索），执行完回到本预研流程。

- 更新规则（OODA Re-observe）：发现新热门技能按分类追加一行；stars 失真时
  用 `gh repo view owner/repo` 或 `gh api repos/owner/repo` 校准，不编造数字。
- 数据基准：2026-08，`gh api repos/owner/repo` 实测。

## 安装方式速查

- 单个技能：`npx skills add owner/repo`（vercel-labs/skills CLI，装到 `~/.agents/skills`）
- 整个仓库：`git clone https://github.com/owner/repo ~/.agents/skills/<name>`
- 本技能自身：见 README 安装章节（支持 `--all-agents` 一键装到 60+ agent）

## 1. Skill Collections（技能仓库 / 标准）

| 仓库 | ⭐ | License | 用途 | lyco 路由备注 |
|------|-----|---------|------|--------------|
| anthropics/skills | ~172.5k | 无 LICENSE | Anthropic 官方 Agent Skills 仓库 | 官方级参考优先检索来源 |
| wshobson/agents | ~39.3k | MIT | 多 harness 插件市场（Claude Code / Codex / Cursor / OpenCode） | 跨 agent 安装与分发方案查这里 |
| sickn33/agentic-awesome-skills (AAS Core) | ~45.7k | MIT | 2005+ 技能目录 + 本地控制平面 CLI/MCP | 按场景检索新技能的最全目录 |
| VoltAgent/awesome-agent-skills | ~33.3k | MIT | 1000+ 技能精选合集 | 社区精选扫描用 |
| alirezarezvani/claude-skills | ~25.2k | MIT | 380 skills（工程/营销/产品/合规/研究/效率） | 找现成技能名称与用法 |
| agentskills/agentskills | ~24.9k | Apache-2.0 | Agent Skills 规范与标准文档（agentskills.io） | 校验 `SKILL.md` 是否符合开放标准 |
| KKKKhazix/khazix-skills | ~20.3k | MIT | 数字生命卡兹克 AI Skills 合集（leader / neat-freak / hv-analysis…） | 中文社区热门技能参照 |

## 2. Engineering（工程实现类）

| 仓库 | ⭐ | License | 用途 | lyco 路由备注 |
|------|-----|---------|------|--------------|
| addyosmani/agent-skills | ~90.8k | MIT | production-grade 工程技能（测试/性能/重构等） | lyco 决策 adopt/克隆后，工程实现细节委派给它 |
| tt-a1i/archify | ~31.8k | MIT | 架构/流程/时序图 → 可验证 HTML 图 | EXPLORE 知识图谱、方案对比可视化 |

## 3. Decision & Planning（决策与计划）

| 仓库 | ⭐ | License | 用途 | lyco 路由备注 |
|------|-----|---------|------|--------------|
| OthmanAdi/planning-with-files | ~26.4k | MIT | 文件式持久计划，crash-proof、防 context rot | 长预研 / 无人之境深度研究时挂计划文件 |
| aiwithremy/claude-skills-llm-council | ~1.8k | 无 LICENSE | LLM Council：5 个 AI advisors 评审决策 | REASON 阶段对高风险 build-vs-buy 做多方评审 |

## 4. PM & Preflight（产品预研类）

| 仓库 | ⭐ | License | 用途 | lyco 路由备注 |
|------|-----|---------|------|--------------|
| phuryn/pm-skills | ~25.8k | MIT | 100+ PM 技能（discovery / market-research / execution / launch / growth） | 纯市场/竞品调研时委派它执行 |

## 5. Security（安全类）

| 仓库 | ⭐ | License | 用途 | lyco 路由备注 |
|------|-----|---------|------|--------------|
| trailofbits/skills | ~6.9k | CC-BY-SA-4.0 | 安全研究 / 漏洞检测 / 审计工作流 | 需求含安全硬约束时，用它评估候选安全性 |

## 6. Productivity（写作/生产类）

| 仓库 | ⭐ | License | 用途 | lyco 路由备注 |
|------|-----|---------|------|--------------|
| blader/humanizer | ~38.8k | MIT | 去除文本的 AI 味 | FINALIZE 报告 / 文档交付前润色 |

## 使用规则

- **先检索后调用（信条 1/3）**：先在 Collections 类仓库确认有对应能力，
  再 `npx skills add` 安装，避免重复造轮子。
- **不吸收代码**：以上技能只做路由引用，不把代码复制进 lyco，保持主体精简。
- **License 意识（规则 7）**：GPL/AGPL 或"无 LICENSE"的技能在闭源项目里
  要标记风险；这本身就是自研的合法硬约束。
- 与本地已装技能的关系：lyco 体内优先走 oma-* 系列（oma-market 纯市场调研 /
  oma-search 已知库查询 / oma-scholar 学术综述 / oma-brainstorm 开放头脑风暴）；
  外部雷达用于补充这些之外的专项能力。