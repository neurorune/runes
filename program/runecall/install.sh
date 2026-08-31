#!/usr/bin/env bash
set -e

echo "🜂 Installing Runecall..."
echo

PROGRAM_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_SRC="$PROGRAM_DIR/runecall"
RUNES_DIR="$HOME/.config/runes"
BIN_DIR="$HOME/.local/bin"

echo "📍 Program folder: $PROGRAM_DIR"
echo "📍 Dest binary:    $BIN_DIR/runecall"
echo "📍 Dest runes:     $RUNES_DIR"
echo

# =============================
# 1. Prepare destinations
# =============================
echo "📂 Preparing destinations..."
mkdir -p "$BIN_DIR"
mkdir -p "$RUNES_DIR"
echo "✔ Destinations ready"
echo

# =============================
# 2. Install binary
# =============================
echo "🔨 Installing binary..."
cp "$BIN_SRC" "$BIN_DIR/runecall"
chmod +x "$BIN_DIR/runecall"
echo "✔ Binary installed: $BIN_DIR/runecall"
echo

# =============================
# 3. Install runes
# =============================
echo "📦 Installing runes..."
rm -rf "$RUNES_DIR"/*
for src in "$PROGRAM_DIR"/C "$PROGRAM_DIR"/C++ "$PROGRAM_DIR"/Elixir "$PROGRAM_DIR"/Go "$PROGRAM_DIR"/JavaScript "$PROGRAM_DIR"/Python "$PROGRAM_DIR"/Rust "$PROGRAM_DIR"/rune_alias; do
  [ -e "$src" ] && cp -r "$src" "$RUNES_DIR/"
done
echo "✔ Runes installed: $RUNES_DIR"
echo

# =============================
# 4. Permissions
# =============================
echo "⚙ Setting permissions..."
chmod +x "$RUNES_DIR/rune_alias"
find "$RUNES_DIR" -type f -name "run.lua" -exec chmod +x {} \;
echo "✔ Permissions set"
echo

# =============================
# 5. PATH setup
# =============================
echo "🧭 Configuring PATH..."
if ! grep -q "$BIN_DIR" "$HOME/.bashrc"; then
  echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.bashrc"
  echo "✔ PATH updated"
else
  echo "✔ PATH already configured"
fi
echo

# =============================
# 6. Alias sourcing
# =============================
echo "🔗 Configuring aliases..."
if ! grep -q "rune_alias" "$HOME/.bashrc"; then
  echo "source $RUNES_DIR/rune_alias" >> "$HOME/.bashrc"
  echo "✔ rune_alias sourced"
else
  echo "✔ rune_alias already sourced"
fi
echo

# =============================
# 7. Done
# =============================
echo "✨ Runecall installed successfully."
echo "🔁 Restart your shell or run: source ~/.bashrc"
echo "🔥 runecall is ready."
