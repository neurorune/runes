#!/usr/bin/env bash
set -e

echo "🜂 Installing Runes..."

# -----------------------------
# 1. Install dependency
# -----------------------------
install_inotify() {
  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm inotify-tools
  elif command -v apt >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y inotify-tools
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y inotify-tools
  elif command -v zypper >/dev/null 2>&1; then
    sudo zypper install -y inotify-tools
  else
    echo "❌ Unsupported package manager. Install inotify-tools manually."
    exit 1
  fi
}

if ! command -v inotifywait >/dev/null 2>&1; then
  echo "📦 Installing inotify-tools..."
  install_inotify
else
  echo "✔ inotify-tools already installed"
fi

# -----------------------------
# 2. Prepare directory
# -----------------------------
RUNES_DIR="$HOME/.config/runes"
mkdir -p "$RUNES_DIR"

# -----------------------------
# 3. Copy everything
# -----------------------------
echo "📂 Copying files to $RUNES_DIR"

cp -r ./* "$RUNES_DIR"
cp -r ./.??* "$RUNES_DIR" 2>/dev/null || true

# -----------------------------
# 4. Remove unwanted files
# -----------------------------
rm -rf "$RUNES_DIR/.git"
rm -f  "$RUNES_DIR/install.sh"
rm -f  "$RUNES_DIR/README.md"

# -----------------------------
# 5. Permissions
# -----------------------------
echo "⚙ Setting permissions"

chmod +x "$RUNES_DIR/runecall"
chmod +x "$RUNES_DIR/rune_alias"

find "$RUNES_DIR" -type d -name bin -exec chmod +x {}/* \; 2>/dev/null || true

# -----------------------------
# 6. PATH setup
# -----------------------------
if ! grep -q "$RUNES_DIR" "$HOME/.bashrc"; then
  echo "export PATH=\"$RUNES_DIR:\$PATH\"" >> "$HOME/.bashrc"
fi

# -----------------------------
# 7. Alias sourcing
# -----------------------------
if ! grep -q "rune_alias" "$HOME/.bashrc"; then
  echo "source $RUNES_DIR/rune_alias" >> "$HOME/.bashrc"
fi

# -----------------------------
# 8. Done
# -----------------------------
echo
echo "✨ Runes installed successfully."
echo "🔁 Restart your shell or run: source ~/.bashrc"
echo "🔥 runecall is live."

