_:

let
  mkNoBinaries = name: {
    inherit name;
    # ` brew install --cask --no-binaries`
    args = {
      no_binaries = true;
    };
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
jetbrainsIDEs
++ [
  # IDEs & Editors
  "jetbrains-toolbox"
  "visual-studio-code"

  # Development Tools
  "android-platform-tools"
  "arcbox" # Docker Desktop alternative
  "bruno"
  "docker-desktop"
  "iterm2"
  "ghostty"
  "kitty"

  # Cloud & Infrastructure
  "freelens"
  "gcloud-cli"
  {
    name = "headlamp";
    # Note: The `no_quarantine` option bypasses macOS Gatekeeper security warnings.
    # Headlamp's desktop app is unsigned. For more information about running unsigned apps, see:
    # - https://headlamp.dev/docs/latest/installation/desktop/
    # - https://headlamp.dev/docs/latest/installation/desktop/mac-installation/
    args = {
      no_quarantine = true;
    };
  }

  # Productivity
  "agentsview"
  "antigravity-cli"
  "chatgpt"
  "claude-code"
  "claudebar"
  "codex"
  "espanso"
  "google-drive"
  "jan"
  "kde-connect"
  "lm-studio"
  "raycast"
  "typewhisper"
  "zotero"

  # Browsers
  "firefox"
  "google-chrome"

  # Communication
  "discord"
  "slack"
  "telegram"
  "thunderbird"
  "whatsapp"

  # Security & Password Managers
  "1password"
  "keepassxc"

  # Utilities
  "alexstrnik/browserino/browserino"
  "apache-directory-studio"
  "appcleaner"
  "crumbyte/noxdir/noxdir"
  "deskflow/tap/deskflow"
  "finetune"
  "flux-app"
  "home-assistant"
  "hrzlgnm/tap/mdns-browser"
  "keka"
  "kekaexternalhelper"
  "localsend"
  "logitech-g-hub"
  "maccy" # Clipy alternative
  "macfuse"
  "menumeters"
  "monitorcontrol"
  "nextcloud"
  "openlogi" # Logitech Options+ alternative
  "owenthereal/upterm/upterm"
  "rectangle"
  "reminders-menubar"
  "rustdesk"
  "santosh7017/androidfilesync/androidfilesync"
  "stats"
  "thaw"
  "whatcable"

  # Entertainment & Media
  "audacity"
  "blackhole-16ch" # Virtual Audio Driver
  "jellyfin-media-player"
  "openttd"
  "sozercan/repo/kaset" # The missing YouTube Music macOS app
  "steam"
  "vlc"
]
