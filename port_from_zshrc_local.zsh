refresh_memory()
{
    du -sx / &> /dev/null & sleep 25 && kill $!
}

peco_work() {
    target=`find ~/work -maxdepth 2 -mindepth 1 -type d | peco`
    echo $target
    cd $target
}

install_font() {
    cp $1 ~/Library/Fonts/
}

# 
# guiのvimを開く関数
# ウインドウは一つしか開かない設定で起動
# - or +で始まる引数をもっていたら引数任せ
# 
mvim() {
    if [[ -z $1 || $1 =~ "^[-+]" ]]; then
        /Applications/MacVim.app/Contents/MacOS/mvim $*
    else
        /Applications/MacVim.app/Contents/MacOS/mvim --remote-tab-silent $*
    fi
}

genymotion_peco() {
    if [ -z "$GENYMOTION_APP_HOME" ]
    then
        echo "GENYMOTION_APP_HOME is empty. Use '/Applications/Genymotion.app/' instead this time."
        player="/Applications/Genymotion.app/Contents/MacOS/player" 
    else
        player="$GENYMOTION_APP_HOME/Contents/MacOS/player" 
    fi
    vm_name=`VBoxManage list vms | peco` 
    if [[ $vm_name =~ ^\"(.+)\".* ]]
    then
        name=${match[1]} 
        echo "boot $name"
        $player --vm-name "$name" &
    fi
}

show_allfile_on_finder() {
    flag="$1"
    if [ "on" = $flag ]; then
        echo "Enable show all files on finder."
        defaults write com.apple.finder AppleShowAllFiles -boolean true
        killall Finder
    elif [ "off" = $flag ]; then
        echo "Reset show all files on finder."
        defaults delete com.apple.finder AppleShowAllFiles
        killall Finder
    else
        echo "usage:"
        echo "    show_allfile_on_finder [on|off]"
    fi
}

alias compile_plantuml="java -jar ~/local/bin/plantuml.jar  -charset UTF-8 -tsvg -nbthread auto $<"
