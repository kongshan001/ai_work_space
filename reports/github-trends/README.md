# GitHub 趋势追踪系统

这是一个系统化的 GitHub 趋势追踪体系，通过定期收集和分析 GitHub 上的热门项目，为开发者提供高质量的开源项目推荐和最佳实践指南。

## 📋 目录结构

```
github-trends/
├── README.md                           # 本文件
├── templates/                          # 报告模板
│   ├── daily-template.md              # 每日报告模板
│   ├── weekly-template.md             # 每周报告模板
│   └── monthly-template.md            # 每月报告模板
│
├── daily/                              # 每日趋势报告
│   ├── github-trends-daily-2026-02-11.md
│   └── archive/                        # 归档（保留最近7天）
│
├── weekly/                             # 每周趋势报告
│   ├── github-trends-weekly-2026-W06.md
│   └── archive/                        # 归档（保留最近4周）
│
├── monthly/                            # 每月趋势报告
│   ├── github-trends-monthly-2026-02.md
│   └── archive/                        # 归档（永久保留）
│
└── projects/                           # 优秀项目库
    ├── ai/                            # AI 相关项目
    ├── coding/                        # 编程工具
    ├── infrastructure/                # 基础设施
    ├── safety/                        # 安全工具
    └── applications/                  # 应用程序
```

## 🔄 报告周期

### 每日趋势 (Daily Trends)

**发布时间**：每天 18:00 (GMT+8)

**内容范围**：
- 当日 GitHub Trending Top 20 项目
- 新兴项目快速识别
- Star 增长最快的项目
- 值得关注的更新

**报告格式**：简洁版，聚焦最新动态

**保留期限**：7 天（之后归档）

### 每周趋势 (Weekly Trends)

**发布时间**：每周日 20:00 (GMT+8)

**内容范围**：
- 本周热门项目 Top 50
- 新增优秀项目深度分析
- 开发者活动统计
- 技术趋势变化分析

**报告格式**：中等详细，包含项目简介

**保留期限**：4 周（之后归档）

### 每月趋势 (Monthly Trends)

**发布时间**：每月最后一天 20:00 (GMT+8)

**内容范围**：
- 月度热门项目 Top 100
- 深度项目分析和最佳实践
- 技术生态演变
- 开发者行为洞察
- 下月趋势预测

**报告格式**：详细报告，包含最佳实践场景

**保留期限**：永久归档

## 📊 项目分类

### AI (人工智能)
- 大语言模型 (LLM)
- 多模态 AI
- AI 应用框架
- 机器学习工具

### Coding (编程工具)
- AI 编程助手
- 代码生成工具
- 编辑器插件
- 开发工具链

### Infrastructure (基础设施)
- 云原生工具
- DevOps 平台
- 监控和日志
- 部署自动化

### Safety (安全)
- AI 安全工具
- 代码安全扫描
- 隐私保护
- 安全审计

### Applications (应用程序)
- 实用工具
- 效率应用
- 创新项目
- 社区热门

## 📝 报告模板

每份报告都应包含以下标准章节：

### 必须包含
1. **执行摘要**：核心趋势概述
2. **热门榜单**：按分类排序的项目列表
3. **项目亮点**：精选项目详细介绍
4. **最佳实践**：项目使用场景和建议

### 可选包含
5. **趋势分析**：对比上周/上月的变化
6. **开发者洞察**：社区行为分析
7. **技术展望**：未来发展方向预测

## 🛠️ 使用方法

### 查看最新报告

```bash
# 最新日报
cat /root/.openclaw/workspace/reports/github-trends/daily/github-trends-daily-$(date +%Y-%m-%d).md

# 最新周报
cat /root/.openclaw/workspace/reports/github-trends/weekly/github-trends-weekly-$(date +%Y-W%V).md

# 最新月报
cat /root/.openclaw/workspace/reports/github-trends/monthly/github-trends-monthly-$(date +%Y-%m).md
```

### 生成新报告

报告由 OpenClaw AI Agent 自动生成，遵循以下流程：

1. **数据收集**：从 GitHub Trending 页面获取数据
2. **数据分析**：识别热门项目和趋势变化
3. **报告生成**：使用标准模板创建报告
4. **质量检查**：验证内容准确性和格式
5. **提交更新**：Git commit 并推送到远程仓库

### 归档管理

报告自动归档，保留期限：
- 日报：7 天
- 周报：4 周
- 月报：永久

## 📊 数据来源

- **GitHub Trending**：https://github.com/trending
- **GitHub Explore**：https://github.com/explore
- **GitHub Topics**：按技术分类的项目聚合
- **社区反馈**：开发者讨论和推荐

## 🎯 质量标准

### 项目筛选标准

- **活跃度**：最近的提交频率和贡献者数量
- **Stars 增长**：过去 7/30 天的 Star 增长率
- **社区参与**：Issue 讨论、PR 活动等
- **文档质量**：README 清晰度、代码注释
- **实用性**：解决实际问题的能力

### 推荐场景

每个项目推荐应包含：
- **适用场景**：什么情况下使用
- **最佳实践**：如何正确使用
- **注意事项**：潜在问题和限制
- **替代方案**：其他类似工具

## 🔧 维护指南

### 定期维护任务

- **每日**：生成并提交日报
- **每周**：汇总生成周报，清理过期日报
- **每月**：深度分析生成月报，整理项目库
- **每季度**：回顾和优化报告模板

### 项目库更新

当发现优秀的开源项目时：
1. 创建项目详情文档
2. 分类存储到对应目录
3. 添加到相应周期的趋势报告
4. 更新项目索引

## 📈 指标追踪

系统追踪以下关键指标：

- 报告发布及时性
- 项目推荐准确性
- 开发者采纳率
- 社区反馈质量

---

**维护者**：OpenClaw AI Agent
**最后更新**：2026-02-11
**版本**：1.0
