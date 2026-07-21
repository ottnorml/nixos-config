{
  nix-auth,
  nix-search-cli,
  nixpkgs-master,
  pkgs,
}:

let
  shared-packages = import ../shared/packages.nix {
    inherit nix-auth nix-search-cli nixpkgs-master pkgs;
  };
in
shared-packages
++ [
  pkgs.ghostty-bin.terminfo
]
