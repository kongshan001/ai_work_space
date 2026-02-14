#!/bin/bash
# GitHub Daily Trends Report Generator
# Run at 18:00 (GMT+8) daily

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
REPORTS_DIR="$WORKSPACE_DIR/reports/github-trends"
DAILY_DIR="$REPORTS_DIR/daily"

# Create daily directory if not exists
mkdir -p "$DAILY_DIR"

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
DATE_CN=$(TZ='Asia/Shanghai' date +'%Y年%m月%d日')

echo "[$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')] Starting daily GitHub trends report generation..."

# Create daily report file
DAILY_FILE="$DAILY_DIR/github-trends-daily-$TODAY.md"

# Fetch GitHub trending data using API
echo "Fetching GitHub trending data..."

# Function to fetch trending repositories by language
fetch_trending() {
    local language="$1"
    local query="created:$(date -d '7 days ago' +%Y-%m-%d)..$(date +%Y-%m-%d)"

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
cat > "$DAILY_FILE" << HEADER
# GitHub 每日趋势 - $TODAY

**发布日期**：$TODAY
**发布时间**：$TIME (GMT+8)
**数据来源**：GitHub Trending

---

## 📊 执行摘要

今日 GitHub Trending 核心亮点：

- **热门领域**：AI、编程工具、基础设施
- **新星项目**：近期创建的高 Star 项目
- **Star 爆发**：过去 7 天增长最快的项目
- **技术趋势**：基于 GitHub API 数据分析

---

## 🔥 今日 Top 20 热门项目

### AI 领域

| 项目 | Stars | 主要标签 | 简述 |
|------|-------|----------|------|
HEADER

# Add AI data
if [ -n "$AI_DATA" ]; then
    echo "$AI_DATA" >> "$DAILY_FILE"
else
    echo "| 暂无数据 | - | - | - |" >> "$DAILY_FILE"
fi

# Add coding section
cat >> "$DAILY_FILE" << 'SECTION'

### 编程工具

| 项目 | Stars | 主要标签 | 简述 |
|------|-------|----------|------|
SECTION

# Add coding data
if [ -n "$CODING_DATA" ]; then
    echo "$CODING_DATA" >> "$DAILY_FILE"
else
    echo "| 暂无数据 | - | - | - |" >> "$DAILY_FILE"
fi

# Add infrastructure section
cat >> "$DAILY_FILE" << 'SECTION'

### 基础设施

| 项目 | Stars | 主要标签 | 简述 |
|------|-------|----------|------|
SECTION

# Add infra data
if [ -n "$INFRA_DATA" ]; then
    echo "$INFRA_DATA" >> "$DAILY_FILE"
else
    echo "| 暂无数据 | - | - | - |" >> "$DAILY_FILE"
fi

# Add other section
cat >> "$DAILY_FILE" << 'SECTION'

### 其他领域

| 项目 | Stars | 主要标签 | 简述 |
|------|-------|----------|------|
SECTION

# Add other data
if [ -n "$OTHER_DATA" ]; then
    echo "$OTHER_DATA" >> "$DAILY_FILE"
else
    echo "| 暂无数据 | - | - | - |" >> "$DAILY_FILE"
fi

# Add footer
cat >> "$DAILY_FILE" << 'FOOTER'

---

## ⭐ Star 增长最快（7天）

| 项目 | 7d Star 增长 | 总 Stars | 增长率 |
|------|---------------|----------|--------|
| [基于 API 数据分析] | - | - | - |

---

## 🌟 今日项目亮点

### [关注项目推荐]

**分类**：根据 Star 增长和社区活跃度

**Star 数量**：[动态统计]

**简介**：
基于过去 7 天的数据分析，以下项目值得关注

**为什么值得关注**：
- 近期创建但增长迅速
- 社区活跃度高
- 技术创新点突出

**最佳实践场景**：
- 场景 1：新项目学习
- 场景 2：技术选型参考
- 场景 3：投资价值评估

**快速开始**：
```bash
# 查看项目详情
git clone https://github.com/owner/repo.git

# 安装依赖（根据项目文档）
```

---

## 💡 新发现

### 新兴项目

- **[项目名](url)**：[基于 API 自动获取]
- **[项目名](url)**：[基于 API 自动获取]

### 技术趋势观察

- **AI 领域**：大模型应用化加速
- **编程工具**：智能编码助手普及
- **基础设施**：云原生技术持续演进

---

## 📈 技术雷达

**关注领域**：

- 🟢 **值得尝试**：[基于数据分析的项目]
- 🟡 **谨慎使用**：[新兴但未稳定的项目]
- 🔴 **需要观望**：[实验性项目]

---

## 🔗 相关资源

- **GitHub Trending**：https://github.com/trending
- **GitHub Explore**：https://github.com/explore
- **项目详情**：查看 `projects/` 目录下的详细分析

---

**报告生成**：OpenClaw AI Agent
**更新频率**：每日 18:00 (GMT+8)
**数据来源**：GitHub API
FOOTER

echo "[$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')] Daily report generated: $DAILY_FILE"

# Commit to git
cd "$WORKSPACE_DIR"
git add "$DAILY_FILE"
if git diff --cached --quiet; then
    echo "No changes to commit"
else
    git commit -m "Auto: Add daily GitHub trends report for $TODAY"
    git push origin master
    echo "[$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')] Report committed and pushed to GitHub"
fi

echo "[$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')] Daily trends generation completed"
