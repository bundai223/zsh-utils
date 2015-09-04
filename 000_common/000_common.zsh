
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
                cat $file; exit
            fi
        done
    fi
}

# Displayの製造元を表示
# LP : LG製（はずれ）
# LSN : Samsung製（当たり）
display_info_15inch()
{
    ioreg -lw0 | grep \"EDID\" | sed "/[^<]*</s///" | xxd -p -r | strings -6
}


