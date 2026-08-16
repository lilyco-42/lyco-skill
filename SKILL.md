---
name: lyco
description: >
  Project feasibility preflight before writing any code: clarify the real requirement
  first, then use gh CLI fuzzy/synonym repo search to find existing solutions, collect
  niche knowledge from forums (Reddit, Stack Overflow, 吾爱破解/52pojie, HN) instead of
  guessing, evaluate mainstream options against the requirement, and only then decide
  build vs buy (自研 vs 用现成). Use when starting a new project, 项目预研, 方案调研,
  可行性分析, 找相似项目/现成方案, 要不要自己造轮子, 评估主流方案, requirement
  clarification, or build-vs-buy decisions.
---

# lyco — 预研先行 (Research Before Building)

## Scheduling

### Goal
Ensure every new project starts from a verified requirement and a researched decision
instead of guesswork: (1) pin down what the user actually needs, (2) prove whether a
similar project already exists via gh CLI near-synonym search loops, (3) collect the
non-obvious, documentation-missing knowledge from the right forums, (4) decide
build-vs-buy with explicit evidence, and (5) report the verdict briefly — all CLI-first,
short output.

### Intent signature
- "开始一个新项目 / 帮我做个 X" where X is underspecified
- "有没有现成的方案 / 找找类似的项目 / github 上有没有人做过"
- "要不要自己造轮子 / 自研还是用现成的 / build vs buy"
- "调研一下怎么做 / 可行性 / 预研 / 方案评估"
- "这个功能文档里没写，去论坛查查 / 吾爱破解 / reddit 上怎么说"
- Requirement-first phrasing: "我想做 X，先别写代码，先搞清楚需求"

### When to use
- Starting a greenfield project, feature, or tool — before scaffolding anything
- Deciding whether to adopt, fork, or build a solution from scratch
- Gathering niche/pitfall knowledge that official docs do not cover
- The user's request is vague enough that implementing immediately risks wasted work

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
- web search (web_search tool or curl to search engines) for forums
- Optional: `jq` for parsing gh/curl JSON
- DSH goal tools for long-running preflight objectives (create_goal/get_goal/update_goal)

### Control-flow features
- Loop: near-synonym search until evidence converges (2+ credible candidates OR 2
  consecutive empty synonym rounds)
- Branch: adopt vs fork vs build decision gates the next action
- User clarification points: requirement must be agreed BEFORE any search/scaffold
- Long-running objectives: register with create_goal, drive with goal rounds
- Write behavior: no code, no scaffolding until the decision is recorded

## Structural Flow

### Entry
1. Restate the user's goal in one sentence and list the top 2-3 constraints/acceptance
   criteria; ask 1-3 clarifying questions if any ambiguity blocks the requirement.
2. Confirm "research first" mode: no implementation before the decision step.

### Scenes
1. **PREPARE**: Nail the requirement. Ask until goal + constraints + acceptance fit on
   one line. If the objective is long-running, create a goal. Do NOT let the user (or
   yourself) jump to code.
2. **ACQUIRE**: Run the gh CLI near-synonym search loop (see
   `resources/preflight-search.md` for exact commands): seed term -> 3-5 synonyms
   (中文/English/行业黑话/上下位词) -> `gh search repos` per term -> dedupe -> pick
   top candidates. Then hit the forums for niche knowledge (Reddit / Stack Overflow /
   吾爱破解 / HN) via web search with `site:` filters.
3. **REASON**: Score candidates against the requirement (fit %, maintenance, license,
   community). Apply the build-vs-buy matrix. If a mainstream option covers >= 80% of
   the requirement, it wins by default.
4. **ACT**: Execute the decision — clone the chosen repo for inspection, or scaffold the
   project skeleton. Keep it minimal; this skill's job ends at a verified start.
5. **VERIFY**: Every claim in the report has a source (repo URL / forum thread).
   Requirement is still satisfied by the decision. No hallucinated projects.
6. **FINALIZE**: Deliver the short bullet report: requirement / candidates / niche
   knowledge / decision / next action. ≤ 12 lines of substance.

### Transitions
- If the user starts dictating implementation details before the requirement is agreed,
  stop and re-confirm the one-line requirement first.
- If 2 consecutive synonym rounds return nothing credible, record "no similar public
  project found", then move to forum knowledge and REASON (self-build becomes viable).
- If the top candidate needs a quick sanity check (is it alive? license?), use
  `gh repo view owner/repo` or `gh api repos/owner/repo` before deciding.
- If the report is getting long, cut to the strongest candidate only and offer the rest
  on request.

### Failure and recovery
| Failure | Recovery |
|---------|----------|
| `gh` not authenticated | `gh auth login`; fallback to `curl` GitHub search API with a token or unauthenticated search |
| Search results are irrelevant because the seed term is wrong | Expand to synonyms/上位词; ask the user for the domain's jargon; search in the ecosystem's package registry too (npm/pypi/crates) |
| Forums require login or block scraping (e.g. 吾爱破解) | Use web_search with `site:52pojie.cn` instead of direct fetch; cite the thread URL, don't paste walled content |
| User insists on building before researching (NIH bias) | Show the found candidate's evidence and ask: "this exists and covers X% — what constraint forces a rewrite?" |
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
| Restate requirement, ask clarifying questions | `REQUEST` | User's answers in conversation |
| gh CLI near-synonym repo search | `CALL_TOOL` | `gh search repos` output |
| Inspect candidate health/license | `CALL_TOOL` | `gh repo view` / `gh api repos/...` |
| Forum niche-knowledge collection | `CALL_TOOL` | web_search with `site:` filters |
| Score candidates vs requirement | `COMPARE` | fit matrix in `resources/preflight-search.md` |
| Decide build vs buy | `SELECT` | Decision matrix + named constraints |
| Register long-running objective | `UPDATE_STATE` | create_goal/get_goal/update_goal |
| Report verdict briefly | `NOTIFY` | Final bullet report |

### Tools and instruments
- `gh search repos "TERM" --limit N --sort stars` / `gh search code` / `gh api`
- `gh repo view owner/repo` (stars, license, pushed_at)
- `curl` GitHub API fallback
- web_search tool with `site:reddit.com` / `site:stackoverflow.com` /
  `site:52pojie.cn` / `site:news.ycombinator.com`
- `jq` for JSON parsing when needed
- Full command reference: `resources/preflight-search.md`

### Canonical workflow path
1. **Requirement (PREPARE)**: Restate goal in one line; ask 1-3 questions until
   goal+constraints+acceptance fit one line; if long-running, create_goal.
2. **Synonym loop (ACQUIRE-1)**: seed = goal's core verb+noun; expand to 3-5 synonyms;
   for each: `gh search repos "synonym" --limit 15 --sort stars`; dedupe by
   owner/repo; stop when 2+ credible candidates OR 2 empty rounds.
3. **Inspect (ACQUIRE-2)**: `gh repo view owner/repo` for each top candidate — record
   stars/license/last update; drop dead repos.
4. **Niche knowledge (ACQUIRE-3)**: web_search `site:reddit.com OR site:stackoverflow.com
   <term> pitfalls` and `site:52pojie.cn <term>` when the domain is
   reverse-engineering/crack/patch-heavy; collect 1-5 doc-missing facts with links.
5. **Decide (REASON)**: apply fit matrix; mainstream ≥ 80% -> adopt; 50-80% or hard
   constraint -> fork/extend; none -> build (name the failing constraint).
6. **Act + Report (ACT/VERIFY/FINALIZE)**: clone or scaffold minimally; verify every
   claim has a source; deliver ≤ 12-line bullet report (requirement / candidates /
   niche knowledge / decision / next action).

### Resource scope
| Scope | Resource target |
|-------|-----------------|
| `NETWORK` | GitHub API via gh/curl, forum pages via web_search |
| `LOCAL_FS` | Optional scratch notes for candidates (no repo writes before decision) |
| `MEMORY` | Goal state when the preflight is long-running |
| `CODEBASE` | Read-only inspection of cloned candidates (never modify) |

### Preconditions
- `gh` is authenticated or curl fallback works.
- User agrees to research-before-code mode.
- One-line requirement is agreed before searching or scaffolding.

### Effects and side effects
- Network calls to GitHub and forum sites (read-only).
- May clone candidate repos for inspection (local disk writes).
- May register/update a DSH goal for long-running preflight.
- Does NOT write application code, scaffold, or modify the user's repo unless the
  decision step explicitly says so.

### Guardrails
1. **No code before decision** — never scaffold or implement until the requirement line
   and the build-vs-buy decision are recorded; this is the skill's whole point.
2. **No hallucinated candidates** — every project in the report must come from an actual
   `gh search`/`gh api` result with a URL; never invent a repo to fill the list.
3. **Anti-NIH default** — if any mainstream option covers ≥ 80% of the requirement,
   adopting it is the default; self-build requires a named hard constraint.
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

## References
- Command reference, synonym expansion rules, forum site list, fit matrix:
  `resources/preflight-search.md`
