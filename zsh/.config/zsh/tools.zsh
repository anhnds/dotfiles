# Khởi tạo tool cho shell tương tác (completion, keybind, hook).

# fzf: Ctrl-T, Ctrl-R, Alt-C
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

# bun completion
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# autojump (j <dir>)
[ -f "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh" ] && . "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh"

# Ctrl-x Ctrl-e: sửa dòng lệnh bằng nvim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line
bindkey -M vicmd '^x^e' edit-command-line
