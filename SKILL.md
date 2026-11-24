---
name: lyco
description: "Project feasibility preflight before writing code: clarify the real requirement, gh search for existing solutions (找现成方案), mine forums (Reddit/SO/52pojie/HN), then decide build vs buy (要不要造轮子). Use for 项目预研, 方案调研, 可行性分析, 前沿探索/深度研究, and 软件开发组合/SDLC 需求→调研→ROI→决策→验证 loops (aliases: OODA/OORDA)."
---

# lyco — 预研先行 (Research Before Building)

## Goal
确保每个项目开工前都基于**已验证的需求**和**调研过的决策**，而不是猜测。
预研本身是一条 **SDLC 闭环**：需求 → 调研 → 分析·设计 → ROI → 决策 → 开发·落地 → 验证 →
维护·迭代。lyco 重仓前端（需求到决策 + 验证），深度开发/测试/部署/维护经
`resources/skill-radar.md` 路由给专家技能。

## 五条核心信条（本技能的灵魂）
1. **同类经验汲取 — 没有调查没有发言权**：默认你的知识库是落后的。用 gh CLI 模糊/大量
   搜索 + 搜索引擎（google / duckduckgo）+ 论坛（SO / reddit / 吾爱破解 / HN）充足调研后再开口。
2. **理解你的用户**：用户常不懂术语。充分理解**核心目的**与**具体实现**；遇到"这里/这样"等
   模糊指代，若无识图能力就承认，提示"将先执行同类经验汲取"；提问**完整、准确、简单扼要**。
3. **评估可行性 — 避免走进死胡同**：资料证明他人实现过 = 可行，不要埋头研究 ——
   **克隆他人的想法并研究具体实现**。
4. **探索实现 — 无人之境**：先**怀疑这条路已在论文或硬件中被证明不可行**，回到信条 1；
   找到些许材料后整理成 md / Obsidian 知识图谱，再深度研究。
5. **深度研究 — 低投入高收益**：任何代码/文字/图片输出先满足**最小化验证可行性**；不懂就写
   最小化实现，模块化拼接、由简入繁；相信**原子化构建**。

## When to use
- 新项目/功能/工具开工前："帮我做个 X"（X 不明确）/ "先别写代码，先搞清楚需求"
- "有没有现成的方案 / github 上有没有人做过 / 自研还是用现成 / build vs buy"
- "调研 / 可行性 / 预研 / 方案评估"；文档没写的坑去论坛查（吾爱破解 / reddit）
- "这个方向是不是没人做过 / 无人之境 / 前沿探索 / 深度研究"
- 软件开发组合 / SDLC / 生命周期 / "需求→设计→开发→测试→部署→维护"（旧称 OODA/OORDA 仍触发）

**When NOT to use**（括号内为可选外部技能，若未安装则自行用通用能力完成）：
- 需求已明确且方案已定 → 直接开发（oma-backend / oma-frontend / oma-mobile / oma-debug）
- 纯市场/竞品调研（oma-market）；已知库 API 查询（oma-search）；学术综述（oma-scholar）；
  无具体构建目标的开放头脑风暴（oma-brainstorm）

## Dependencies
- 必需：`gh` CLI 已认证（`gh auth status`），失败时 `curl` GitHub API 兜底；web search 工具
- 可选：`jq`；Obsidian vault（无人之境知识图谱）
- 可选：DSH goal 工具（create_goal/get_goal/update_goal）挂长任务 —— 若未安装则在
  scratch md 中记录进度，跳过此步
- 可选：oma-* 等外部专家技能 / `npx skills add owner/repo`（见 skill-radar，只路由不吸收代码）
  —— 若未安装则自行执行对应步骤或跳过，不阻塞预研

## Workflow（SDLC 阶段 ↔ lyco 场景）

**理解门槛（先于每一轮）**：用户的话/提示词没看懂、有歧义或含陌生概念 → 两件事缺一不可：
① WebFetch/WebSearch 至少搜一次（弄清真实核心需求）；② 直接问用户"核心需求是什么"。
没搜 + 没问就动手 = 违规。

| # | 场景 | SDLC 阶段 | 要做的事 / 产出 |
|---|------|-----------|-----------------|
| 1 | **PREPARE** | 需求 | 复述目标为一行（目标 + 2-3 约束 + 验收），问 1-3 个澄清问题；大白话解释术语；模糊词先澄清（信条 2）；确认"先调研后编码"模式 |
| 2 | **ACQUIRE**（信条 1） | 调研 | 种子词 → 3-5 近义词（中/英/行业黑话/上下位词）→ 每词 `gh search repos` → 去重；同时搜索引擎 + 论坛 `site:` 模糊大量搜索；`gh repo view` 查健康度/license |
| 3 | **REASON**（信条 3） | 分析·设计 | 按 fit%/维护/license/社区打分，套 build-vs-buy 矩阵；≥2 备选 |
| 4 | **EXPLORE**（信条 4） | 分析·设计 | 无现成实现时：a 先怀疑论文/硬件已证不可行；b 回 ACQUIRE 扩检（论文/专利/硬件规格/相似领域）；c 整理 md/Obsidian 知识图谱（概念-关系-证据）；d 仍无材料 → 报告"无人之境 + 无不可行证据"并标风险 |
| 5 | **DEEP-DIVE**（信条 5） | 分析·设计 | 最小可运行 demo 验证可行性 → 跑通 → 模块化拼接；每步验证，避免一次性大工程 |
| 6 | **WEIGH** | ROI 门槛 | 产出值（需求价值/补缺/可复用）÷ 投入本（工时/风险/验证）；**不过门槛不动工** → 缩方案或换题 |
| 7 | **DECIDE / ACT** | 决策 + 开发·落地 | adopt / fork / build + 命名硬约束 + 代价；执行最小 clone/scaffold（深度开发 → skill-radar） |
| 8 | **VERIFY / FINALIZE** | 验证 + 维护·迭代 | 每条结论有源（repo URL / 论坛 / 论文），需求仍被满足；交付 ≤12 行报告；未达验收 → 自动下一轮 |

**决策规则（反 NIH，80% 规则）**：主流方案覆盖 ≥80% 需求 → 默认 adopt（克隆研究实现）；
50-80% 或存在硬约束 → fork/extend；无候选 → EXPLORE。自研必须写明被哪条硬约束逼的
（license / 性能 / 离线 / 安全）。

**循环规则**：前端重、后端轻；可逆动作 70% 置信度即行动，不可逆/高风险必须等用户确认；
行动后必须重新观察，不停在"好像完成了"；验证未过从新事实重新观察，不修旧结论。
每轮提示词模板与 SDLC 速查见 `resources/sdlc-guidance.md`。

**≤12 行报告格式**（只写实质内容，bullet，无长文、不贴工具输出）：
```text
需求: <一行: 目标 + 关键约束 + 验收>
候选: <owner/repo> ⭐<stars> <license> <url>  (top 1-3, 各标 fit %)
冷门知识: <1-2 条文档缺失的事实，各带来源链接>
决策: adopt / fork / build — <一行证据>
下一步: <一个具体动作>
```

## Transitions
- 需求未确认用户就开始口述实现细节 → 停下，先重新确认一行需求。
- 连续 2 轮近义词搜索无可信结果 → 记录"未找到公开同类项目"，进入 EXPLORE 再考虑自研。
- 头部候选需快速体检（是否存活？license？）→ `gh repo view` / `gh api repos/owner/repo`。
- 资料证明他人实现过 → 默认克隆研究实现（REASON → ACT），不重复造轮子。
- 报告变长 → 只留最强候选，其余按需提供。

## Failure and recovery
| Failure | Recovery |
|---------|----------|
| `gh` not authenticated | `gh auth login`; fallback to `curl` GitHub search API (token or unauthenticated) |
| Seed term wrong → irrelevant results | Expand to synonyms/上位词; ask user for domain jargon; also search npm/pypi/crates |
| 搜索到材料但理解不了 | 整理成 md / Obsidian 知识图谱，拆为最小单元逐个研究（信条 5） |
| 方向像"无人之境" | 先怀疑已在论文/硬件中被证明不可行 → 扩大检索找证据 → 再决定 |
| Forums need login / block scraping (e.g. 吾爱破解) | web_search with `site:52pojie.cn`; cite thread URL, don't paste walled content |
| User insists on building first (NIH bias) | Show evidence: "this exists and covers X% — what constraint forces a rewrite?" |
| 用户用模糊词且你无识图能力 | 承认能力边界，提示先执行同类经验汲取获取工具，再确认方向；不假装看懂 |
| Decision paralysis fork vs build | Any candidate ≥80% → adopt/fork; self-build needs a named hard constraint |
| Optional skill/tool missing (oma-*, DSH goal) | 自行执行该步骤或跳过，在报告中注明；不阻塞流程 |
| Report becomes a wall of text | Compress to bullets, ~1 line per item; offer details as follow-up |

## Exit
- **Success**：一行需求已确认；候选带来源；决策有证据；下一步已给出；报告 ≤12 行。
- **Partial**：调研完成但用户仍在决定 → 报告发现与决策矩阵，决策留空，不写代码。
- **Failure**：澄清后仍钉不住需求 → 报告歧义点并停止；绝不凭猜测实现。

## Guardrails
1. **No code before decision** — 一行需求与 build-vs-buy 决策记录前，不脚手架、不实现。
2. **No hallucinated candidates** — 报告中每个项目都来自真实 `gh search`/`gh api` 结果并带 URL。
3. **Anti-NIH default（信条 3）** — 主流方案 ≥80% 默认采用；有先例就克隆研究，不埋头造轮子。
4. **Forum knowledge is cited, not copied** — 带来源总结，不粘贴墙内/大段内容，遵守站点条款。
5. **CLI-first** — gh/curl/web_search，避免 GUI 浏览，每步可复现为命令。
6. **Short output always** — ≤12 行实质内容；简短扼要优先于完整。
7. **License awareness** — 标注 license 冲突（如闭源用 GPL），它是自研的合法硬约束。
8. **Respect forum access barriers** — 不绕过登录墙、不做抓取变通，改用 `site:` 搜索结果。
9. **Admit capability boundaries（信条 2）** — 无识图/不懂就承认，绝不假装看懂模糊指代。
10. **Suspect dead ends first（信条 4）** — 无人之境先假设不可行，找到证据或反例再深入。
11. **Minimal proof before depth（信条 5）** — 先最小化验证，原子化构建，模块化拼接。

## References
- `resources/preflight-search.md` — gh 命令速查、近义词扩展规则、论坛站点清单、fit / build-vs-buy 矩阵
- `resources/sdlc-guidance.md` — SDLC 阶段映射、每轮提示词模板、各阶段检索速查（含 OODA 旧称对照）
- `resources/workflow-reference.md` — 输入/输出字段、控制流、标准命令路径、SSL 动作映射、资源范围与副作用
- `resources/skill-radar.md` — 外部技能雷达（只引用不吸收；专项能力做 build-vs-buy 时查这里）
