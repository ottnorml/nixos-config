_:

let
  mkNoBinaries = name: {
    inherit name;
    # ` brew install --cask --no-binaries`
    args = { no_binaries = true; };
  };

  jetbrainsIDEs = map mkNoBinaries [
    "android-studio"
    "goland"
    "intellij-idea"
    "phpstorm"
    "rustrover"
  ];
in
jetbrainsIDEs ++
[
  # IDEs
  "jetbrains-toolbox"
  "visual-studio-code"

  # Development Tools
  "android-platform-tools"
  "docker-desktop"
  "iterm2"
  "kitty"
  "postman"
  # "cursor"

  # Cloud-related tools and SDKs
  "freelens"
  "gcloud-cli"

  # Productivity Tools
  "lm-studio"
  "raycast"

  # Browsers
  "firefox"
  "google-chrome"

  # Communication Tools - Examples (uncomment as needed)
  "discord"
  # "notion"
  "slack"
  "telegram"
  # "zoom"

  # Utility Tools - Examples (uncomment as needed)
  # "syncthing"
  "1password"
  "keepassxc"
  "rectangle"
  "rustdesk"

  # Entertainment Tools - Examples (uncomment as needed)
  # "spotify"
  "jellyfin-media-player"
  "openttd"
  "steam"
  "vlc"
]
