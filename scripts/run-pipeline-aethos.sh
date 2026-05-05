#!/usr/bin/env bash
# Aethos Instagram Pipeline — Cron Runner
# Runs Mon/Wed/Fri at 09:00 on VPS
# Crontab: 0 9 * * 1,3,5 /path/to/scripts/run-pipeline-aethos.sh

set -euo pipefail

DATE=$(date +%Y-%m-%d)
DAY=$(date +%u)  # 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun
LOG="/data/aethos-content/pipeline.log"
CONTENT_DIR="/data/aethos-content/${DATE}"
PIPELINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Determine post type based on day
if [ "$DAY" = "5" ]; then
  POST_TYPE="reel"
else
  POST_TYPE="carousel"
fi

echo "[${DATE} $(date +%H:%M)] Pipeline START — type: ${POST_TYPE}" >> "$LOG"

# Create content directory for today
mkdir -p "$CONTENT_DIR"

# Source environment (Instagram tokens, OpenAI key)
if [ -f /etc/environment ]; then
  source /etc/environment
fi

# Validate required env vars
REQUIRED_VARS=("INSTAGRAM_ACCESS_TOKEN" "INSTAGRAM_ACCOUNT_ID" "OPENAI_API_KEY")
for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR:-}" ]; then
    echo "[${DATE} $(date +%H:%M)] ERROR: ${VAR} not set" >> "$LOG"
    echo "[${DATE} $(date +%H:%M)] Pipeline ABORTED — missing env vars" >> "$LOG"
    exit 1
  fi
done

# Run Claude Code pipeline
# Each skill reads previous skill's output from context
# Pipeline: scout → curator → lens → writer → canvas → publisher
CLAUDE_CMD="claude --print"

run_pipeline() {
  $CLAUDE_CMD "/scout aethos" \
    | $CLAUDE_CMD "/curator" \
    | $CLAUDE_CMD "/lens aethos" \
    | $CLAUDE_CMD "/writer aethos ${POST_TYPE}" \
    | $CLAUDE_CMD "/canvas" \
    | $CLAUDE_CMD "/publisher"
}

if run_pipeline >> "$LOG" 2>&1; then
  echo "[${DATE} $(date +%H:%M)] Pipeline SUCCESS" >> "$LOG"
else
  EXIT_CODE=$?
  echo "[${DATE} $(date +%H:%M)] Pipeline FAILED — exit code: ${EXIT_CODE}" >> "$LOG"
  # Log to errors file
  echo "{\"date\":\"${DATE}\",\"type\":\"${POST_TYPE}\",\"status\":\"failed\",\"exit_code\":${EXIT_CODE}}" \
    >> /data/aethos-content/errors.log
  exit $EXIT_CODE
fi
