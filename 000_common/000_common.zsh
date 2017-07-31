
# 数値の合計
sum() {
  if [ -p /dev/stdin ]; then
    args=$(cat -)
  else
    args=$*
  fi

  _num=0
  for i in $args; do
    _num=$((_num+$i))
  done
  echo $_num
}


ls_sshhost() {
    awk '
        tolower($1)=="host" {
            for (i=2; i<=NF; i++) {
                if ($i !~ "[*?]") {
                    print $i
                }
            }
        }
    ' ~/.ssh/config | sort
}

listup_ip() {
    LANG=C ifconfig | grep 'inet ' | awk '{print $2;}' | cut -d: -f2
    #LANG=C ifconfig | grep 'inet addr' | awk '{print $2;}' | cut -d: -f2
}

os_version() {
    VERSION_FILE_ARRAY=(\
        '/etc/redhat-release' \
        '/etc/fedora-release' \
        '/etc/debian_version' \
        '/etc/turbolinux-release' \
        '/etc/SuSE-release' \
        '/etc/mandriva-release' \
        '/etc/vine-release' \
        '/etc/issue' \
    )

    if [ 'Darwin' = $(uname) ]; then
        sw_vers
    else
        for file in $VERSION_FILE_ARRAY; do
            if [ -e $file ]; then
                cat $file; break
            fi
        done
    fi
}

# tmux上でsshした際に対象のホスト名に応じてpaneの色を変える
ssh() {
  # tmux起動時
  if [[ -n $(printenv TMUX) ]] ; then
    # 接続先ホスト名に応じて背景色を切り替え
    if [[ `echo $1 | grep '\.production\.'` ]] ; then
      tmux select-pane -P 'bg=blue'
    elif [[ `echo $1 | grep '\.dev\.'` ]] ; then
      tmux select-pane -P 'bg=red'
    fi
    # 通常通りssh続行
    command ssh $@
    # デフォルトの背景色に戻す
    tmux select-pane -P 'default'

  else
    command ssh $@
  fi
}
