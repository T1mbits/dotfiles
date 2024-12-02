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
    echo "This script assumes that the config is a flake. Using $0 push will trigger two interactive git"
    echo "sessions, one for squashing commits (may remove in favor of automatically squashing) and one for"
    echo "the commit message and description."
    echo
    echo "COMMAND:"
    echo "  home <cfg_name>     Rebuild the specified home-manager configuration"
    echo "  nixos <cfg_name>    Rebuild the specified NixOS system configuration"
    echo "  push <msg>          Squash all unpushed changes and push with the given message"
    echo
    echo "EXAMPLES:"
    echo "  $0 home Timbits"
    echo "  $0 push 'Added tmux'"
    exit 1
}

check_diff() {
    git diff -U0 -- *.nix -- $1
    if [[ -z $? ]]; then
        echo "No changes detected, exiting."
        exit 0
    fi
}

global_directories="./themes ./pkgs"

nix_switch() {
    nixos_directories="$global_directories ./host"

    check_diff "$nixos_directories ./flake.nix"

    echo "Adding changes"
    git add $nixos_directories ./flake.*

    echo "Rebuilding NixOS system configuration..."
    sudo nixos-rebuild switch --flake .#"$1" &> "nixos-rebuild.log" || { grep --color=always error "nixos-rebuild.log" && exit 1; }
    git add ./flake.lock # just in case inputs were changed

    git commit -m "nixos-rebuild $(nixos-rebuild list-generations | grep current | cut -c13-28)"

    echo "Successfully rebuilt and switched NixOS configuration."
}

home_switch() {
    home_directories="${global_directories} ./home ./ags"

    check_diff $home_directories

    echo "Adding changes"
    git add $home_directories

    echo "Rebuilding home-manager configuration..."
    home-manager switch --flake .#"$1" &> "home-manager.log" || { grep --color=always error "home-manager.log" && exit 1; }

    git commit -m "home-manager $(home-manager generations | head -n 1 | cut -c-16)"

    echo "Successfully rebuilt and switched home-manager configuration."
}

flake_update() {
    echo "Updating flake..."
    sudo nix flake update
}

push() {
    if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --other --exclude-standard)" ]; then
      echo "warning: Git tree $(pwd) is dirty"
    fi

    current_branch=$(git rev-parse --abbrev-ref HEAD)

    if [[ -z $(git log origin/$current_branch..HEAD --oneline) ]]; then
        echo "No unpushed commits found. Exiting."
        exit 0
    fi

    git stash --keep-index -u

    echo "Initiating interactive rebase..."
    git rebase -i origin/$current_branch

    echo "Add commit message and description..."
    git commit --amend --no-edit

    echo "Pushing squashed commit..."
    git push

    git stash pop

    echo "Successfully pushed squashed commit with the following message: "$1"."
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
    *)
        echo "Invalid command: $1"
        echo
        usage
        ;;
esac

exit 0