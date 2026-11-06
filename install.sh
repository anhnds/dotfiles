#!/usr/bin/env bash
# Cài dotfiles: Homebrew packages + symlink config bằng GNU Stow.
# Chạy lại bao nhiêu lần cũng được (idempotent).
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
PACKAGES=(zsh nvim ghostty git)   # mỗi thư mục = 1 package Stow

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARN:\033[0m %s\n' "$*"; }

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    info "Cài Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# 2. Packages trong Brewfile
info "brew bundle"
brew bundle --no-upgrade --file="$DOTFILES/Brewfile"   # chỉ cài cái thiếu, không tự update

# 3. oh-my-zsh (zshrc cần)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Cài oh-my-zsh"
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 4. Symlink bằng Stow
mkdir -p "$HOME/.config"
cd "$DOTFILES"
for pkg in "${PACKAGES[@]}"; do
  if ! stow --no -t "$HOME" -R "$pkg" 2>/dev/null; then
    warn "Xung đột khi stow '$pkg' — file thật đang chiếm chỗ:"
    stow --no -t "$HOME" -R "$pkg" 2>&1 | sed 's/^/    /' || true
    warn "Backup/xoá các file trên rồi chạy lại ./install.sh"
    exit 1
  fi
  stow -t "$HOME" -R "$pkg"
  info "stow $pkg ✓"
done

# Ghostty trên macOS cũng đọc file ở Application Support và file đó sẽ ghi đè ~/.config/ghostty
GHOSTTY_APP="$HOME/Library/Application Support/com.mitchellh.ghostty"
for f in "$GHOSTTY_APP/config" "$GHOSTTY_APP/config.ghostty"; do
  if [ -e "$f" ] || [ -L "$f" ]; then
    warn "Có '$f' — nên xoá để chỉ dùng ~/.config/ghostty"
  fi
done

info "Xong. Mở tab terminal mới hoặc chạy: exec zsh"
