# how to use
1) install nix preferably with git, and give a hostname that is unique within the hostname entries in flake.nix
2) after install switch to unstable by using:
``sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos``
``sudo nixos-rebuild switch --upgrade``
3) chown the /etc/nixos dir for convienence, also we need to clone this repo to that folder
4) rename hardware-configuration.nix to hostname.nix
5) add an import for configuration.nix from hostname.nix
6) add entry to flake.nix for hostname.nix
7) sudo nixos-rebuild switch
8) nix flake update (or before?)
