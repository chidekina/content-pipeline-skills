#!/usr/bin/env bash
# Add Aethos pipeline cron jobs to VPS crontab
# Run once on VPS after vps-setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIPELINE_SCRIPT="${SCRIPT_DIR}/run-pipeline-aethos.sh"
TOKEN_SCRIPT="${HOME}/scripts/renew-instagram-token.sh"

# Verify scripts exist
if [ ! -f "$PIPELINE_SCRIPT" ]; then
  echo "ERROR: Pipeline script not found: $PIPELINE_SCRIPT"
  exit 1
fi

# Add cron jobs (idempotent — removes existing Aethos entries first)
CRON_TMP=$(mktemp)
crontab -l 2>/dev/null | grep -v "run-pipeline-aethos\|renew-instagram-token" > "$CRON_TMP" || true

echo "# Aethos Instagram Pipeline" >> "$CRON_TMP"
echo "0 9 * * 1,3,5 ${PIPELINE_SCRIPT} # Mon/Wed/Fri carousel+reel" >> "$CRON_TMP"
echo "0 9 1 */45 * ${TOKEN_SCRIPT} # Instagram token renewal every 45 days" >> "$CRON_TMP"

crontab "$CRON_TMP"
rm "$CRON_TMP"

echo "✅ Cron jobs installed:"
crontab -l | grep -E "aethos|instagram-token"
