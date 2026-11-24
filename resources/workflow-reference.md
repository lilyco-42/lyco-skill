# lyco 工作流细节参考（SSL 映射 / 资源范围 / 副作用）

Load this file only when you need the formal SSL mapping or exact step commands;
SKILL.md keeps the rules, this file keeps the detail.

## 1. Expected inputs / outputs

Inputs:
- `goal`: one sentence of what the user wants to achieve (or a rough draft of it)
- `constraints` (optional): budget, stack preference, license, performance, offline,
  security, existing codebase constraints
- `domain` (optional): keywords/industry terms to seed the search
- 用户原话里的模糊词（"这里/这样/那个"）：**不要猜**，先承认能力边界再提问

Outputs:
- `requirement`: one-line restated requirement agreed with the user (goal + top
  constraints + acceptance)
- `candidates`: existing projects found via gh CLI, each with stars / license /
  last-update / fit-vs-requirement, and source URL
- `niche_knowledge`: 1-5 forum-sourced pitfalls or facts with source links, only what
  docs miss
- `decision`: adopt / fork-extend / build-from-scratch, with one-line evidence
- `next_action`: single concrete next step (clone, scaffold, or further research)

## 2. Control-flow features

- Loop: near-synonym search until evidence converges (2+ credible candidates OR 2
  consecutive empty synonym rounds); 无人之境时扩大到搜索引擎 + 论文/硬件排查
- Branch: adopt vs fork vs build decision gates the next action
- Branch: 有先例 → 克隆研究实现；无先例 → 怀疑不可行 → 再调研 → 知识图谱 → 最小化验证
- User clarification points: requirement must be agreed BEFORE any search/scaffold
- Long-running objectives (optional): 若装了 DSH goal 工具则 create_goal/get_goal/update_goal
  挂目标；未安装则在 scratch md 里记录进度，跳过此步
- Write behavior: no code, no scaffolding until the decision is recorded

## 3. Canonical command path

1. **Requirement (PREPARE)**: restate goal in one line; ask 1-3 questions until
   goal+constraints+acceptance fit one line; 模糊词先澄清、承认能力边界。
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
   claim has a source; deliver ≤ 12-line bullet report.

## 4. Actions → SSL primitives

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
| Register long-running objective (optional) | `UPDATE_STATE` | DSH create_goal/get_goal/update_goal；未安装则跳过 |
| Report verdict briefly | `NOTIFY` | Final bullet report |

## 5. Tools and instruments

- `gh search repos "TERM" --limit N --sort stars` / `gh search code` / `gh api`
- `gh repo view owner/repo` (stars, license, pushed_at)
- `curl` GitHub API fallback
- web_search tool: 搜索引擎（google / duckduckgo）+ `site:reddit.com` /
  `site:stackoverflow.com` / `site:52pojie.cn` / `site:news.ycombinator.com`
- `jq` for JSON parsing when needed (optional)
- Obsidian vault / md notes（无人之境知识图谱，optional）

## 6. Resource scope

| Scope | Resource target |
|-------|-----------------|
| `NETWORK` | GitHub API via gh/curl, 搜索引擎/论坛 via web_search |
| `LOCAL_FS` | Scratch notes + Obsidian 知识图谱（无人之境）; no repo writes before decision |
| `MEMORY` | Goal state when the preflight is long-running (optional DSH goal tools) |
| `CODEBASE` | Read-only inspection of cloned candidates (never modify) |

## 7. Preconditions / effects

Preconditions:
- `gh` is authenticated or curl fallback works.
- User agrees to research-before-code mode.
- One-line requirement is agreed before searching or scaffolding.

Effects and side effects:
- Network calls to GitHub, search engines, and forum sites (read-only).
- May clone candidate repos for inspection (local disk writes).
- May write scratch md / Obsidian notes during EXPLORE/DEEP-DIVE.
- May register/update a DSH goal for long-running preflight (only if installed).
- Does NOT write application code, scaffold, or modify the user's repo unless the
  decision step explicitly says so.
