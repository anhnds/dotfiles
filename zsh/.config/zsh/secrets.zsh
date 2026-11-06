# Tự sync secret từ 1Password khi mở terminal, nếu lần sync gần nhất đã quá 12 giờ.
# Chạy `secrets-env refresh` ở nền: tab đang mở không bị chậm, và Touch ID chỉ hỏi lúc bạn đang ngồi máy.
# Tab mở SAU khi sync xong mới nhận biến mới (hoặc chạy `exec zsh`).
#
# Tắt:          export SECRETS_ENV_AUTO=0   (trong ~/.config/zsh/local.zsh)
# Đổi chu kỳ:   export SECRETS_ENV_MAX_AGE_H=24
# Log:          ~/.local/state/secrets/auto-sync.log

() {
  [[ ${SECRETS_ENV_AUTO:-1} == 0 ]] && return
  [[ -o interactive && -t 1 ]] || return          # chỉ terminal thật (bỏ qua script, snapshot của tool)
  [[ -n $SSH_CONNECTION ]] && return              # SSH: không ai bấm Touch ID
  (( $+commands[secrets-env] && $+commands[op] )) || return

  local state=${XDG_STATE_HOME:-$HOME/.local/state}/secrets
  local stamp=$state/last-sync hours=${SECRETS_ENV_MAX_AGE_H:-12}
  local log=$state/auto-sync.log failed=$state/auto-sync.failed

  # Lần trước thất bại (huỷ Touch ID, mất mạng...): báo 1 dòng, không tự hỏi lại cho tới chu kỳ sau
  [[ -e $failed ]] && print -P "%F{yellow}secrets-env: lần tự sync trước bị lỗi, chạy tay: secrets-env refresh (log: $log)%f"

  # Mốc thời gian còn mới (chưa quá N giờ) -> bỏ qua. Glob (N.mh+N): file sửa cách đây hơn N giờ
  local -a old lock_old
  old=( $stamp(N.mh+$hours) )
  [[ -e $stamp && ${#old} == 0 ]] && return

  # Khoá để nhiều tab mở cùng lúc chỉ chạy 1 lần (mkdir là thao tác nguyên tử).
  # Khoá quá 10 phút coi như bị kẹt (process bị kill) -> gỡ.
  local lock=$state/.auto-sync.lock
  lock_old=( $lock(N/mm+10) )
  (( ${#lock_old} )) && rmdir $lock 2>/dev/null
  mkdir -p $state && mkdir $lock 2>/dev/null || return
  touch $stamp
  {
    {
      print "== $(date '+%F %T') auto sync"
      if secrets-env refresh; then rm -f $failed; else touch $failed; fi
    } >>$log 2>&1
    rmdir $lock
  } &!
}
