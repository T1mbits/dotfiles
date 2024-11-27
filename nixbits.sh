#!/usr/bin/env bash

pushd() {
    command pushd "$@" > /dev/null
}

popd() {
    command popd "$@" > /dev/null
}

# Exit on error
set -e

# Set cwd to dotfiles
pushd ~/dotfiles

# Helper functions to display usage instructions
usage() {
    echo "Usage: $0 <COMMAND>"
    echo
    echo "COMMAND:"
    echo "  home <cfg_name>     Rebuild the specified home-manager configuration"
    echo "  nixos <cfg_name>    Rebuild the specified NixOS system configuration"
    echo "  push <msg>          Squash all unpushed changes and push with the given message"
    echo
    echo "EXAMPLES:"
    echo "  $0 home Timbits"
    echo "  $0 push 'Added tmux'"
    popd
    exit 1
}

check_diff() {
    git diff -U0 -- *.nix -- $1
    if [[ -z $? ]]; then
        echo "No changes detected, exiting."
        popd
        exit 0
    fi
}

nix_switch() {
    check_diff "./host ./themes ./flake.nix"
    echo "Rebuilding NixOS system configuration..."

    sudo nixos-rebuild switch --flake .#"$1" &> "nixos-rebuild.log" || { grep --color=always error "nixos-rebuild.log" && exit 1; }

    git add ./host ./themes ./flake.*
    git commit -m "nixos-rebuild $(nixos-rebuild list-generations | grep current | cut -c13-28)"

    echo "Successfully rebuilt and switched NixOS configuration."
}

home_switch() {
    check_diff "./home ./users ./themes ./flake.nix"
    echo "Rebuilding home-manager configuration..."

    home-manager switch --flake .#"$1" &> "home-manager.log" || { grep --color=always error "home-manager.log" && exit 1; }

    git add ./home ./users ./themes ./flake.*
    git commit -m "home-manager $(home-manager generations | head -n 1 | cut -c-16)"

    echo "Successfully rebuilt and switched home-manager configuration."
}

push() {
    if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --other --exclude-standard)" ]; then
      echo "warning: Git tree $(pwd) is dirty"
    fi

    current_branch=$(git rev-parse --abbrev-ref HEAD)

    if [[ -z $(git log origin/$current_branch..HEAD --oneline) ]]; then
        echo "No unpushed commits found. Exiting."
        popd
        exit 0
    fi

    echo "Initiating interactive rebase..."
    git rebase -i origin/$current_branch
    git commit --amend --no-edit -m "$1"

    echo "Pushing squashed commit..."
    git push

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
            popd
            exit 1
        fi
        nix_switch "$2"
        ;;
    home)
        if [ -z "$2" ]; then
            echo "Error: You must provide a flake target"
            popd
            exit 1
        fi
        home_switch "$2"
        ;;
    push)
        if [ -z "$2" ]; then
            echo "Error: You must provide a commit message"
            popd
            exit 1
        fi
        push "$2"
        ;;
    *)
        echo "Invalid command: $1"
        echo
        usage
        ;;
esac

popd