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
  # Command-line tools for building and debugging Android apps.
  "android-commandlinetools"
  # Git client for simultaneous branches.
  "gitbutler"
  # Agentic development environment.
  "jetbrains-air"
  # Application for generating k6 test scripts.
  "k6-studio"
  # Graphical client for Git version control.
  "sourcetree"
  # Multiplayer code editor.
  "zed"
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
  # Virtual machines UI using QEMU.
  "utm"

  # AI & Knowledge Work
  # Time tracker.
  "activitywatch@beta"
  # Browse, search, and analyze past AI coding sessions.
  "agentsview"
  # Terminal interface for Antigravity agents.
  "antigravity-cli"
  # Autonomous multi-session AI coding.
  "auto-claude"
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
  # Local-first dictation and meeting transcription.
  "muesli"
  # Private desktop AI chat application.
  "anythingllm"
  # Desktop application for Open WebUI.
  "open-webui"
  # AI coding agent desktop client.
  "opencode-desktop"
  # Knowledge base built on local Markdown files.
  "obsidian"
  # Speech-to-text and AI text processing.
  "typewhisper"
  # Open-source Markdown editor.
  "zettlr"

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
  # Server and cloud storage browser.
  "cyberduck"
  # Web browser.
  "firefox"
  # Web browser.
  "google-chrome"
  # Download manager.
  "jdownloader"
  # Browse mDNS services on the network.
  "hrzlgnm/tap/mdns-browser"
  # Terminal UI for mDNS service discovery.
  "hrzlgnm/tap/mdns-tui-browser"

  # Security & Credentials
  # Password manager.
  "1password"
  # Official eID client of the Federal Government of Germany.
  "ausweisapp"
  # Password manager app.
  "keepassxc"
  # Open-source firewall for unknown outgoing connections.
  "lulu"
  # Full-featured YubiKey companion app.
  "yubico-authenticator"

  # System, Device & File Utilities
  # Application uninstaller.
  "appcleaner"
  # LDAP browser and directory client.
  "apache-directory-studio"
  # Keep the computer awake while AI coding agents work.
  "adrafinil"
  # Mouse and keyboard sharing utility.
  "deskflow/tap/deskflow"
  # Per-application volume mixer and audio router.
  "finetune"
  # Screen colour temperature controller.
  "flux-app"
  # Home Assistant companion app.
  "home-assistant"
  # Open-source keystroke visualizer.
  "keycastr"
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
  # Network protocol analyzer.
  "wireshark-app"
  # Menu bar manager.
  "thaw"
  # Command-line tool for pstree-like output.
  "truetree"
  # USB-C cable diagnostics menu bar app.
  "whatcable"
  # Battery health and live power menu bar app.
  "darrylmorley/whatbattery/whatbattery"
  # Real-time USB-C port status menu bar app.
  "darrylmorley/whatport/whatport"

  # Office, Documents & Finance
  # Client for Google Drive storage.
  "google-drive"
  # Java application platform with an SWT UI.
  "jameica"
  # Free cross-platform office suite.
  "libreoffice"
  # Alternate language collection for LibreOffice.
  "libreoffice-language-pack"
  # Tax declaration for fiscal year 2022.
  "wiso-steuer-2023"
  # Tax declaration for fiscal year 2023.
  "wiso-steuer-2024"
  # Tax declaration for fiscal year 2024.
  "wiso-steuer-2025"
  # Tax declaration for fiscal year 2025.
  "wiso-steuer-2026"
  # Research source collection and citation manager.
  "zotero"

  # Media & Entertainment
  # Multi-track audio editor and recorder.
  "audacity"
  # Virtual audio driver.
  "blackhole-16ch"
  # Jellyfin desktop client.
  "jellyfin-media-player"
  # Open-source live streaming and screen recording software.
  "obs"
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
