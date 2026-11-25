set positional-arguments

system := ".#wsl"

# List available recipes.
default:
    @just --list

# Show flake inputs and their locked revisions.
metadata:
    nix flake metadata .

# Check the flake and its NixOS configuration.
check:
    nix flake check .

# Build the WSL system and link it at ./result.
build:
    nixos-rebuild build --flake '{{ system }}'

# Activate the WSL configuration for the current boot.
test:
    nixos-rebuild test --flake '{{ system }}' --elevate sudo

# Activate the WSL configuration and make it the default.
switch:
    nixos-rebuild switch --flake '{{ system }}' --elevate sudo

# Update all flake inputs, or pass names such as nixpkgs.
update *inputs:
    nix flake update --flake . -- "$@"

# Delete all old profile generations system-wide and collect unused store paths.
gc-all:
    sudo nix-collect-garbage -d

# Collect unreferenced store paths and keep profile generations.
gc:
    sudo nix-collect-garbage

# Prune old profile generations system-wide, then collect unused store paths.
gc-older-than age="30d":
    sudo nix-collect-garbage --delete-older-than "$1"
