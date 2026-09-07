# 软件开发组合 SDLC 速查

Load this file only when running in 软件开发组合/SDLC 模式; SKILL.md stays lean.

## 1. 什么是 SDLC 组合

lyco 的循环是一条 **软件开发组合（SDLC）闭环**：需求→调研→分析·设计→ROI→决策→
开发·落地→验证→维护·迭代。lyco **重仓前端**（需求到决策+验证），**开发/测试/部署/
维护**走 `skill-radar` 路由给专家技能（oma-backend/oma-debug 等），lyco 只做轻量
落地与反馈驱动。底层的"快循环"思想沿用 OODA（博依德）：可逆动作先求 70% 置信度
就行动，行动后必须重新观察，不停在"好像完成了"。

## 2. SDLC 阶段 → lyco 场景映射

| SDLC 阶段 | lyco 场景 | 关键产出 |
|----------|----------|----------|
| 需求 Requirement | PREPARE | 一行需求 + 验收标准（理解门槛过） |
| 调研 Research | ACQUIRE | 候选清单 + niche 知识 + 源 |
| 分析·设计 Analysis & Design | REASON / EXPLORE / DEEP-DIVE | fit 矩阵 + ≥2 备选 + 知识图谱 |
| ROI 评估（R 门槛） | (WEIGH) | 产出值÷投入本 + 过/不过门槛 |
| 决策 Decision | DECIDE | adopt/fork/build + 理由 + 代价 |
| 开发·落地 Dev(轻) | ACT | 最小 clone/scaffold（深度→skill-radar） |
| 验证 Verify | VERIFY/FINALIZE | 每条结论有源 + ≤12 行报告 |
| 维护·迭代 Maintain | → 下一轮 PREPARE | 反馈驱动下一轮（深度运维→skill-radar） |

## 3. SDLC 核心提示词模板

每轮按此模板输出，保持简短：

```text
## 需求 Requirement
- 一行需求: <goal + 验收标准>
- 模糊词已澄清: <理解门槛过；没看懂已先搜+先问>

## 调研 Research
- gh/论坛检索: <命令 + site>
- 候选清单: <stars/license/更新/fit>
- niche 知识: <文档缺失的坑 + 源>

## 分析·设计 Analysis & Design
- fit 矩阵: <候选 vs 需求>
- ≥2 备选: <解释 + 先例>
- 差距/知识图谱: <无人之境时整理>

## ROI 权衡
- 产出值: <需求价值/补缺/可复用>
- 投入本: <工时/风险/验证>
- 门槛: <过→进决策；不过→缩方案或换题>

## 决策 Decision
- adopt/fork/build: <选哪个 + 命名硬约束>
- 代价: <置信度 + 代价>
- 验收标准: <怎么算成功>

## 开发·落地 Dev(轻)
- 最小动作: <clone / scaffold>
- 深度开发: <→ skill-radar 路由专家技能>

## 验证 Verify
- 每条结论有源: <repo URL / 论坛 / 论文>
- 需求仍被满足: <是/否>
- 报告: <≤12 行>

## 维护·迭代 Maintain
- 下一轮: <continue | stable | escalate>
```

## 4. 每阶段 gh/curl 速查

```bash
# 需求·调研: 近义词循环 + 论坛挖冷门
gh search repos "TERM" --limit 15 --sort stars
gh api "search/code?q=TERM&per_page=20"

# 分析: 检查候选健康度
gh repo view owner/repo --json stargazerCount,licenseInfo,updatedAt,description

# 决策: 套用 build-vs-buy 矩阵（见 preflight-search.md 第 4 节）

# 开发·落地: 克隆候选并做最小化验证
gh repo clone owner/repo <target-dir>
```

## 5. 边界

- 可逆动作按 70% 置信度行动；不可逆/高风险动作必须等用户确认。
- 验证未过 → 自动下一轮，从新事实重新调研，不修旧结论。
- 本模式仍是 lyco：不写代码、不脚手架，直到 build-vs-buy 决策已记录；深度开发/运维走 skill-radar。
