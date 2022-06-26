#!/usr/bin/env bash

set -ue

#--------------------------------------------------------------#
##          main                                              ##
#--------------------------------------------------------------#

function main() {
	local current_dir
	current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")
	local dotfiles_dir
	dotfiles_dir="$(builtin cd "$current_dir" && git rev-parse --show-toplevel)"

    command systemctl --user daemon-reload

	if [[ "$HOME" != "$dotfiles_dir" ]]; then
		for f in "$dotfiles_dir"/.config/systemd/user/?*.service; do
			local f_filename
			f_filename=$(basename "$f")
			command systemctl --user start "$f_filename"
			command systemctl --user enable "$f_filename"
		done
	fi
}

main "$@"
