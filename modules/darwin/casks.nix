_:

let
  mkNoBinaries = name: {
    inherit name;
    # ` brew install --cask --no-binaries`
    args = {
      no_binaries = true;
    };
  };

  # Development & IDEs
  jetbrainsIDEs = map mkNoBinaries [
    # Tools for building Android applications.
    "android-studio"
    # Go IDE.
    "goland"
    # Java IDE by JetBrains.
    "intellij-idea"
    # PHP IDE by JetBrains.
    "phpstorm"
    # IDE for professional Python development.
    "pycharm"
    # Rust IDE.
    "rustrover"
  ];
in
jetbrainsIDEs
++ [
  # Development & IDEs
  # JetBrains tools manager.
  "jetbrains-toolbox"
  # Open-source code editor.
  "visual-studio-code"
  # Android SDK component.
  "android-platform-tools"
  # Open-source IDE for exploring and testing APIs.
  "bruno"
  # Terminal emulator alternative to Apple's Terminal.
  "iterm2"
  # GPU-accelerated terminal emulator with native UI.
  "ghostty"
  # GPU-based terminal emulator.
  "kitty"

  # Cloud, Container & Mobile
  # Container, Linux VM, and AI agent runtime; Docker Desktop alternative.
  "arcbox"
  # App to build and share containerized applications and microservices.
  "docker-desktop"
  # Kubernetes IDE.
  "freelens"
  # Tools for managing Google Cloud resources and applications.
  "gcloud-cli"
  # UI for Kubernetes.
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
  # Desktop sync client for Nextcloud software products.
  "nextcloud"

  # AI & Knowledge Work
  # Browse, search, and analyze past AI coding sessions.
  "agentsview"
  # Terminal interface for Antigravity agents.
  "antigravity-cli"
  # OpenAI's official ChatGPT desktop app.
  "chatgpt"
  # Terminal-based AI coding assistant.
  "claude-code"
  # Menu bar app for AI coding assistant quotas.
  "claudebar"
  # OpenAI's coding agent for the terminal.
  "codex"
  # Offline AI chat tool.
  "jan"
  # Discover, download, and run local LLMs.
  "lm-studio"
  # Speech-to-text and AI text processing.
  "typewhisper"

  # Communication & Collaboration
  # Communicate with handheld devices.
  "kde-connect"
  # App for software development and bug tracking.
  "linear"
  # Voice and text chat software.
  "discord"
  # Team communication and collaboration software.
  "slack"
  # Messaging app focused on speed and security.
  "telegram"
  # Customizable email client.
  "thunderbird"
  # Native desktop client for WhatsApp.
  "whatsapp"

  # Browsers & Internet
  # Browser selector for macOS.
  "alexstrnik/browserino/browserino"
  # Web browser.
  "firefox"
  # Web browser.
  "google-chrome"
  # Browse mDNS services on the network.
  "hrzlgnm/tap/mdns-browser"
  # Terminal UI for mDNS service discovery.
  "hrzlgnm/tap/mdns-tui-browser"

  # Security & Credentials
  # Password manager.
  "1password"
  # Password manager app.
  "keepassxc"

  # System, Device & File Utilities
  # Application uninstaller.
  "appcleaner"
  # LDAP browser and directory client.
  "apache-directory-studio"
  # Mouse and keyboard sharing utility.
  "deskflow/tap/deskflow"
  # Per-application volume mixer and audio router.
  "finetune"
  # Screen colour temperature controller.
  "flux-app"
  # Home Assistant companion app.
  "home-assistant"
  # File archiver.
  "keka"
  # Open-source cross-platform AirDrop alternative.
  "localsend"
  # Support for Logitech G gear.
  "logitech-g-hub"
  # Cross-platform text expander written in Rust.
  "espanso"
  # Clipboard manager; Clipy alternative.
  "maccy"
  # Filesystem integration for macOS.
  "macfuse"
  # CPU, memory, disk, and network monitoring tools.
  "menumeters"
  # Control external monitor brightness and volume.
  "monitorcontrol"
  # Terminal utility for visualizing filesystem usage.
  "crumbyte/noxdir/noxdir"
  # Local-first alternative to Logitech Options+.
  "openlogi"
  # Instant terminal sharing.
  "owenthereal/upterm/upterm"
  # Move and resize windows with keyboard shortcuts or snap areas.
  "rectangle"
  # Control tools with a few keystrokes.
  "raycast"
  # Menu bar app for Apple Reminders.
  "reminders-menubar"
  # Open-source virtual and remote desktop application.
  "rustdesk"
  # Native macOS app for transferring files to Android devices.
  "santosh7017/androidfilesync/androidfilesync"
  # System monitor for the menu bar.
  "stats"
  # Menu bar manager.
  "thaw"
  # USB-C cable diagnostics menu bar app.
  "whatcable"
  # Battery health and live power menu bar app.
  "darrylmorley/whatbattery/whatbattery"
  # Real-time USB-C port status menu bar app.
  "darrylmorley/whatport/whatport"

  # Office, Documents & Finance
  # Client for Google Drive storage.
  "google-drive"
  # Research source collection and citation manager.
  "zotero"

  # Media & Entertainment
  # Multi-track audio editor and recorder.
  "audacity"
  # Virtual audio driver.
  "blackhole-16ch"
  # Jellyfin desktop client.
  "jellyfin-media-player"
  # Open-source transport simulation game.
  "openttd"
  # Native YouTube Music client; the missing YouTube Music macOS app.
  "sozercan/repo/kaset"
  # Video game digital distribution service.
  "steam"
  # Multimedia player.
  "vlc"

  # Dependencies & Support
  # Helper application for the Keka file archiver.
  "kekaexternalhelper"
]
