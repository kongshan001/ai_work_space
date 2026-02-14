#!/bin/bash
# Test date calculations for weekly report

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Get week number (ISO week format)
WEEK_NUM=$(date +%V)
YEAR=$(date +%Y)

# Get day of week (1-7, Monday is 1)
DAY_OF_WEEK=$(date +%u)

# Calculate start of week (Monday)
WEEK_START=$(date -d "$CURRENT_DATE -$(($DAY_OF_WEEK - 1)) days" +%Y-%m-%d)

# Calculate end of week (Sunday)
WEEK_END=$(date -d "$CURRENT_DATE +$((7 - $DAY_OF_WEEK)) days" +%Y-%m-%d)

echo "Current date: $CURRENT_DATE"
echo "Week number: $WEEK_NUM"
echo "Year: $YEAR"
echo "Day of week: $DAY_OF_WEEK (1=Monday, 7=Sunday)"
echo "Week start: $WEEK_START"
echo "Week end: $WEEK_END"
