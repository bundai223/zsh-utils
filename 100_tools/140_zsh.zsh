# zsh

filename()
{
  # equal basename
  echo ${${1}##*/}
}

parentpath()
{
  # equal dirname
  echo ${${1}%/*}
}

ext()
{
  echo ${${1}##*.}
}

filename_wo_ext()
{
  echo ${${1}%.*}
}
