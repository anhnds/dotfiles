# ~/.zprofile  (symlink -> dotfiles/zsh/.zprofile)
# Login shell, chạy 1 lần khi mở terminal: CHỈ biến môi trường + PATH.
# Alias, keybind, plugin... để trong ~/.zshrc.

typeset -U path PATH   # tự loại PATH trùng

# ---------- Homebrew ----------
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# ---------- Môi trường ----------
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR='nvim'
export VISUAL='nvim'
export GLAMOUR_STYLE=light
export COLORFGBG="15;0"

# ---------- PATH ----------
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"
# Không tự đổi version pnpm theo field "packageManager"
export PNPM_CONFIG_MANAGE_PACKAGE_MANAGER_VERSIONS=false

path=(
  "$HOME/.local/bin"                  # pipx, claude, agy
  "$PNPM_HOME"
  "$BUN_INSTALL/bin"
  /opt/homebrew/opt/sqlite/bin
  $path
)
export PATH

# ---------- OrbStack ----------
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Installer hay tự ghi thêm dòng vào cuối file này.
# Vì file là symlink vào repo -> kiểm tra `git diff` rồi dời vào đúng section.
