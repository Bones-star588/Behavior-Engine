#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/Library/Application Support/HourlyWorkLogger"
AGENT_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$AGENT_DIR/com.codex.hourly-work-logger.plist"
TICK_SCRIPT_TARGET="$TARGET_DIR/hourly_tick.sh"
PROMPT_SCRIPT_TARGET="$TARGET_DIR/hourly_prompt.js"
CORE_SCRIPT_TARGET="$TARGET_DIR/logger_core.py"

mkdir -p "$TARGET_DIR" "$AGENT_DIR"
cp "$SCRIPT_DIR/hourly_tick.sh" "$TICK_SCRIPT_TARGET"
cp "$SCRIPT_DIR/hourly_prompt.js" "$PROMPT_SCRIPT_TARGET"
cp "$SCRIPT_DIR/logger_core.py" "$CORE_SCRIPT_TARGET"
chmod +x "$TICK_SCRIPT_TARGET" "$CORE_SCRIPT_TARGET"

/usr/bin/python3 "$CORE_SCRIPT_TARGET" status >/dev/null

cat > "$PLIST_PATH" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.codex.hourly-work-logger</string>

  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>$TICK_SCRIPT_TARGET</string>
  </array>

  <key>RunAtLoad</key>
  <true/>

  <key>StartInterval</key>
  <integer>60</integer>

  <key>StandardOutPath</key>
  <string>$TARGET_DIR/stdout.log</string>

  <key>StandardErrorPath</key>
  <string>$TARGET_DIR/stderr.log</string>
</dict>
</plist>
PLIST

if launchctl print "gui/$(id -u)/com.codex.hourly-work-logger" >/dev/null 2>&1; then
  launchctl bootout "gui/$(id -u)" "$PLIST_PATH" >/dev/null 2>&1 || true
fi

launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"
launchctl enable "gui/$(id -u)/com.codex.hourly-work-logger"
launchctl kickstart -k "gui/$(id -u)/com.codex.hourly-work-logger"

echo "Installed Hourly Work Logger."
echo "Tick script: $TICK_SCRIPT_TARGET"
echo "LaunchAgent: $PLIST_PATH"
