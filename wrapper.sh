#!/usr/bin/env sh
APP="nixos-extended-rebuilder"
# Get the absolute path of the script itself
SCRIPT_PATH="$(realpath "$0")"
# Get the bin directory containing the script
BIN_DIR="$(dirname "$SCRIPT_PATH")"
# Get the app directory (parent of bin)
APP_DIR="$(dirname "$BIN_DIR")"

# Run rebuild script
exec "$APP_DIR/bin/lua" "$APP_DIR/app.lua"