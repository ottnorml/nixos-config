_:

[
  # Cloud, Container & Kubernetes
  # Terminal UI for managing SSH connections.
  "adembc/tap/lazyssh"
  # Cloud provider for KIND clusters.
  "cloud-provider-kind"
  # Flux CLI.
  "fluxcd/tap/flux"
  # Command-line interface for Hetzner Cloud.
  "hcloud"
  # Kubernetes package manager.
  "helm"
  # Deploy Kubernetes Helm Charts.
  "helmfile"
  # Little helper to run CNCF's k3s in Docker.
  "k3d"
  # Kubernetes CLI to manage your clusters in style.
  "k9s"
  # Run local Kubernetes cluster in Docker.
  "kind"
  # Fast and simple dashboard for Kubernetes written in Rust.
  "kdash-rs/kdash/kdash"
  # Tool to move from docker-compose to Kubernetes.
  "kompose"
  # CLI tool to discover unused Kubernetes resources.
  "kor"
  # Package manager for kubectl plugins.
  "krew"
  # KubeConfig manager.
  "kubecm"
  # Fast Kubernetes manifests validator with support for Custom Resources.
  "kubeconform"
  # Kubernetes command-line interface.
  "kubernetes-cli"
  # Tool to switch between kubectl contexts and create aliases.
  "kubectx"
  # Check clusters for use of deprecated APIs.
  "kubent"
  # Kubernetes testing according to NSA and CISA hardening guidance.
  "kubescape"
  # Template-free customization of Kubernetes YAML manifests.
  "kustomize"
  # Run a Kubernetes cluster locally.
  "minikube"
  # Drop-in replacement for Terraform.
  "opentofu"
  # Kubernetes cluster resource sanitizer.
  "popeye"
  # Work with remote image registries.
  "skopeo"
  # CLI for out-of-band management of Talos Kubernetes nodes.
  "talosctl"
  # Thin wrapper for Terraform, including state locking.
  "terragrunt"
  # Define your development environment as code for microservices.
  "tilt"
  # Fully functional virtual Kubernetes cluster.
  "vcluster"
  # SDK for building Kubernetes APIs using CRDs.
  "kubebuilder"
  # SDK for building Kubernetes applications.
  "operator-sdk"
  # Easy and repeatable Kubernetes development.
  "skaffold"

  # Source Control, CI & Development
  # Run GitHub Actions locally.
  "act"
  # CLI for exploring and testing APIs.
  "bruno-cli"
  # GitHub command-line tool (GitHub CLI).
  "gh"
  # Distributed revision control system.
  "git"
  # Modern implementation of Git-flow.
  "git-flow-next"
  # Run GitLab pipelines locally.
  "gitlab-ci-local"
  # Open-source GitLab command-line tool.
  "glab"
  # Fast runner for Go linters.
  "golangci-lint"
  # Interactive jq.
  "ijq"
  # Git-compatible distributed version control system.
  "jj"
  # Interactive CLI for creating conventional commits.
  "koji"
  # Modern load testing tool using Go and JavaScript.
  "k6"
  # Curses-based tool for viewing and analyzing log files.
  "lnav"
  # CLI for Node.js Markdown linting.
  "markdownlint-cli"
  # Polyglot runtime manager.
  "mise"
  # JavaScript runtime, bundler, transpiler, and package manager.
  "oven-sh/bun/bun"
  # Draw UML diagrams.
  "plantuml"
  # Fast, disk-space-efficient package manager.
  "pnpm"
  # Framework for managing multi-language pre-commit hooks.
  "pre-commit"
  # Fast Git hook manager written in Rust.
  "prek"
  # Pair Android devices for wireless ADB debugging.
  "richard-fairthorne/tap/pairqr"
  # CLI for Linear that opens issues and team pages.
  "schpet/tap/linear"
  # Text interface for Git repositories.
  "tig"
  # Markup-based typesetting system.
  "typst"
  # Reliable Typst code formatter.
  "typstyle"
  # Extremely fast Python package installer and resolver.
  "uv"
  # YAML, JSON, XML, CSV, and properties processor.
  "yq"

  # AI & Agent Tooling
  # The AI coding agent for the terminal.
  "anomalyco/tap/opencode"
  # Linter checking CLI tools for agent-readiness principles.
  "brettdavies/tap/agentnative"
  # Code searching, linting, and rewriting.
  "ast-grep"
  # Markdown-native task manager and Kanban visualizer.
  "backlog-md"
  # Memory upgrade for coding agents.
  "beads"
  # Junie CLI.
  "jetbrains/junie/junie"
  # Minimal CLI coding agent.
  "mistral-vibe"
  # Capability-based sandbox shell for AI agents.
  "nono"
  # CLI proxy to minimize LLM token consumption.
  "rtk"
  # Permanent memory MCP server with hybrid search.
  "rtk-ai/tap/icm"
  # Unified AI rules management CLI.
  "rulesync"

  # Security, Compliance & Secrets
  # Container signing.
  "cosign"
  # Editor of encrypted files.
  "sops"
  # SSH server and client auditing.
  "ssh-audit"
  # Vulnerability scanner for containers, filesystems, and Git repositories.
  "trivy"
  # Command-line interface for VirusTotal.
  "virustotal-cli"

  # Shell & Filesystem
  # Multi-shell, multi-command argument completer.
  "carapace"
  # Manage dotfiles securely across diverse machines.
  "chezmoi"
  # GNU Shell and text utilities.
  "coreutils"
  # Syntax-aware diff tool.
  "difftastic"
  # Load and unload environment variables based on the current directory.
  "direnv"
  # Disk usage and free utility.
  "duf"
  # More intuitive version of du.
  "dust"
  # Improved interactive process viewer.
  "htop"
  # Highly parallelized directory tree analyzer.
  "parallel-disk-usage"
  # Show process output as a tree.
  "pstree"
  # 7-Zip file archiver with high compression ratio.
  "sevenzip"
  # Log file highlighter.
  "tailspin"
  # Interactive command-line cheatsheet tool.
  "navi"
  # NCurses disk usage analyzer.
  "ncdu"
  # Monitor data progress through a pipe.
  "pv"
  # Rust fuzzy finder (skim-fuzzy-finder).
  "sk"
  # Generator for LS_COLORS with many themes.
  "vivid"
  # Shell extension for navigating the filesystem.
  "zoxide"

  # Network, Hardware & macOS
  # Tool for managing Dock items.
  "dockutil"
  # CLI for basic network utilities on macOS.
  "iproute2mac"
  # Measures TCP, UDP, and SCTP bandwidth.
  "iperf3"
  # Terminal battery and energy monitor.
  "jordond/tap/jolt"
  # List USB devices like Linux lsusb.
  "lsusb-laniksj"
  # GPU top for Apple Silicon and other platforms.
  "lablup/tap/all-smi"
  # Sudoless performance monitor for Apple Silicon.
  "macmon"
  # Mac App Store command-line interface.
  "mas"
  # Inspect macOS HID devices.
  "masawada/tap/macos-hid-inspector"
  # Real-time network diagnostics in the terminal.
  "matthart1983/tap/netwatch"
  # Single-host system diagnostics TUI.
  "matthart1983/tap/syswatch"
  # Kubernetes tool for scanning network policies and workloads.
  "netfetch"
  # Port scanning utility for large networks.
  "nmap"
  # SMART hard drive monitoring.
  "smartmontools"
  # Custom macOS status bar with shell plugins.
  "felixkratz/formulae/sketchybar"
  # CLI and TUI for managing UniFi network controllers.
  "hyperb1iss/tap/unifly"
  # USB-C cable diagnostics.
  "darrylmorley/whatcable/whatcable-cli"

  # Data & Documentation
  # Lightweight JSON processor.
  "jq"
  # Visually compare two PDF files.
  "diff-pdf"
  # Tool for visualizing differences between PDF files.
  "pdf-diff"
  # Swiss-army knife of markup format conversion.
  "pandoc"

  # Dependencies & Support
  # Git for Data; support dependency for beads.
  "dolt"

  # Disabled Yabai window manager formula.
  # "asmvik/formulae/yabai"
]
