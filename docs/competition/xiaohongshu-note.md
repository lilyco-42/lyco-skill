# 小红书笔记（参赛发布用）

> 发布时须带标签（不少于一条）：`#小红书Skill创新赛` `#2026华为开发者大赛`
> 配图建议：封面（banner）+ 3 张流程截图 + 1 张「省下 80% 轮子」对比图。

## 标题（任选）

1. 我让 AI 写代码前先「查一遍」，少造了 80% 的轮子 🕵️
2. 别再让 AI 一上来就写代码了，先做这一步能省三天
3. 一个 Skill，治好 AI 的「造轮子瘾」

## 正文

姐妹们，先说结论：**AI 写代码最大的浪费，不是写错，是根本没查有没有人写过。**

我之前让 AI 做个下载器，它吭哧吭哧搭了两天架子，结果 `yt-dlp` 早就把活干完了……
后来我给它加了一个「预研先行」的 Skill，流程变成这样👇

1️⃣ **先钉需求**：目标 + 约束 + 验收，钉成一句话。听不懂的词必须问，不许猜。
2️⃣ **再搜现成**：`gh search repos` 换 3-5 个近义词反复搜，按 star / 许可证 / 最近更新筛。
3️⃣ **挖冷门知识**：Reddit、Stack Overflow、吾爱破解、HN，专找官方文档不写的坑。
4️⃣ **算 build-vs-buy**：现成方案覆盖 ≥80% 就直接用；要自研，必须说清是哪条硬约束逼的。
5️⃣ **最后才动手**：克隆验证 or 最小脚手架，汇报不超过 12 行。

最爽的是它的「刹车」：**决策没写下来之前，禁止写代码。**
AI 再也不会假装看懂「这里改一下」，而是反过来问你到底要什么。

现在这个 Skill 已经开源（MIT），一行命令装到 60+ 个 Agent 里：

Linux / macOS
`curl -fsSL https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.sh | bash`

Windows
`iex (irm https://raw.githubusercontent.com/lilyco-42/lyco-skill/main/install.ps1)`

用了一周，最直观的变化：**开工前的 10 分钟调研，省掉了后面 3 天的返工。**
如果你也受够了 AI 造轮子，真的可以试试。

项目在这 👉 github.com/lilyco-42/lyco-skill

#小红书Skill创新赛 #2026华为开发者大赛 #AI编程 #AIAgent #效率工具 #程序员 #开源 #ClaudeCode #CodeArts

## 评论区自评（置顶）

补充一下原理：它符合 Agent Skills 开放标准（SKILL.md + frontmatter），不是某个平台专属。
`gh` 没登录也能跑，会自动降级到 GitHub API；调研全程只读，不碰你的代码。

## 发布检查

- [ ] 两个标签都带上
- [ ] 正文里的安装命令可复制
- [ ] 配图第一张是「少造 80% 轮子」钩子
- [ ] 评论区补 GitHub 链接
- [ ] 发布后把笔记链接回填到大赛平台