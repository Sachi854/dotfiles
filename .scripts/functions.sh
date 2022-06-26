#--------------------------------------------------------------#
##          util                                              ##
#--------------------------------------------------------------#

function print_default() {
  echo -e "$*"
}

function print_info() {
  echo -e "\e[1;36m$*\e[m" # cyan
}

function print_notice() {
  echo -e "\e[1;35m$*\e[m" # magenta
}

function print_success() {
  echo -e "\e[1;32m$*\e[m" # green
}

function print_warning() {
  echo -e "\e[1;33m$*\e[m" # yellow
}

function print_error() {
  echo -e "\e[1;31m$*\e[m" # red
}

function whichdistro() {
  if [ -f /etc/debian_version ]; then
    echo debian
    return
  elif [ -f /etc/fedora-release ]; then
    echo fedora
    return
  elif [ -f /etc/redhat-release ]; then
    echo redhat
    return
  elif [ -f /etc/arch-release ]; then
    echo arch
    return
  elif [ -f /etc/alpine-release ]; then
    echo alpine
    return
  fi
}

function yes_or_no_select() {
  local answer
  print_default "[yes/no]"
  read -r answer
  case $answer in
  yes | y)
    return 0
    ;;
  no | n)
    return 1
    ;;
  *)
    yes_or_no_select
    ;;
  esac
}

function mkdir_not_exist() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
  fi
}
