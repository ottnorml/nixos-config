{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # Security and authentication
  ausweisapp
  eduvpn-client
  keepassxc
  yubikey-agent

  # App and package management
  appimage-run
  gnumake
  cmake
  home-manager

  # Media and design tools
  fontconfig

  # Productivity tools

  # Audio tools
  pavucontrol # Pulse audio controls

  # Testing and development tools
  rofi
  rofi-calc
  libtool # for Emacs vterm

  # Cloud-related tools and SDKs
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
  tree
  unixtools.ifconfig
  unixtools.netstat
  vivid
  xclip # For the org-download package in Emacs
  xorg.xwininfo # Provides a cursor to click and learn about windows
  xorg.xrandr
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
