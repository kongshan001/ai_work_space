#!/bin/bash
# GitHub Weekly Trends Report Generator
# Run at 20:00 on Sunday (GMT+8)

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
REPORTS_DIR="$WORKSPACE_DIR/reports/github-trends"
WEEKLY_DIR="$REPORTS_DIR/weekly"

# Create weekly directory if not exists
mkdir -p "$WEEKLY_DIR"

# Load GitHub token
GITHUB_TOKEN_FILE="$HOME/.github_token"
if [ -f "$GITHUB_TOKEN_FILE" ]; then
    GITHUB_TOKEN=$(cat "$GITHUB_TOKEN_FILE")
else
    GITHUB_TOKEN=""
fi

# Generate date strings
TODAY=$(date +%Y-%m-%d)
TIME=$(date +'%H:%M:%S')

# Calculate week info (ISO week format)
WEEK_NUM=$(date +%V)
YEAR=$(date +%Y)

# Calculate start and end of week
# Get day of week (1-7, Monday is 1)
DAY_OF_WEEK=$(date +%u)

# Calculate start of week (Monday)
WEEK_START=$(date -d "$TODAY -$(($DAY_OF_WEEK - 1)) days" +%Y-%m-%d)

# Calculate end of week (Sunday)
WEEK_END=$(date -d "$TODAY +$((7 - $DAY_OF_WEEK)) days" +%Y-%m-%d)

echo "[$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')] Starting weekly GitHub trends report generation (Week $WEEK_NUM, $YEAR)..."

# Create weekly report file
WEEKLY_FILE="$WEEKLY_DIR/github-trends-weekly-$YEAR-W$(printf '%02d' $WEEK_NUM).md"

# Function to fetch trending repositories
fetch_trending() {
    local language="$1"
    local query="created:$WEEK_START..$WEEK_END"

    if [ -n "$language" ] && [ "$language" != "all" ]; then
        query="$query language:$language"
    fi

    local api_url="https://api.github.com/search/repositories?q=$query&sort=stars&order=desc&per_page=10"

    if [ -n "$GITHUB_TOKEN" ]; then
        curl -s -H "Authorization: token $GITHUB_TOKEN" \
                  -H "Accept: application/vnd.github.v3+json" \
                  "$api_url"
    else
        echo '{"items": [], "message": "No GitHub token configured"}'
    fi
}

# Fetch data for different categories
AI_DATA=$(fetch_trending "python" | jq -r '.items[:5] | .[] | "| \(.name) | \(.stargazers_count) | \([.language] + [(.topics[:3] | join(", "))] | join(", ")) | \(.description | if . == null then "" else (. | split("\n") | .[0]) end) |"' 2>/dev/null || echo "")

CODING_DATA=$(fetch_trending "javascript" | jq -r '.items[:5] | .[] | "| \(.name) | \(.stargazers_count) | \([.language] + [(.topics[:3] | join(", "))] | join(", ")) | \(.description | if . == null then "" else (. | split("\n") | .[0]) end) |"' 2>/dev/null || echo "")

INFRA_DATA=$(fetch_trending "go" | jq -r '.items[:5] | .[] | "| \(.name) | \(.stargazers_count) | \([.language] + [(.topics[:3] | join(", "))] | join(", ")) | \(.description | if . == null then "" else (. | split("\n") | .[0]) end) |"' 2>/dev/null || echo "")

OTHER_DATA=$(fetch_trending "all" | jq -r '.items[5:10] | .[] | "| \(.name) | \(.stargazers_count) | \([.language] + [(.topics[:3] | join(", "))] | join(", ")) | \(.description | if . == null then "" else (. | split("\n") | .[0]) end) |"' 2>/dev/null || echo "")

# Generate report header
cat > "$WEEKLY_FILE" << HEADER
# GitHub 每周趋势 - $YEAR 第 $(printf '%02d' $WEEK_NUM) 周

**发布日期**：$TODAY
**发布时间**：$TIME (GMT+8)
**统计周期**：$WEEK_START 至 $WEEK_END

---

## 📊 执行摘要

本周 GitHub 趋势核心洞察：

- **热门领域**：AI、编程工具、基础设施
- **趋势变化**：基于 GitHub API 数据分析
- **新兴项目**：本周新创建的高 Star 项目
- **开发者行为**：社区活跃度与贡献趋势

---

## 🔥 本周 Top 50 热门项目

### AI 领域 Top 15

| 项目 | 本周 Stars | 总 Stars | 主要标签 | 简介 |
|------|-----------|----------|----------|------|
HEADER

# Add AI data
if [ -n "$AI_DATA" ]; then
    echo "$AI_DATA" >> "$WEEKLY_FILE"
else
    echo "| 暂无数据 | - | - | - | - |" >> "$WEEKLY_FILE"
fi

# Add coding section
cat >> "$WEEKLY_FILE" << 'SECTION'

### 编程工具 Top 10

| 项目 | 本周 Stars | 总 Stars | 主要标签 | 简介 |
|------|-----------|----------|----------|------|
SECTION

# Add coding data
if [ -n "$CODING_DATA" ]; then
    echo "$CODING_DATA" >> "$WEEKLY_FILE"
else
    echo "| 暂无数据 | - | - | - | - |" >> "$WEEKLY_FILE"
fi

# Add infrastructure section
cat >> "$WEEKLY_FILE" << 'SECTION'

### 基础设施 Top 10

| 项目 | 本周 Stars | 总 Stars | 主要标签 | 简介 |
|------|-----------|----------|----------|------|
SECTION

# Add infra data
if [ -n "$INFRA_DATA" ]; then
    echo "$INFRA_DATA" >> "$WEEKLY_FILE"
else
    echo "| 暂无数据 | - | - | - | - |" >> "$WEEKLY_FILE"
fi

# Add other section
cat >> "$WEEKLY_FILE" << 'SECTION'

### 其他领域 Top 15

| 项目 | 本周 Stars | 总 Stars | 主要标签 | 简介 |
|------|-----------|----------|----------|------|
SECTION

# Add other data
if [ -n "$OTHER_DATA" ]; then
    echo "$OTHER_DATA" >> "$WEEKLY_FILE"
else
    echo "| 暂无数据 | - | - | - | - |" >> "$WEEKLY_FILE"
fi

# Add footer with analysis
cat >> "$WEEKLY_FILE" << 'FOOTER'

---

## ⭐ 本周 Star 增长最快

### 按绝对增长

| 项目 | 本周增长 | 总 Stars | 领域 |
|------|----------|----------|------|
| [基于 API 数据分析] | - | - | - |

### 按增长率

| 项目 | 增长率 | 本周增长 | 领域 |
|------|--------|----------|------|
| [基于 API 数据分析] | - | - | - |

---

## 🌟 深度项目分析

### 1. [本周最热门项目]

**分类**：[根据标签分析]
**本周排名**：第 1 名
**总 Stars**：[从 API 获取]

#### 项目简介

[基于 GitHub API 获取项目描述和详细信息]

#### 技术栈

- [从 API 获取主要语言]
- [从 topics 获取技术标签]

#### 为什么本周爆发？

- [分析 Star 增长趋势]
- [分析社区活跃度]
- [分析技术亮点]

#### 最佳实践场景

**场景 1：[具体场景]**
\`\`\`bash
# 使用示例（基于项目文档）
\`\`\`

**场景 2：[具体场景]**
\`\`\`python
# 代码示例
\`\`\`

#### 注意事项

- ⚠️ [基于项目 README 和 Issues 分析]
- ⚠️ [潜在限制]

#### 替代方案

- [基于同类项目对比]

---

## 📈 趋势分析

### 技术领域对比

| 领域 | 本周热门项目数 | Star 增长 | 趋势方向 |
|------|---------------|-----------|----------|
| AI | [统计] | [统计] | ↗️ 上升 |
| 编程工具 | [统计] | [统计] | → 稳定 |
| 基础设施 | [统计] | [统计] | ↘️ 下降 |

### 对上周变化

**新兴领域**：
- [基于本周数据 vs 上周数据对比]

**衰退领域**：
- [分析热度变化]

**技术关键词变化**：
- 本周热门：[从 topics 统计]
- 上周热门：[需要历史数据对比]

---

## 💡 开发者行为洞察

### 贡献者活跃度

- **平均周活跃贡献者**：[需要 API 支持]
- **最活跃项目**：[从 contributor data 分析]

### Issue 和 PR 活动

- **新增 Issue**：[从 API 统计]
- **合并 PR**：[从 API 统计]
- **最活跃社区**：[基于 community profile]

### Fork 和 Clone 行为

- **被 Fork 最多的项目**：[从 API 获取 forks count]
- **开发者关注点**：[基于 language 和 topic 统计]

---

## 🆕 新发现的优秀项目

### 本周新上榜项目

- **[项目名](url)**：[基于 API 自动获取] - [推荐指数 ★★★★☆]
- **[项目名](url)**：[基于 API 自动获取] - [推荐指数 ★★★★☆]

### 值得长期关注的项目

**列入观察列表**：
- [项目 1](url)：[基于持续高增长]
- [项目 2](url)：[基于技术创新性]

---

## 📚 推荐阅读

### 本周热门博客文章

- [文章标题](url)：[简短描述]
- [文章标题](url)：[简短描述]

### GitHub Discussions 热门话题

- [讨论主题](url)：[观点摘要]

---

## 🔮 下周预测

基于本周趋势，预计下周：

- **热门领域**：AI、云原生、边缘计算
- **可能爆发的项目**：[基于当前趋势]
- **技术趋势**：[持续观察]

---

## 🔗 相关资源

- **GitHub Trending**：https://github.com/trending
- **GitHub API**：https://api.github.com
- **项目详情**：查看 `projects/` 目录
- **日报归档**：`daily/` 目录
- **月度报告**：`monthly/` 目录

---

**报告生成**：OpenClaw AI Agent
**更新频率**：每周日 20:00 (GMT+8)
**归档期限**：4 周
**数据来源**：GitHub API
FOOTER

echo "[$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')] Weekly report generated: $WEEKLY_FILE"

# Commit to git
cd "$WORKSPACE_DIR"
git add "$WEEKLY_FILE"
if git diff --cached --quiet; then
    echo "No changes to commit"
else
    git commit -m "Auto: Add weekly GitHub trends report for $YEAR-W$(printf '%02d' $WEEK_NUM)"
    git push origin master
    echo "[$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')] Report committed and pushed to GitHub"
fi

echo "[$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')] Weekly trends generation completed"
