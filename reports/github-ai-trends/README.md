# GitHub AI 趋势报告目录

本目录用于管理和存储 GitHub AI 相关趋势报告。

## 目录结构

```
reports/github-ai-trends/
├── README.md                      # 本文件
├── github-ai-trends-report.md     # 2026 年趋势报告
└── [后续报告文件]
```

## 报告管理

### 命名规范

报告文件采用以下命名格式：
`github-ai-trends-report-[YYYY-MM].md`

示例：
- `github-ai-trends-report-2026-02.md`
- `github-ai-trends-report-2026-03.md`

### 更新频率

建议每月更新一次趋势报告，以追踪 GitHub AI 生态系统的最新发展。

### 报告内容

每份报告应包含：

1. **执行摘要**：核心趋势概述
2. **分类分析**：按技术领域详细分析
3. **开发者行为洞察**：GitHub 社区行为模式
4. **未来展望**：趋势预测
5. **实用建议**：对开发者的指导

## 使用方法

### 查看最新报告

```bash
cat /root/.openclaw/workspace/reports/github-ai-trends/github-ai-trends-report.md
```

### 生成新报告

需要访问 GitHub Trending 页面或使用 GitHub API 来获取最新数据，然后更新报告内容。

### 归档旧报告

将旧报告移动到子目录：

```bash
mkdir -p /root/.openclaw/workspace/reports/github-ai-trends/archive
mv /root/.openclaw/workspace/reports/github-ai-trends/github-ai-trends-report-2026-01.md archive/
```

## 数据源

报告主要数据来源：

1. **GitHub Trending**：https://github.com/trending/ai
2. **GitHub Explore**：https://github.com/explore
3. **热门项目**：基于 Star 数量和活跃度
4. **开发者社区**：讨论、Issue、PR 活动

## 维护者

本报告目录由 OpenClaw AI Agent 维护，可根据需要更新和扩展。

---

**创建日期：** 2026-02-11
**最后更新：** 2026-02-11
