# tmux 自動起動 {{{
tmux_autostart()
{
    if [ -z "$TMUX" -a -z "$STY" ]; then
        if type tmuxx >/dev/null 2>&1; then
            tmuxx
        elif type tmux >/dev/null 2>&1; then
            if tmux has-session && tmux list-sessions | /usr/bin/grep -qE '.*]$'; then
                tmux attach && echo "tmux attached session "
            else
                tmux new-session && echo "tmux created new session"
            fi
        elif type screen >/dev/null 2>&1; then
            screen -rx || screen -D -RR
        fi
    fi
}
#}}}

# Generate .gitignore
gen_gitignore() {
    curl https://www.gitignore.io/api/$@
}

# Remove non tracked file.(like tortoiseSVN)
git_rm_untrackedfile()
{
    git status --short|grep '^??'|sed 's/^...//'|xargs rm -r
#    pathlist=(`git status --short|grep '^??'|sed 's/^...//'`)
#    for rmpath in ${pathlist}; do
#        if [ $rmpath != "" ]; then
#          rm ./$rmpath
#        fi
#    done
}

git_stash_revert()
{
    git stash show ${@} -p
    #git stash show ${@} -p | git apply -R
}

# create .local.vimrc
local_vimrc_create()
{
    if [[ "" == ${1} ]]; then
        echo "usage : local_vimrc_create /path/to/target"
        return
    fi

    echo "Create local vimrc file."
    if [ -d ${1} ]; then
        dirpath=`cd ${1}&&pwd`
        filename=".local.vimrc"
        filepath="${dirpath}/${filename}"

        if [ -f ${filepath} ]; then
            echo "*Error* Already exist file. : ${filepath}"
        else
            echo "\" .local.vimrc">${filepath}
            echo "let \$PROJECT_ROOT=expand(\"${dirpath}\")">>${filepath}
            echo "lcd \$PROJECT_ROOT">>${filepath}

            echo "Done. : ${filepath}"
        fi
    else
        echo "*Error* Not find directory. : ${1}"
    fi
}

# cd git repository
cd_repos() {
    cd $(ghq list -p | peco)
}

peco_find_ext() {
    find . -name '*.'$1 | peco
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

peco_ssh() {
    ssh $(ls_sshhost | peco)
}

peco_gitmodified() {
    git status --short | peco | sed s/"^..."//
}

git_pullall() {
    if [ $# -eq 0 ]; then
        echo "usage"
        echo " git_pullall [username]"
        return 1
    fi

    username=$1
    CURDIR=`pwd`
    ERROR_LIST=()
    for repo in $(ghq list -p | grep $username); do
        cd $repo
        hostname=$(basename $(cd ../..;pwd))
        reposname=$(basename $(pwd))
        echo "==== $hostname:$username/$reposname ===="
        git pull --rebase
        if [ $? -ne 0 ]; then
            ERROR_LIST=(${ERROR_LIST[@]} $hostname:$username/$reposname)
        fi
    done

    echo
    echo "==== error repositories ===="
    for error_repo in $ERROR_LIST; do
        echo $error_repo
    done
    cd $CURDIR
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

py_help() {
    target=$1
    python -c "import ${target}; help(${target})"
}

py3_help() {
    target=$1
    python3 -c "import ${target}; help(${target})"
}

# Displayの製造元を表示
# LP : LG製（はずれ）
# LSN : Samsung製（当たり）
display_info_15inch()
{
    ioreg -lw0 | grep \"EDID\" | sed "/[^<]*</s///" | xxd -p -r | strings -6
}


