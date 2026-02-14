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

# Generate date strings
TODAY=$(date +%Y-%m-%d)
TIME=$(date +'%H:%M:%S')
DATE_CN=$(TZ='Asia/Shanghai' date +'%Y年%m月%d日')

echo "[$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')] Starting daily GitHub trends report generation..."

# Create daily report file
DAILY_FILE="$DAILY_DIR/github-trends-daily-$TODAY.md"

# Generate report content using OpenClaw agent
cat > "$DAILY_FILE" << 'HEADER'
# GitHub 每日趋势 - {DATE}

**发布日期**：{DATE}
**发布时间**：{TIME} (GMT+8)
**数据来源**：GitHub Trending

---

## 📊 执行摘要

今日 GitHub Trending 核心亮点：

- **热门领域**：[主要热门技术领域]
- **新星项目**：[新崛起的优秀项目]
- **Star 爆发**：[Star 增长最快的项目]
- **技术趋势**：[观察到的新趋势]

---

## 🔥 今日 Top 20 热门项目

### AI 领域

| 排名 | 项目 | Stars | 主要标签 | 简述 |
|------|------|-------|----------|------|
HEADER

# Fetch GitHub trending data
echo "Fetching GitHub trending data..."

# Use curl to fetch trending page
TRENDING_DATA=$(curl -s "https://github.com/trending" \
  -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36")

# Extract trending repositories (basic parsing)
echo "" >> "$DAILY_FILE"
echo "> **注意**：此报告为自动生成的框架，需手动完善数据或配置 API Token 以获取实时数据。" >> "$DAILY_FILE"
echo "" >> "$DAILY_FILE"
echo "**数据获取说明**：" >> "$DAILY_FILE"
echo "- 如需自动获取实时数据，请配置 GitHub Personal Access Token" >> "$DAILY_FILE"
echo '- Token 权限需包含：`public_repo`, `read:user`' >> "$DAILY_FILE"
echo "" >> "$DAILY_FILE"

cat >> "$DAILY_FILE" << 'FOOTER'

### 编程工具

| 排名 | 项目 | Stars | 主要标签 | 简述 |
|------|------|-------|----------|------|
| 1 | [project-name](url) | 0 | [tags] | 简短描述 |

### 基础设施

| 排名 | 项目 | Stars | 主要标签 | 简述 |
|------|------|-------|----------|------|
| 1 | [project-name](url) | 0 | [tags] | 简短描述 |

### 其他领域

| 排名 | 项目 | Stars | 主要标签 | 简述 |
|------|------|-------|----------|------|
| 1 | [project-name](url) | 0 | [tags] | 简短描述 |

---

## ⭐ Star 增长最快（24小时）

| 项目 | 24h Star 增长 | 总 Stars | 增长率 |
|------|---------------|----------|--------|
| [project-name](url) | +0 | 0 | 0% |
| [project-name](url) | +0 | 0 | 0% |

---

## 🌟 今日项目亮点

### [项目名称](项目链接)

**分类**：[AI/编程/基础设施/...]

**Star 数量**：[当前 Stars]

**简介**：
[项目的主要功能和特点描述]

**为什么值得关注**：
- [突出特点 1]
- [突出特点 2]

**最佳实践场景**：
- 场景 1：[具体使用场景]
- 场景 2：[具体使用场景]

**快速开始**：
```bash
# 安装
pip install package-name

# 使用示例
python example.py
```

---

## 💡 新发现

### 新兴项目

- **[项目名](url)**：[简短描述]
- **[项目名](url)**：[简短描述]

### 技术趋势观察

- [趋势 1]：[描述和影响]
- [趋势 2]：[描述和影响]

---

## 📈 技术雷达

**关注领域**：

- 🟢 **值得尝试**：[项目]
- 🟡 **谨慎使用**：[项目]
- 🔴 **需要观望**：[项目]

---

## 🔗 相关资源

- **GitHub Trending**：https://github.com/trending
- **GitHub Explore**：https://github.com/explore
- **项目详情**：查看 `projects/` 目录下的详细分析

---

**报告生成**：OpenClaw AI Agent
**更新频率**：每日 18:00 (GMT+8)
FOOTER

# Replace placeholders
sed -i "s/{DATE}/$TODAY/g" "$DAILY_FILE"
sed -i "s/{TIME}/$TIME/g" "$DAILY_FILE"

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
