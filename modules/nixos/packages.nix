{ nixpkgs-master, pkgs, ... }:

with pkgs;
let
  sharedPackages = pkgs.callPackage ../shared/packages.nix { inherit nixpkgs-master pkgs; };
in
sharedPackages ++ [

  # Security and authentication
  ausweisapp
  eduvpn-client
  keepassxc
  yubikey-agent

  # App and package management
  appimage-run
  cmake
  gnumake
  home-manager

  # Media and design tools
  fontconfig

  # Productivity tools

  # Audio tools
  pavucontrol # Pulse audio controls

  # AI tools
  ast-grep

  # Testing and development tools
  libtool # for Emacs vterm
  pnpm
  rofi
  rofi-calc

  # Cloud-related tools and SDKs
  gitlab-ci-local
  glab
  golangci-lint
  helm
  helmfile
  k3d
  kubebuilder
  kubectl
  mise
  opentofu
  operator-sdk
  skaffold
  terraform
  trivy

  # Screenshot and recording tools
  flameshot

  # Text and terminal utilities
  carapace
  htop
  tree
  unixtools.ifconfig
  unixtools.netstat
  vivid
  xclip # For the org-download package in Emacs
  xrandr
  xwininfo # Provides a cursor to click and learn about windows
  zoxide

  # File and system utilities
  inotify-tools # inotifywait, inotifywatch - For file system events
  libnotify
  pcmanfm # File browser
  sqlite
  xdg-utils

  # Other utilities
  google-chrome

  # PDF viewer
  zathura

  # Development tools
  firefox

  # Music and entertainment
]
