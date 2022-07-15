#!/usr/bin/env bash

set -ue

#--------------------------------------------------------------#
##          main                                              ##
#--------------------------------------------------------------#

function main() {
    # add code repo
    local v=$(command dnf repolist | grep 'Visual Studio Code')
    if ! [[ -n "$v" ]]; then
        command sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        command sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        command dnf check-update
    fi
    # install code
    command sudo dnf install -y code
}

main "$@"

