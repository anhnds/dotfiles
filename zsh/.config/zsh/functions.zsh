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
