ghq_path()
{
  repo=${1}
  root_path=$(ghq root ${repo})
  sub_path=$(ghq list ${repo})
  echo ${root_path}/${sub_path}
}
