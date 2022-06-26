#!/usr/bin/env bash

set -ue

#--------------------------------------------------------------#
##          main                                              ##
#--------------------------------------------------------------#

function main() {
  # 作業dirを取る
  local current_dir
  current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")
  # functionの呼び出し
  source $current_dir/.scripts/functions.sh

  local is_all="false"
  local is_dot="false"
  local is_package="false"
  local is_script="false"
  local is_deamon="false"

  while [ $# -gt 0 ]; do
    case ${1} in
      --all)
        is_all="true"
        is_dot="true"
        is_dot="true"
        is_package="true"
        is_script="true"
        is_deamon="true"
        ;;
      --dot)
        is_dot="true"
        ;;
      --package)
        is_package="true"
        ;;
      --deamon)
        is_deamon="true"
        ;;
      *)
        echo "[ERROR] Invalid arguments '${1}'"
        usage
        exit 1
        ;;
    esac
    shift
  done

  if [[ "$is_all" = true ]]; then
    command sudo rpm --rebuilddb
    # add vscode key and repository
    command sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    command sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    command dnf check-update
    # add PATH
    ## cargo
    command echo 'export PATH="$HOME/.cargo/bin:PATH"' >> $HOME/.bash_profile
    ## scripts
    command echo 'export PATH="$HOME/scripts:PATH"' >> $HOME/.bash_profile
  fi

  if [[ "$is_package" = true ]]; then
    source $current_dir/.scripts/install_packages.sh
    source $current_dir/.scripts/install_xremap.sh
  fi

  if [[ "$is_dot" = true ]]; then
    source $current_dir/.scripts/install_dots.sh
  fi

  if [[ "$is_deamon" = true ]]; then
    source $current_dir/.scripts/enable_deamons.sh
  fi
  
  print_default "finished $(basename "${BASH_SOURCE[0]:-$0}") !!"
  print_default "reboot now?"
  yes_or_no_select
  if [[ $? ]]; then
      command sudo reboot
  fi
}

main "$@"
