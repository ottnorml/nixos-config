{
  nix-auth,
  nixpkgs-master,
  pkgs,
}:

let
  shared-packages = import ../shared/packages.nix { inherit nix-auth nixpkgs-master pkgs; };
in
shared-packages
++ [
]
