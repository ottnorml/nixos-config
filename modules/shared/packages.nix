{
  nix-auth,
  nixpkgs-master,
  pkgs,
}:

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
  fd
  ffmpeg
  font-awesome
  hack-font
  # FIXME(nixpkgs#535868): Use the master-side font packages while
  # nixpkgs-unstable still builds their AFDKO-based font-tool chain with the
  # failing configuration. Remove these overrides once the fix from
  # NixOS/nixpkgs#535882 reaches the pinned nixpkgs-unstable revision.
  #
  # Issue: https://github.com/NixOS/nixpkgs/issues/535868
  # Fix:   https://github.com/NixOS/nixpkgs/pull/535882
  nixpkgs-master.jetbrains-mono
  meslo-lgs-nf
  nerd-fonts.jetbrains-mono
  noto-fonts
  # Kept alongside JetBrains Mono because both packages independently pull the
  # affected font-tool dependency closure.
  nixpkgs-master.noto-fonts-color-emoji

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
  nixpkgs-master.semgrep
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
