{
  nix-auth,
  nixpkgs-master,
  pkgs,
}:

let
  # Semgrep 1.180.0 requires the MCP Python SDK 1.x API (FastMCP).
  # Reuse the MCP 1.29.0 package definition from this pinned nixpkgs revision,
  # but build it with the current Python package set.
  mcp1 = nixpkgs-master.python3Packages.callPackage (
    (builtins.getFlake "github:NixOS/nixpkgs/8825bebf6324e0579d012936eff73379af284b6d").outPath
    + "/pkgs/development/python-modules/mcp/default.nix"
  ) { };
in
with pkgs;
[
  # General packages for development and system management
  alacritty
  bash-completion
  bat
  btop
  coreutils
  dig
  devenv
  doggo
  killall
  nix-auth
  nix-search-cli
  openssh
  sqlite
  wget
  zip

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2

  # Cloud-related tools and SDKs
  docker
  docker-compose

  # Media-related packages
  dejavu_fonts
  emacs-all-the-icons-fonts
  exiftool
  fd
  ffmpeg
  font-awesome
  hack-font
  jetbrains-mono
  meslo-lgs-nf
  nerd-fonts.jetbrains-mono
  noto-fonts
  noto-fonts-color-emoji

  # Node.js development tools
  nodejs_24

  # Text and terminal utilities
  bat-extras.core
  delta
  go-jsonnet
  ijq
  jq
  ripgrep
  tmux
  tree
  unrar
  unzip
  yq
  zsh-powerlevel10k

  # Development tools
  # awscli2
  curl
  devbox
  direnv
  fzf
  gh
  kubectl
  lazygit
  (
    (nixpkgs-master.semgrep.override {
      mcp = mcp1;
    }).overridePythonAttrs
      (old: {
        # Keep the PyJWT metadata relaxation, but enforce the MCP 1.x constraint.
        pythonRelaxDeps = builtins.filter (dep: dep != "mcp") (old.pythonRelaxDeps or [ ]) ++ [ "pyjwt" ];
      })
  )
  shellcheck
  terraform

  # AI tools
  zat

  # Programming languages and runtimes
  cargo
  go
  openjdk
  rustc

  # Python packages
  python3
  virtualenv
]
