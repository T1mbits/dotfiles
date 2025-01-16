#!/usr/bin/env bash

exit() {
    git reset > /dev/null
    popd > /dev/null
    command exit "$1"
}

# Exit on error
set -e

# Set cwd to dotfiles
pushd ~/dotfiles > /dev/null

# Helper functions to display usage instructions
usage() {
    echo "Usage: $0 <COMMAND>"
    echo
    echo "A useful little script that helps simplify and automate Timbits' Nix configuration related tasks."
    echo "This script assumes that the config is a flake. Using $0 push will trigger an interactive git session."
    echo
    echo "COMMAND:"
    echo "  home <cfg_name>		    Rebuild the specified home-manager configuration"
    echo "  nixos <cfg_name>		Rebuild the specified NixOS system configuration"
    echo "  full <n_name> <c_name>	First rebuild the NixOS configuration, followed by the home-manager configuration"
    echo "  push <msg>			    Squash all unpushed changes and push with the given message"
    echo
    echo "EXAMPLES:"
    echo "  $0 home Timbits"
    echo "  $0 full framework Timbits'"
    exit 1
}

check_diff() {
    git diff -U0 $*
    if [[ -z $? ]]; then
        echo "No changes detected, exiting."
        exit 0
    fi
}

global_directories="./derivations ./host ./home ./lib ./modules ./secrets ./themes ./flake.*"

nix_switch() {
    check_diff $global_directories

    echo "Adding changes"
    git add $global_directories

    echo "Rebuilding NixOS system configuration..."
    sudo nixos-rebuild switch --flake .#"$1" &> "nixos-rebuild.log" || { grep --color=always error "nixos-rebuild.log" && exit 1; }

    git commit -m "nixos-rebuild $(nixos-rebuild list-generations | grep current | cut -c13-28)"

    echo "Successfully rebuilt and switched NixOS configuration."
}

home_switch() {
    check_diff $global_directories

    echo "Adding changes"
    git add $global_directories

    echo "Rebuilding home-manager configuration..."
    home-manager switch --flake .#"$1" &> "home-manager.log" || { grep --color=always error "home-manager.log" && exit 1; }

    git commit -m "home-manager $(home-manager generations | head -n 1 | cut -c-16)"

    echo "Successfully rebuilt and switched home-manager configuration."
}

push() {
    if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --other --exclude-standard)" ]; then
      echo "error: Git tree $(pwd) is dirty"
      exit 1
    fi

    current_branch=$(git rev-parse --abbrev-ref HEAD)

    if [[ -z $(git log origin/$current_branch..HEAD --oneline) ]]; then
        echo "No unpushed commits found. Exiting."
        exit 0
    fi

    echo "Initiating interactive rebase..."
    git rebase -i origin/$current_branch

    echo "Pushing squashed commit(s)..."
    git push

    echo "Successfully pushed squashed commit."
}

# Check for valid parameters
if [ "$#" -lt 1 ]; then
    usage
fi

case "$1" in
    nixos)
        if [ -z "$2" ]; then
            echo "Error: You must provide a flake target"
            exit 1
        fi
        nix_switch "$2"
        ;;
    home)
        if [ -z "$2" ]; then
            echo "Error: You must provide a flake target"
            exit 1
        fi
        home_switch "$2"
        ;;
    push)
        push
        ;;
    full)
	if [ -z "$2" ] || [ -z "$3" ]; then
	    echo "Error: You must provide two flake targets"
	    exit
	fi
	nix_switch "$2"
	home_switch "$3"
	;;
    *)
        echo "Invalid command: $1"
        echo
        usage
        ;;
esac

exit 0
