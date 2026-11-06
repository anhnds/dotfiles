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

# 3. Tool AI ngoài Homebrew
# gitnexus (npm, khai báo trong Brewfile): npm 11 chặn build script native,
# nên cài lại với danh sách được phép nếu binary native chưa load được.
GITNEXUS_SCRIPTS="gitnexus,@ladybugdb/core,onnxruntime-node,protobufjs,tree-sitter,tree-sitter-c-sharp,tree-sitter-cpp,tree-sitter-go,tree-sitter-java,tree-sitter-javascript,tree-sitter-php,tree-sitter-python,tree-sitter-ruby,tree-sitter-rust,tree-sitter-typescript"
if ! node -e "require('$(npm root -g)/gitnexus/node_modules/@ladybugdb/core')" >/dev/null 2>&1; then
  info "Cài gitnexus (kèm build native)"
  npm install -g gitnexus --allow-scripts="$GITNEXUS_SCRIPTS"
fi

# code-review-graph (pipx)
if ! pipx list --short 2>/dev/null | grep -q '^code-review-graph '; then
  info "Cài code-review-graph"
  pipx install code-review-graph
fi

# Antigravity CLI (agy) -> ~/.local/bin. Installer có thể ghi thêm PATH vào ~/.zprofile:
# ~/.zprofile đã có sẵn ~/.local/bin nên xoá dòng đó đi (git diff sẽ thấy).
if ! command -v agy >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/agy" ]; then
  info "Cài Antigravity CLI"
  curl -fsSL https://antigravity.google/cli/install.sh | bash
fi

# 4. oh-my-zsh (zshrc cần)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Cài oh-my-zsh"
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 5. Symlink bằng Stow
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
