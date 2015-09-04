# tmux


# tmux起動
tmux_start()
{
  session=$1
  if [ -z "$TMUX" -a -z "$STY" ]; then
    if type tmuxx >/dev/null 2>&1; then
      tmuxx
    elif type tmux >/dev/null 2>&1; then
      if tmux has-session && tmux list-sessions | /usr/bin/grep -qE '.*]$'; then
        tmux attach && echo "tmux attached session "
      else
        msg="tmux created new session"
        if [ -z "$session" ]; then
          tmux new-session && echo $msg
        else
          tmux new-session -s $session && echo $msg
        fi
      fi
    elif type screen >/dev/null 2>&1; then
      screen -rx || screen -D -RR
    fi
  fi
}

tmux_multissh()
{
  session=multi-ssh-`date +%s`
  window=multi-ssh

  tmux_start $session
  tmux rename-window $window

  ### 各ホストにsshログイン
  # 最初の1台はsshするだけ
  tmux send-keys "ssh $1" C-m
  shift

  pane_num=$#
  layout=tiled
  if [ $pane_num -lt 6 ]; then
    layout=even-vertical
  fi
  # 残りはpaneを作成してからssh
  for i in $*;do
    tmux split-window
    tmux send-keys "ssh $i" C-m
  done
  tmux select-layout $layout

  ### 最初のpaneを選択状態にする
  tmux select-pane -t 0

  ### paneの同期モードを設定
  tmux set-window-option synchronize-panes on

  ### セッションにアタッチ
  tmux attach-session -t $session
}

