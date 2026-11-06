# ~/.zshrc  (symlink -> dotfiles/zsh/.zshrc)
# Interactive shell: oh-my-zsh, alias, function, keybind, plugin.
# Biến môi trường + PATH nằm ở ~/.zprofile.

typeset -U path PATH

# ---------- oh-my-zsh ----------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
DISABLE_AUTO_TITLE="true"
plugins=(git vi-mode)
source $ZSH/oh-my-zsh.sh

# ---------- Modules: ~/.config/zsh/*.zsh ----------
# tools.zsh, aliases.zsh, functions.zsh, local.zsh (gitignored, secrets/máy riêng)
for f in ~/.config/zsh/*.zsh(N); do source "$f"; done
unset f

# ---------- Plugins (phải ở cuối file) ----------
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
