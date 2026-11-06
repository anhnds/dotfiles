# ~/.zshenv  (symlink -> dotfiles/zsh/.zshenv)
# Chạy với MỌI zsh: terminal, `ssh host cmd`, script, tool gọi `zsh -c`.
# Giữ thật nhẹ: chỉ nạp secret từ cache (tạo bởi `secrets-env refresh`, không gọi op ở đây).
_secrets="${XDG_STATE_HOME:-$HOME/.local/state}/secrets/env.sh"
if [ -r "$_secrets" ]; then . "$_secrets"; fi
unset _secrets
