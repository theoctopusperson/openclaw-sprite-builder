#!/usr/bin/env bash
set -euo pipefail

# OpenClaw Sprite Builder — setup script
# Run inside a sprite to set up the builder service.
#
# Usage:
#   git clone https://github.com/theoctopusperson/openclaw-sprite-builder.git ~/openclaw-builder
#   cd ~/openclaw-builder
#   bash setup.sh

DIR="$(cd "$(dirname "$0")" && pwd)"

log() { echo "[setup] $*"; }

log "Installing dependencies..."
cd "$DIR"
npm install

log "Creating start script..."
cat > "$DIR/start.sh" << EOF
#!/bin/bash
cd $DIR
exec node server.js
EOF
chmod +x "$DIR/start.sh"

log "Registering sprite service..."
EXISTING=$(sprite-env curl -s "/v1/services/openclaw-builder" 2>/dev/null || echo "")

if echo "$EXISTING" | jq -e '.name' >/dev/null 2>&1; then
  log "Stopping existing service..."
  sprite-env curl -s -X POST "/v1/services/openclaw-builder/stop" >/dev/null 2>&1 || true
  sleep 1
fi

sprite-env curl -s -X PUT "/v1/services/openclaw-builder" \
  -d "{\"cmd\": \"$DIR/start.sh\", \"args\": [], \"needs\": [], \"http_port\": 8080}" \
  >/dev/null

log "Starting service..."
sprite-env services start openclaw-builder 2>/dev/null || true

log "Done. Builder is running at your sprite's URL."
