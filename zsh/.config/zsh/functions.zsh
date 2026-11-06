# Functions (thay cho alias phức tạp, khỏi phải escape)

_fzf_preview='bat --style=numbers --color=always --line-range :50 {}'

# ff: chọn file trong thư mục hiện tại rồi mở bằng nvim
ff() {
  local f
  f=$(fd --type f --hidden --exclude .git . | fzf --preview "$_fzf_preview") && nvim "$f"
}

# to: chọn thư mục con rồi cd vào
to() {
  local d
  d=$(fd --type d --hidden --exclude .git . | fzf) && cd "$d"
}

# gff / gto: như trên nhưng tìm trong toàn bộ $HOME
gff() {
  local f
  f=$(fd --type f --hidden --exclude .git . ~ | fzf --preview "$_fzf_preview") && nvim "$f"
}

gto() {
  local d
  d=$(fd --type d --hidden --exclude .git . ~ | fzf) && cd "$d"
}

# brew: sau khi cài/gỡ gói, tự cập nhật Brewfile trong dotfiles.
# Không tự commit: xem `git diff Brewfile` rồi commit `brew: ...`.
# Gói npm global (npm install -g) thì vẫn phải tự chạy: brew bundle dump --force
brew() {
  command brew "$@" || return
  case "$1" in
    install|uninstall|remove|rm|reinstall|tap|untap)
      command brew bundle dump --force --file="$HOME/workspace/dotfiles/Brewfile" &&
        echo "→ Đã cập nhật Brewfile (dotfiles: git diff Brewfile)" ;;
  esac
}
