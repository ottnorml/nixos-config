{ nixpkgs-master, pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit nixpkgs-master pkgs; };
in
shared-packages
++ [
]
