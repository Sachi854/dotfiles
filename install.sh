#!/usr/bin/env bash

set -ue

function print_default() {
  echo -e "$*"
}

#--------------------------------------------------------------#
##          main                                              ##
#--------------------------------------------------------------#

function main() {
  # 作業dirを取る
  local current_dir
  current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")
  # functionの呼び出し
  local is_all="false"
  local is_dot="false"
  local is_package="false"

  while [ $# -gt 0 ]; do
    case ${1} in
      --all)
        is_dot="true"
        is_package="true"
        ;;
      --dot)
        is_dot="true"
        ;;
      --package)
        is_package="true"
        ;;
      *)
        echo "[ERROR] Invalid arguments '${1}'"
        usage
        exit 1
        ;;
    esac
    shift
  done

  # scripts へパス通す
  local p="$PATH"
  local h="$HOME"
  local re=".*$h/scripts.*"
  if ! [[ $p =~ $re ]]; then
      command echo 'export PATH="$HOME/scripts:$PATH"' >> $HOME/.bash_profile
  fi

  if [[ "$is_package" = true ]]; then
    source $current_dir/.scripts/install_code.sh
    source $current_dir/.scripts/install_xremap.sh
  fi

  if [[ "$is_dot" = true ]]; then
    source $current_dir/.scripts/install_dots.sh
  fi

  source $current_dir/.scripts/show_deamons.sh
  print_default "finished $(basename "${BASH_SOURCE[0]:-$0}") !!"
}

main "$@"
