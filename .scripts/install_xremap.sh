#!/usr/bin/env bash

set -ue

#--------------------------------------------------------------#
##          main                                              ##
#--------------------------------------------------------------#

function main() {
    local p="$PATH"
    local h="$HOME"
    local re=".*$h/\.cargo/bin.*"
    local current_dir
    current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")

    if ! [[ -s "$HOME/bin/xremap" ]]; then
      # install cargo
      command sudo dnf install -y cargo
      # set PATH
      if ! [[ $p =~ $re ]]; then
          command echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> $HOME/.bash_profile
      fi
      # install xremap
      command cargo install xremap --features gnome
      command sudo gpasswd -a "$USER" input
      command echo 'KERNEL=="uinput", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules
      "$current_dir"/install-gnome-extensions.sh --enable 5060
    fi
}

main "$@"