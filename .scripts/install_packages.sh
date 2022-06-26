#!/usr/bin/env bash

set -ue

#--------------------------------------------------------------#
##          main                                              ##
#--------------------------------------------------------------#
function main() {
    # upgrade
    command sudo dnf upgrade -y
    # install 
    ## code
    command sudo dnf install -y code 
    ## cargo
    command sudo dnf install -y cargo 
    ## vim
    command sudo dnf install -y vim 
    ## curl wget jq unzip
    command sudo dnf install -y curl wget jq unzip
    ## ibus-mozc
    command sudo dnf install -y ibus-mozc 
}

main "$@"