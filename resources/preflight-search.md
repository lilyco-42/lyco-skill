# Preflight Search Reference

One-stop command/expansion reference for the preflight workflow. Load only when running
ACQUIRE/REASON scenes; the SKILL.md body stays lean.

## 1. Near-Synonym Expansion Rules

Seed term = the goal's core verb + noun (e.g. "merge pdf"). Expand each round:

| Direction | Example |
|-----------|---------|
| 中文 ↔ English | 合并 pdf → merge pdf → combine pdf → pdf toolkit |
| 上位词 / 下位词 | ocr → table extraction → pdf table parse → document AI |
| 行业黑话 / 社区叫法 | 逆向 → reverse engineering → unpacking → crack |
| 动词/名词变体 | build a bot → automation → auto-reply CLI |
| 缩写 / 全称 | SO → Stack Overflow → stackoverflow |

Loop rules: run each synonym through `gh search repos`; dedupe by owner/repo; stop when
2+ credible candidates OR 2 consecutive empty rounds.

## 2. gh CLI Commands

```bash
# auth check (fail fast)
gh auth status

# repo search by stars / recent activity
gh search repos "merge pdf" --limit 15 --sort stars
gh search repos "merge pdf" --limit 15 --sort updated --order desc

# code search when repo names are inconclusive
gh search code "merge_pdf " --limit 20

# inspect a candidate: stars, license, last push, description
gh repo view owner/repo

# raw API for filters gh lacks (language, pushed date)
gh api "search/repositories?q=merge+pdf+in:readme&sort=stars&per_page=20"

# no gh / tokenless fallback
curl -s "https://api.github.com/search/repositories?q=merge+pdf&sort=stars&per_page=20" | jq '.items[] | {full_name, stargazers_count, license: .license.spdx_id, pushed_at, description}'
```

Record per candidate: `owner/repo | stars | license | last push | fit note`.

## 3. Forum / Niche-Knowledge Site List

Use web_search with `site:` filters (read-only; no login scraping):

| Site | Filter | Use for |
|------|--------|---------|
| Reddit | `site:reddit.com <term> pitfalls OR experience` | real-world gotchas, tool opinions |
| Stack Overflow | `site:stackoverflow.com <term>` | edge cases, error signatures |
| 吾爱破解 | `site:52pojie.cn <term>` | 逆向/脱壳/补丁/冷门工具知识 (login-walled; search-only) |
| Hacker News | `site:news.ycombinator.com <term>` | ecosystem debate, alternatives |
| GitHub Issues | `site:github.com <owner/repo> issues <error>` | known bugs in the candidate itself |

Extract only what official docs miss: 坑 (pitfalls), boundary behavior, anti-patterns,
alternative discussions. Summarize with source links; never paste walled content.

## 4. Build-vs-Buy Fit Matrix

| Coverage of requirement | Maintenance | Verdict |
|-------------------------|-------------|---------|
| ≥ 80% and license compatible | active (pushed < 1y) | **Adopt** (default) |
| 50–80% OR one soft gap | active | **Fork / extend** (list the gap) |
| Any candidate | dead (pushed ≥ 2y, no activity) | treat as knowledge, not a dependency |
| No candidate OR hard constraint fails (license/perf/offline/security) | — | **Build from scratch**, and record WHICH constraint forced it |

License flags: GPL/AGPL in closed-source, "no license" (not usable), MIT/Apache-2.0/BSD
are safe defaults. A license mismatch is a legitimate hard constraint for self-build.

## 5. Final Report Shape (≤ 12 lines of substance)

```text
需求: <one line: goal + top constraints + acceptance>
候选: <owner/repo> ⭐<stars> <license> <url>   (top 1-3, fit % each)
冷门知识: <1-2 doc-missing facts, each with source link>
决策: adopt / fork / build — <one-line evidence>
下一步: <one concrete action>
```
