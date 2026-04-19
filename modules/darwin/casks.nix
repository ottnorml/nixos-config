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
    "pycharm"
    "rustrover"
  ];
in
jetbrainsIDEs ++
[
  # IDEs & Editors
  "jetbrains-toolbox"
  "visual-studio-code"

  # Development Tools
  "android-platform-tools"
  "bruno"
  "docker-desktop"
  "iterm2"
  "kitty"
  "postman"

  # Cloud & Infrastructure
  "freelens"
  "gcloud-cli"
  {
    name = "headlamp";
    # Note: The `no_quarantine` option bypasses macOS Gatekeeper security warnings.
    # Headlamp's desktop app is unsigned. For more information about running unsigned apps, see:
    # - https://headlamp.dev/docs/latest/installation/desktop/
    # - https://headlamp.dev/docs/latest/installation/desktop/mac-installation/
    args = { no_quarantine = true; };
  }

  # Productivity
  "chatgpt"
  "claudebar"
  "codex"
  "codex-app"
  "google-drive"
  "jan"
  "lm-studio"
  "raycast"
  "zotero"

  # Browsers
  "firefox"
  "google-chrome"

  # Communication
  "discord"
  "slack"
  "telegram"
  "whatsapp"

  # Security & Password Managers
  "1password"
  "keepassxc"

  # Utilities
  "alexstrnik/browserino/browserino"
  "apache-directory-studio"
  "appcleaner"
  "clipy"
  "crumbyte/noxdir/noxdir"
  "deskflow/tap/deskflow"
  "flux-app"
  "home-assistant"
  "keka"
  "kekaexternalhelper"
  "localsend"
  "logitech-g-hub"
  "maccy" # Clipy alternative
  "macfuse"
  "menumeters"
  "nextcloud"
  "ottnorml/mdns-browser/mdns-browser"
  "rectangle"
  "reminders-menubar"
  "rustdesk"
  "thaw"

  # Entertainment & Media
  "jellyfin-media-player"
  "openttd"
  "steam"
  "vlc"
]
