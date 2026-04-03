#!/usr/bin/env bash
# Syncs shared/pipeline.md to all skill references folders.
# Run this after editing shared/pipeline.md.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/shared/pipeline.md"

SKILLS=(scout curator lens writer brief pulse update-profile)

for skill in "${SKILLS[@]}"; do
  dest="$SCRIPT_DIR/$skill/references/pipeline.md"
  cp "$SOURCE" "$dest"
  echo "✓ $skill/references/pipeline.md"
done

echo "Done — all pipeline.md files synced."
