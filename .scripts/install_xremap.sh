#!/usr/bin/env bash

set -ue

#--------------------------------------------------------------#
##          main                                              ##
#--------------------------------------------------------------#

function main() {
    local current_dir
    current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")
    command cargo install xremap --features gnome
    command sudo gpasswd -a $USER input
    command echo 'KERNEL=="uinput", GROUP="input"' | sudo tee /etc/udev/rules.d/input.rules
    $current_dir/install-gnome-extensions.sh --enable 5060
}

main "$@"
