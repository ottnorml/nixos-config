{ pkgs }:

with pkgs; [
  # General packages for development and system management
  alacritty
  bash-completion
  bat
  btop
  coreutils
  killall
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
  jetbrains-mono
  meslo-lgs-nf
  noto-fonts
  noto-fonts-color-emoji

  # Node.js development tools
  nodejs_24

  # Text and terminal utilities
  jq
  ripgrep
  tmux
  tree
  unrar
  unzip
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
