# OODA/TDOO 军事指导速查

Load this file only when running in OODA/TDOO 军事指导模式; SKILL.md stays lean.

## 1. 什么是 TDOO

TDOO 在本技能中指 **OODA 循环**（Observe-Orient-Decide-Act）的军事化表达：
观察（Observe）→ 判断（Orient）→ 决策（Decide）→ 行动（Act）。
它由约翰·博依德提出，核心思想是**唯快不破**：比对手更快完成一轮循环，
并用行动效果驱动下一轮观察，形成闭环。用户口中的"观察、分析、进攻"
即此模型的通俗说法。

## 2. lyco 阶段 → OODA 映射

| lyco 阶段 | OODA 阶段 | 军事动作 | 关键产出 |
|-----------|-----------|----------|----------|
| ACQUIRE（gh 搜索 + 论坛调研） | Observe 观察 | 侦察/情报收集 | 事实、信号、未知项 |
| REASON（候选评估 + 根因分析） | Orient 判断 | 态势研判 | 模式、差距、≥2 假设 |
| DECIDE（build-vs-buy 决策） | Decide 决策 | 选择作战方案 | 方案 + 理由 + 代价 |
| ACT（克隆 / 最小化验证） | Act 行动 | 执行打击 | 最小验证 + 回退路径 |
| VERIFY → 下一轮 ACQUIRE | Re-observe 反馈 | 战果评估 | 结果对比 + 是否下一轮 |

## 3. 军事版核心提示词模板

每轮按此模板输出，保持简短：

```text
## Observe 侦察
- 当前状态: <只列事实>
- 信号与未知: <看到了什么、还缺什么>
- 已用检索: gh search / gh api / forum site: <命令>

## Orient 研判
- 根因或差距: <离验收标准差什么>
- 相似先例: <有没有人做过>
- 备选解释: <≥2 个假设>

## Decide 决策
- 方案 A/B: <各带理由与风险>
- 选择: <选哪个 + 置信度 + 代价>
- 验收标准: <怎么算成功>

## Act 进攻
- 最小动作: <先跑通什么>
- 验证点: <立即检查什么>
- 回退路径: <可逆方案>

## Re-observe 复盘
- 结果对比: <预测 vs 实际>
- 下一轮: <continue | stable | escalate>
```

## 4. 每阶段 gh/curl 速查

```bash
# Observe: 用近义词循环侦察现状
gh search repos "TERM" --limit 15 --sort stars
gh api "search/code?q=TERM&per_page=20"

# Orient: 检查候选健康度
gh repo view owner/repo --json stargazerCount,licenseInfo,updatedAt,description

# Decide: 套用 build-vs-buy 矩阵（见 preflight-search.md 第 4 节）

# Act: 克隆候选并做最小化验证
gh repo clone owner/repo <target-dir>
```

## 5. 边界

- 可逆动作按 70% 置信度行动；不可逆/高风险动作必须等用户确认。
- 验证未过 → 自动下一轮，从新事实重新 Observe，不修旧结论。
- 本模式仍是 lyco：不写代码、不脚手架，直到 build-vs-buy 决策已记录。
