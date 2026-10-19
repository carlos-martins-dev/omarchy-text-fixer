#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

PLUGIN_ID="carlos-martins-dev.text-fixer"
BINDINGS="$HOME/.config/hypr/bindings.lua"

for cmd in ollama curl jq wl-copy wl-paste wtype notify-send hyprctl; do
  command -v "$cmd" >/dev/null || {
    echo "Missing command: $cmd" >&2
    exit 1
  }
done

MODEL="${TEXT_FIXER_MODEL:-gemma3:4b}"

echo "→ Ollama model $MODEL"
ollama pull "$MODEL"

echo "→ Super+Alt+P binding in $BINDINGS"
if grep -q "$PLUGIN_ID" "$BINDINGS" 2>/dev/null; then
  echo "  (already present, kept)"
else
  cp "$BINDINGS" "$BINDINGS.bak.$(date +%s)"
  {
    echo
    cat hypr/binding.lua
  } >>"$BINDINGS"
fi
hyprctl reload >/dev/null
hyprctl configerrors

echo "Done. Install the plugin with: omarchy plugin add <repo-url> --enable"
