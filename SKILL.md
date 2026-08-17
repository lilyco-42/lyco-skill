---
name: lyco
description: >
  Project feasibility preflight before writing any code: clarify the real requirement
  first, then use gh CLI fuzzy/synonym repo search to find existing solutions, collect
  niche knowledge from forums (Reddit, Stack Overflow, 吾爱破解/52pojie, HN) instead of
  guessing, evaluate mainstream options against the requirement, and only then decide
  build vs buy (自研 vs 用现成). Use when starting a new project, 项目预研, 方案调研,
  可行性分析, 找相似项目/现成方案, 要不要自己造轮子, 评估主流方案, requirement
  clarification, 前沿探索/无人之境调研, 深度研究, or build-vs-buy decisions.
---

# lyco — 预研先行 (Research Before Building)

## Scheduling

### Goal
确保每个项目开工前都基于**已验证的需求**和**调研过的决策**，而不是猜测。
五条核心信条（用户方法论，本技能的灵魂）：

1. **同类经验汲取 — 没有调查没有发言权**：项目开工前默认你的知识库是落后的。
   用 gh CLI 模糊/大量搜索 + 搜索引擎（google / duckduckgo）+ 论坛
   （stackoverflow / reddit / 吾爱破解 / HN）获取充足调研，再开口。
2. **理解你的用户**：用户的知识面通常是不足的，甚至不懂专业术语。要充分理解
   用户的**核心目的**与**具体实现**；遇到"这里/这样"等模糊指代，若你没有识图
   能力就承认，并提示"将先执行同类经验汲取"；给出**完整、准确、简单扼要**的提问。
3. **评估可行性 — 避免走进死胡同**：当资料证明他人实现过类似效果，说明可行时，
   不要自己埋头研究 —— 去**克隆他人的想法并研究具体实现**。
4. **探索实现 — 无人之境**：当确定方向是无人之境，**首先怀疑这条路已在论文或
   硬件中被证明不可行**，回到第 1 条同类经验汲取；找到些许材料后，把所有模糊或
   相似文件整理成 md / Obsidian 知识图谱，再开始深度研究。
5. **深度研究 — 低投入高收益**：代码、文字、图片输出都要满足**最小化验证可行性**；
   不懂一个东西的实现，就写最小化实现，慢慢模块化拼接、由简入繁。
   相信**原子化构建** —— 复杂的人体也是由基本粒子组成。

### Intent signature
- "开始一个新项目 / 帮我做个 X" where X is underspecified
- "有没有现成的方案 / 找找类似的项目 / github 上有没有人做过"
- "要不要自己造轮子 / 自研还是用现成的 / build vs buy"
- "调研一下怎么做 / 可行性 / 预研 / 方案评估"
- "这个功能文档里没写，去论坛查查 / 吾爱破解 / reddit 上怎么说"
- "这个方向是不是没人做过 / 无人之境 / 前沿探索 / 深度研究"
- Requirement-first phrasing: "我想做 X，先别写代码，先搞清楚需求"

### When to use
- Starting a greenfield project, feature, or tool — before scaffolding anything
- Deciding whether to adopt, fork, or build a solution from scratch
- Gathering niche/pitfall knowledge that official docs do not cover
- The user's request is vague enough that implementing immediately risks wasted work
- 探索未知/前沿方向时（怀疑不可行 → 先调研 → 最小化验证）

### When NOT to use
- Requirement is already crisp AND the solution is already chosen -> skip to the
  matching specialist skill (oma-backend / oma-frontend / oma-mobile / oma-debug)
- Pure market/competitor research (pain points, trends, SWOT) -> use oma-market
- Generic lookup of a known library's API or docs -> use oma-search
- Academic literature review -> use oma-scholar
- Brainstorming open-ended ideas without a concrete build target -> use oma-brainstorm

### Expected inputs
- `goal`: one sentence of what the user wants to achieve (or a rough draft of it)
- `constraints` (optional): budget, stack preference, license, performance, offline,
  security, existing codebase constraints
- `domain` (optional): keywords/industry terms to seed the search
- 用户原话里的模糊词（"这里/这样/那个"）：**不要猜**，先承认能力边界再提问

### Expected outputs
- `requirement`: one-line restated requirement agreed with the user (goal + top
  constraints + acceptance)
- `candidates`: existing projects found via gh CLI, each with stars / license /
  last-update / fit-vs-requirement, and source URL
- `niche_knowledge`: 1-5 forum-sourced pitfalls or facts with source links, only what
  docs miss
- `decision`: adopt / fork-extend / build-from-scratch, with one-line evidence
- `next_action`: single concrete next step (clone, scaffold, or further research)
- Final report is SHORT: bullet list, no essays, no repeated tool output

### Dependencies
- `gh` CLI authenticated (`gh auth status`); `curl` fallback to GitHub API
- web search (web_search tool or curl to search engines: google / duckduckgo) for forums
- Optional: `jq` for parsing gh/curl JSON
- Optional: Obsidian vault（无人之境调研时整理知识图谱用）
- DSH goal tools for long-running preflight objectives (create_goal/get_goal/update_goal)

### Control-flow features
- Loop: near-synonym search until evidence converges (2+ credible candidates OR 2
  consecutive empty synonym rounds); 无人之境时扩大到搜索引擎 + 论文/硬件排查
- Branch: adopt vs fork vs build decision gates the next action
- Branch: 有先例 → 克隆研究实现；无先例 → 怀疑不可行 → 再调研 → 知识图谱 → 最小化验证
- User clarification points: requirement must be agreed BEFORE any search/scaffold
- Long-running objectives: register with create_goal, drive with goal rounds
- Write behavior: no code, no scaffolding until the decision is recorded

## Structural Flow

### Entry
1. Restate the user's goal in one sentence and list the top 2-3 constraints/acceptance
   criteria; ask 1-3 clarifying questions if any ambiguity blocks the requirement.
2. **理解用户（信条 2）**：提问必须完整、准确、简单扼要；发现模糊指代（"这里/这样"）
   时，若自己无识图/相关能力就**明确承认**，并提示"将先执行同类经验汲取获取相关工具"，
   再让用户确认方向。
3. Confirm "research first" mode: no implementation before the decision step.

### Scenes
1. **PREPARE**: Nail the requirement. Ask until goal + constraints + acceptance fit on
   one line. 用户不懂术语时用大白话解释；模糊词必须先澄清。If the objective is
   long-running, create a goal. Do NOT let the user (or yourself) jump to code.
2. **ACQUIRE (信条 1)**: 默认知识库落后。Run the gh CLI near-synonym search loop (see
   `resources/preflight-search.md` for exact commands): seed term -> 3-5 synonyms
   (中文/English/行业黑话/上下位词) -> `gh search repos` per term -> dedupe -> pick
   top candidates. 同时用搜索引擎（google / duckduckgo）和论坛（Reddit / Stack
   Overflow / 吾爱破解 / HN）做**模糊大量搜索**获取充足调研。
3. **REASON (信条 3)**: Score candidates against the requirement (fit %, maintenance,
   license, community). Apply the build-vs-buy matrix. If a mainstream option covers
   >= 80% of the requirement, it wins by default —— **不要自己埋头研究，去克隆他人的
   想法并研究具体实现**。
4. **EXPLORE (信条 4, 无人之境)**: 当确定方向是无人之境（无现成实现）：
   a. **首先怀疑**这条路已在论文或硬件中被证明不可行；
   b. 回到 ACQUIRE 扩大检索（论文/专利/硬件规格/相似领域），寻找"不可行"证据或蛛丝马迹；
   c. 找到些许材料后，把所有模糊或相似文件整理为 **md / Obsidian 知识图谱**（概念-关系-证据），
      结构化后再进入深度研究；
   d. 若彻底找不到材料，明确报告"无人之境 + 无不可行证据"，标注风险再继续。
5. **DEEP-DIVE (信条 5, 深度研究)**: 目标是**低投入高收益**地获取前沿探索知识：
   a. 任何代码/文字/图片输出先满足**最小化验证可行性**（最小可运行 demo，不追求完整）；
   b. 不懂一个东西的实现 → 写最小化实现 → 跑通 → 再**模块化拼接**、由简入繁；
   c. 相信**原子化构建**：复杂系统由基本单元组合，先建单元再组合；
   d. 每步验证可行性，避免一次性大工程。
6. **ACT**: Execute the decision — clone the chosen repo for inspection, or scaffold the
   project skeleton (最小化). Keep it minimal; this skill's job ends at a verified start.
7. **VERIFY**: Every claim in the report has a source (repo URL / forum thread / 论文).
   Requirement is still satisfied by the decision. No hallucinated projects.
8. **FINALIZE**: Deliver the short bullet report: requirement / candidates / niche
   knowledge / decision / next action. ≤ 12 lines of substance.

### Transitions
- If the user starts dictating implementation details before the requirement is agreed,
  stop and re-confirm the one-line requirement first.
- If 2 consecutive synonym rounds return nothing credible, record "no similar public
  project found", then move to **EXPLORE**（无人之境流程）before self-building.
- If the top candidate needs a quick sanity check (is it alive? license?), use
  `gh repo view owner/repo` or `gh api repos/owner/repo` before deciding.
- If 资料证明他人实现过 → 默认克隆研究实现（REASON → ACT），不重复造轮子。
- If the report is getting long, cut to the strongest candidate only and offer the rest
  on request.

### Failure and recovery
| Failure | Recovery |
|---------|----------|
| `gh` not authenticated | `gh auth login`; fallback to `curl` GitHub search API with a token or unauthenticated search |
| Search results are irrelevant because the seed term is wrong | Expand to synonyms/上位词; ask the user for the domain's jargon; search in the ecosystem's package registry too (npm/pypi/crates) |
| 搜索到材料但理解不了 | 整理成 md / Obsidian 知识图谱，拆解为最小单元逐个研究（信条 5） |
| 方向像"无人之境" | 先怀疑已在论文/硬件中被证明不可行 → 扩大检索找证据 → 再决定 |
| Forums require login or block scraping (e.g. 吾爱破解) | Use web_search with `site:52pojie.cn` instead of direct fetch; cite the thread URL, don't paste walled content |
| User insists on building before researching (NIH bias) | Show the found candidate's evidence and ask: "this exists and covers X% — what constraint forces a rewrite?" |
| User 用模糊词且你无识图能力 | 承认能力边界，提示先执行同类经验汲取获取工具，再确认方向；不要假装看懂 |
| Decision paralysis between fork and build | Default to adopt/fork if any candidate covers ≥ 80%; self-build requires a named hard constraint (license/perf/offline/security) |
| Report becomes a wall of text | Compress to bullets; per-item max ~1 line; move details into a follow-up offer |

### Exit
- Success: requirement line agreed; candidates researched with sources; decision made
  with evidence; next action stated; report ≤ 12 lines.
- Partial success: search done but user is still deciding — report findings and the
  decision matrix, leave the decision open, no code written.
- Failure: requirement could not be pinned down after clarification — report what is
  ambiguous and stop; do not implement from a guess.

## Logical Operations

### Actions
| Action | SSL primitive | Evidence |
|--------|---------------|----------|
| Restate requirement, ask clarifying questions（完整/准确/扼要） | `REQUEST` | User's answers in conversation |
| 承认能力边界（无识图/不懂术语时） | `REQUEST` | 用户确认方向 |
| gh CLI near-synonym + 模糊搜索 | `CALL_TOOL` | `gh search repos` / `gh search code` output |
| 搜索引擎 + 论坛调研（google/ddg/reddit/SO/52pojie/HN） | `CALL_TOOL` | web_search with `site:` filters |
| Inspect candidate health/license | `CALL_TOOL` | `gh repo view` / `gh api repos/...` |
| 有先例 → 克隆研究实现（不埋头研究） | `CALL_TOOL` | clone + read source |
| 无人之境 → 怀疑不可行 → 找证据 | `CALL_TOOL` | 论文/硬件/相似领域检索 |
| 整理知识图谱（md / Obsidian） | `WRITE` | 概念-关系-证据 notes |
| 最小化验证可行性 | `WRITE` | 最小可运行 demo |
| Score candidates vs requirement | `COMPARE` | fit matrix in `resources/preflight-search.md` |
| Decide build vs buy | `SELECT` | Decision matrix + named constraints |
| Register long-running objective | `UPDATE_STATE` | create_goal/get_goal/update_goal |
| Report verdict briefly | `NOTIFY` | Final bullet report |

### Tools and instruments
- `gh search repos "TERM" --limit N --sort stars` / `gh search code` / `gh api`
- `gh repo view owner/repo` (stars, license, pushed_at)
- `curl` GitHub API fallback
- web_search tool: 搜索引擎（google / duckduckgo）+ `site:reddit.com` /
  `site:stackoverflow.com` / `site:52pojie.cn` / `site:news.ycombinator.com`
- `jq` for JSON parsing when needed
- Obsidian vault / md notes（无人之境知识图谱）
- Full command reference: `resources/preflight-search.md`

### Canonical workflow path
1. **Requirement (PREPARE)**: Restate goal in one line; ask 1-3 questions until
   goal+constraints+acceptance fit one line; 模糊词先澄清、承认能力边界; if
   long-running, create_goal.
2. **Synonym loop (ACQUIRE-1)**: seed = goal's core verb+noun; expand to 3-5 synonyms;
   for each: `gh search repos "synonym" --limit 15 --sort stars`; dedupe by
   owner/repo; stop when 2+ credible candidates OR 2 empty rounds.
3. **Wide net (ACQUIRE-2)**: 搜索引擎 + 论坛模糊大量搜索（google/ddg/reddit/SO/52pojie/HN），
   收集文档缺失的 niche 知识与先例线索。
4. **Inspect (ACQUIRE-3)**: `gh repo view owner/repo` for each top candidate — record
   stars/license/last update; drop dead repos.
5. **Decide (REASON)**: apply fit matrix; mainstream ≥ 80% -> adopt (克隆研究实现);
   50-80% or hard constraint -> fork/extend; none -> 进入 EXPLORE。
6. **Explore (EXPLORE)**: 无人之境 → 先怀疑论文/硬件已证不可行 → 扩大检索 →
   整理 md/Obsidian 知识图谱 → 评估风险后进入最小化验证。
7. **Minimal proof (DEEP-DIVE)**: 最小化实现验证可行性 → 模块化拼接由简入繁 → 原子化构建。
8. **Act + Report (ACT/VERIFY/FINALIZE)**: clone or scaffold minimally; verify every
   claim has a source; deliver ≤ 12-line bullet report (requirement / candidates /
   niche knowledge / decision / next action).

### Resource scope
| Scope | Resource target |
|-------|-----------------|
| `NETWORK` | GitHub API via gh/curl, 搜索引擎/论坛 via web_search |
| `LOCAL_FS` | Scratch notes + Obsidian 知识图谱（无人之境）; no repo writes before decision |
| `MEMORY` | Goal state when the preflight is long-running |
| `CODEBASE` | Read-only inspection of cloned candidates (never modify) |

### Preconditions
- `gh` is authenticated or curl fallback works.
- User agrees to research-before-code mode.
- One-line requirement is agreed before searching or scaffolding.

### Effects and side effects
- Network calls to GitHub, search engines, and forum sites (read-only).
- May clone candidate repos for inspection (local disk writes).
- May write scratch md / Obsidian notes during EXPLORE/DEEP-DIVE.
- May register/update a DSH goal for long-running preflight.
- Does NOT write application code, scaffold, or modify the user's repo unless the
  decision step explicitly says so.

### Guardrails
1. **No code before decision** — never scaffold or implement until the requirement line
   and the build-vs-buy decision are recorded; this is the skill's whole point.
2. **No hallucinated candidates** — every project in the report must come from an actual
   `gh search`/`gh api` result with a URL; never invent a repo to fill the list.
3. **Anti-NIH default (信条 3)** — if any mainstream option covers ≥ 80% of the
   requirement, adopting it is the default; self-build requires a named hard constraint.
   有先例就克隆研究，不埋头造轮子。
4. **Forum knowledge is cited, not copied** — summarize with source links; never paste
   walled/large forum content into the report; respect site terms.
5. **CLI-first** — use gh/curl/web_search; avoid GUI browsing; keep every step
   reproducible as a command.
6. **Short output always** — bullet reports, ≤ 12 lines of substance; cut, don't pad;
   the user values 简短扼要 over completeness.
7. **License awareness** — flag license incompatibility (e.g. GPL in closed-source) in
   the decision; it is a legitimate hard constraint for self-build.
8. **Respect forum access barriers** — do not attempt login bypass or scraping
   workarounds on login-walled forums; use site-filtered search results instead.
9. **Admit capability boundaries (信条 2)** — 无识图/不懂就承认，并提示先执行
   同类经验汲取获取工具；绝不假装看懂模糊指代。
10. **Suspect dead ends first (信条 4)** — 无人之境方向先假设已在论文/硬件中被证明
    不可行，找到证据或反例后再投入深度研究。
11. **Minimal proof before depth (信条 5)** — 任何输出先满足最小化验证可行性；
    不理解就写最小化实现，原子化构建，模块化拼接，避免一次性大工程。

## References
- Command reference, synonym expansion rules, forum site list, fit matrix:
  `resources/preflight-search.md`
- 五条核心信条（用户方法论）：同类经验汲取 / 理解用户 / 评估可行性 /
  探索无人之境 / 深度研究（最小化验证 + 原子化构建）
