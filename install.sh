#!/usr/bin/env bash
set -e

echo "🜂 Installing Runes..."
echo

# =============================
# 1. Dependency check
# =============================
echo "🔍 Checking dependencies..."

install_inotify() {
  if command -v pacman >/dev/null 2>&1; then
    echo "📦 Installing inotify-tools (pacman)"
    sudo pacman -Sy --noconfirm inotify-tools
  elif command -v apt >/dev/null 2>&1; then
    echo "📦 Installing inotify-tools (apt)"
    sudo apt update && sudo apt install -y inotify-tools
  elif command -v dnf >/dev/null 2>&1; then
    echo "📦 Installing inotify-tools (dnf)"
    sudo dnf install -y inotify-tools
  elif command -v zypper >/dev/null 2>&1; then
    echo "📦 Installing inotify-tools (zypper)"
    sudo zypper install -y inotify-tools
  else
    echo "❌ Unsupported package manager"
    exit 1
  fi
}

if command -v inotifywait >/dev/null 2>&1; then
  echo "✔ inotify-tools already installed"
else
  install_inotify
fi

echo

# =============================
# 2. Resolve source directory
# =============================
echo "📍 Resolving source directory..."

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "✔ Source: $SRC_DIR"

echo

# =============================
# 3. Prepare destination
# =============================
RUNES_DIR="$HOME/.config/runes"
echo "📂 Preparing destination: $RUNES_DIR"

mkdir -p "$RUNES_DIR"
echo "✔ Destination ready"

echo

# =============================
# 4. Copy files (SAFE COPY)
# =============================
echo "📦 Copying runes..."

tar \
  --exclude=.git \
  --exclude=.config \
  --exclude=install.sh \
  --exclude=README.md \
  -C "$SRC_DIR" -cf - . \
| tar -C "$RUNES_DIR" -xf -

echo "✔ Files copied"

echo

# =============================
# 5. Permissions
# =============================
echo "⚙ Setting permissions..."

chmod +x "$RUNES_DIR/runecall"
chmod +x "$RUNES_DIR/rune_alias"

find "$RUNES_DIR" -type d -name bin -exec chmod +x {}/* \; 2>/dev/null || true

echo "✔ Executables ready"

echo

# =============================
# 6. PATH setup
# =============================
echo "🧭 Configuring PATH..."

if ! grep -q "$RUNES_DIR" "$HOME/.bashrc"; then
  echo "export PATH=\"$RUNES_DIR:\$PATH\"" >> "$HOME/.bashrc"
  echo "✔ PATH updated"
else
  echo "✔ PATH already configured"
fi

echo

# =============================
# 7. Alias sourcing
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
# 8. Done
# =============================

echo "✨ Runes installed successfully."
echo "🔁 Restart your shell or run: source ~/.bashrc"
echo "🔥 runecall is ready."

