{
  config,
  lib,
  nixpkgs-master,
  pkgs,
  ...
}:

let
  name = "Simon Potye";
  user = "spt";
  email = "2350859+ottnorml@users.noreply.github.com";
  p10kConfig = lib.cleanSource ./config;
in
{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nix-your-shell.enable
  nix-your-shell = {
    enable = true;
    enableZshIntegration = false;
    nix-output-monitor.enable = true;
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nnn.enable
  nnn = {
    enable = true;
    enableZshIntegration = true;
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  starship = {
    enable = true;

    # Important: Do not let Home Manager automatically write the integration into .zshrc.
    # We initialize Starship manually below via ZSH_PROMPT_ENGINE.
    enableZshIntegration = false;

    configPath = "${config.xdg.configHome}/starship/starship.toml";

    # settings = {
    #   add_newline = true;
    #   command_timeout = 500;
    #   scan_timeout = 30;
    #
    #   format = ''
    #     $os$directory$git_branch$git_status$git_state
    #     $character'';
    #
    #   right_format = "$status$cmd_duration$jobs$direnv$nix_shell$python$nodejs$golang$rust$terraform$kubernetes$aws$gcloud";
    #
    #   os = {
    #     disabled = false;
    #     format = "[$symbol]($style) ";
    #     style = "bg:bright-white fg:black";
    #   };
    #
    #   directory = {
    #     format = "[ $path ]($style)";
    #     style = "bg:blue fg:white bold";
    #     truncation_length = 5;
    #     truncate_to_repo = false;
    #     fish_style_pwd_dir_length = 1;
    #     read_only = " ";
    #   };
    #
    #   git_branch = {
    #     symbol = " ";
    #     format = "[ $symbol$branch(:$remote_branch) ]($style)";
    #     style = "bg:green fg:black";
    #     truncation_length = 32;
    #   };
    #
    #   git_status = {
    #     format = "([ $all_status$ahead_behind ]($style))";
    #     style = "bg:yellow fg:black";
    #     conflicted = "~$count";
    #     ahead = "⇡$count";
    #     behind = "⇣$count";
    #     diverged = "⇕⇡$ahead_count⇣$behind_count";
    #     stashed = "*$count";
    #     modified = "!$count";
    #     staged = "+$count";
    #     renamed = "»$count";
    #     deleted = "✘$count";
    #     untracked = "?$count";
    #   };
    #
    #   git_state = {
    #     format = "[ $state( $progress_current/$progress_total) ]($style)";
    #     style = "bg:red fg:white";
    #   };
    #
    #   character = {
    #     success_symbol = "[❯](green)";
    #     error_symbol = "[❯](red)";
    #     vicmd_symbol = "[❮](green)";
    #   };
    #
    #   status = {
    #     disabled = false;
    #     format = "[$symbol$status]($style) ";
    #     style = "red";
    #     pipestatus = true;
    #   };
    #
    #   cmd_duration = {
    #     min_time = 3000;
    #     format = "took [$duration]($style) ";
    #   };
    #
    #   jobs = {
    #     disabled = false;
    #     symbol = "✦";
    #     number_threshold = 1;
    #     format = "[$symbol$number]($style) ";
    #   };
    #
    #   direnv = {
    #     disabled = false;
    #     format = "[$symbol$loaded/$allowed]($style) ";
    #   };
    #
    #   nix_shell = {
    #     disabled = false;
    #     symbol = "❄ ";
    #     format = "[$symbol$state( \\($name\\))]($style) ";
    #   };
    #
    #   python = {
    #     symbol = " ";
    #     format = "[$symbol$version( \\($virtualenv\\))]($style) ";
    #     detect_extensions = [ "py" ];
    #     detect_files = [ "pyproject.toml" "requirements.txt" ".python-version" ];
    #   };
    #
    #   nodejs = {
    #     symbol = " ";
    #     format = "[$symbol$version]($style) ";
    #     detect_files = [ "package.json" ".node-version" ".nvmrc" ];
    #   };
    #
    #   golang = {
    #     symbol = " ";
    #     format = "[$symbol$version]($style) ";
    #     detect_files = [ "go.mod" ];
    #   };
    #
    #   rust = {
    #     symbol = " ";
    #     format = "[$symbol$version]($style) ";
    #     detect_files = [ "Cargo.toml" ];
    #   };
    #
    #   terraform = {
    #     symbol = "󱁢 ";
    #     format = "[$symbol$workspace]($style) ";
    #   };
    #
    #   kubernetes = {
    #     disabled = false;
    #     symbol = "☸ ";
    #     format = "[$symbol$context( \\($namespace\\))]($style) ";
    #   };
    #
    #   aws = {
    #     disabled = false;
    #     symbol = " ";
    #     format = "[$symbol$profile( \\($region\\))]($style) ";
    #   };
    #
    #   gcloud = {
    #     disabled = false;
    #     symbol = "☁ ";
    #     format = "[$symbol$project]($style) ";
    #   };
    # };
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.oh-my-posh.enable
  oh-my-posh = {
    enable = true;
    # Also here: no automatic .zshrc injection.
    enableZshIntegration = false;

    # For the initial test: as close as possible to p10k.
    # useTheme = "powerlevel10k_rainbow";
  };

  # Shared shell configuration
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable
  zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autocd = false;
    cdpath = [ "~/Projects" ];
    # Disable global completion init to speed up compinit in user zsh configs.
    enableCompletion = false;

    shellAliases = {
      # Always color ls and group directories
      ls = "ls --color=auto --group-directories-first";
      ll = "ls -lisahF";
      which = "(alias; declare -f) | ${pkgs.which}/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot";
    };

    siteFunctions = {
      mkcd = ''
        mkdir --parents "$1" && cd "$1"
      '';
      reload = ''
        # Delete current completion cache
        command rm -f $_comp_dumpfile $ZSH_COMPDUMP

        # Old zsh versions don't have ZSH_ARGZERO
        local zsh="''${ZSH_ARGZERO:-''${functrace[-1]%:*}}"
        # Check whether to run a login shell
        [[ "$zsh" = -* || -o login ]] && exec -l "''${zsh#-}" || exec "$zsh"
      '';
      # nix-shell shortcuts
      shell = ''
        if [[ $# -eq 0 || -z "$1" ]]; then
          echo "usage: shell <nixpkgs-attribute>" >&2
          echo "example: shell nodejs_24" >&2
          return 2
        fi

        nix-shell '<nixpkgs>' -A "$1"
      '';
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fi

        # Hook: Load local pre-init configuration
        if [[ -f "${config.xdg.configHome}/zsh/zshrc.pre" ]]; then
          source "${config.xdg.configHome}/zsh/zshrc.pre"
        fi

        # Hook: Load local environment configuration
        if [[ -f "${config.xdg.configHome}/zsh/zshrc.env" ]]; then
          source "${config.xdg.configHome}/zsh/zshrc.env"
        fi

        if [[ -z ''${ZSH_DISABLE_ZINIT:-} ]]; then
          # Configure and load Zinit from Nixpkgs.
          declare -A ZINIT
          ZINIT[COMPINIT_OPTS]="-C"
          source "${pkgs.zinit}/share/zinit/zinit.zsh"

          # Register Zinit completion when compinit has already been initialized.
          autoload -Uz _zinit
          (( ''${+_comps} )) && _comps[zinit]=_zinit

          # Load useful Zinit annexes recommended by the installer.
          # These extend Zinit with monitoring, binary/gem/node handling,
          # patch/download helpers and Rust-related support.
          zinit light-mode for \
            zdharma-continuum/zinit-annex-as-monitor \
            zdharma-continuum/zinit-annex-bin-gem-node \
            zdharma-continuum/zinit-annex-patch-dl \
            zdharma-continuum/zinit-annex-rust

          # Hook: Load local zinit configuration
          if [[ -f "${config.xdg.configHome}/zsh/zshrc.zinit" ]]; then
            source "${config.xdg.configHome}/zsh/zshrc.zinit"
          fi
        fi


        ### --- ###

        # Remove history data we don't want to see
        export HISTIGNORE="pwd:ls:cd"

        # Ripgrep alias
        alias search=rg -p --glob '!node_modules/*'  $@

        # Emacs is my editor
        export ALTERNATE_EDITOR=""
        export EDITOR="emacsclient -t"
        export VISUAL="emacsclient -c -a emacs"

        e() {
            emacsclient -t "$@"
        }
        # pnpm is a javascript package manager
        alias pn=pnpm
        alias px=pnpx

        # Use difftastic, syntax-aware diffing
        alias diff=difft

        # Hook: Load local aliases configuration
        if [[ -f "${config.xdg.configHome}/zsh/zshrc.aliases" ]]; then
          source "${config.xdg.configHome}/zsh/zshrc.aliases"
        fi



        # https://carapace-sh.github.io/carapace-bin/setup.html#zsh
        if [[ -z ''${ZSH_DISABLE_CARAPACE:-} ]] && (( $+commands[carapace] )); then
          # ''${UserConfigDir}/zsh/.zshrc
          export CARAPACE_BRIDGES='zsh' # optional
          zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
          source <(carapace _carapace)
        fi

        # https://github.com/ohmyzsh/ohmyzsh/blob/a449c0247d69726fe4f3ca4fe88182bdb215a5d3/plugins/zoxide/zoxide.plugin.zsh
        if [[ -n ''${ZSH_DISABLE_ZOXIDE:-} ]]; then
          :
        elif (( $+commands[zoxide] )); then
          eval "$(zoxide init --cmd ''${ZOXIDE_CMD_OVERRIDE:-cd} zsh)"
        else
          echo 'zoxide not found, please install it from https://github.com/ajeetdsouza/zoxide'
        fi
      '')
      (lib.mkAfter ''
        if [[ -n ''${ZSH_ENABLE_P10K:-} && -z ''${ZSH_DISABLE_P10K:-} ]]; then
          source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
          source "${p10kConfig}/p10k.zsh"
        elif [[ -z ''${ZSH_DISABLE_P10K:-} && ( -z ''${PROMPT:-} || $PROMPT == '%m%# ' || $PROMPT == '%# ' ) ]]; then
          PROMPT='%n@%m:%~ %# '
          RPROMPT=
        fi

        if [[ -z ''${ZSH_DISABLE_NIX_YOUR_SHELL:-} ]]; then
          ${pkgs.nix-your-shell}/bin/nix-your-shell --nom zsh | source /dev/stdin
        fi

        __minimal_prompt() {
          PROMPT='%n@%m:%~ %# '
          RPROMPT=
        }

        case "''${ZSH_PROMPT_ENGINE:-starship}" in
          starship)
            eval "$(${pkgs.starship}/bin/starship init zsh)"
            ;;

          ohmyposh|oh-my-posh|omp)
            eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${pkgs.oh-my-posh}/share/oh-my-posh/themes/powerlevel10k_rainbow.omp.json)"
            ;;

          minimal|none|off)
            __minimal_prompt
            ;;

          *)
            print -u2 "Unknown ZSH_PROMPT_ENGINE=''${ZSH_PROMPT_ENGINE}; using minimal prompt."
            __minimal_prompt
            ;;
        esac

        unset -f __minimal_prompt

        # Hook: Load local post-init configuration
        if [[ -f "${config.xdg.configHome}/zsh/zshrc.local" ]]; then
          source "${config.xdg.configHome}/zsh/zshrc.local"
        fi

        # Hook: Load all scripts from a local directory
        if [[ -d "${config.xdg.configHome}/zsh/zshrc.d" ]]; then
          for file in "${config.xdg.configHome}/zsh/zshrc.d"/*.zsh(N); do
            source "$file"
          done
        fi
      '')
    ];
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
  #  git = {
  #    enable = true;
  #    ignores = [ "*.swp" ];
  #    userName = name;
  #    userEmail = email;
  #    lfs = {
  #      enable = true;
  #    };
  #    extraConfig = {
  #      init.defaultBranch = "main";
  #      core = {
  #        editor = "vim";
  #        autocrlf = "input";
  #      };
  #      commit.gpgsign = true;
  #      pull.rebase = true;
  #      rebase.autoStash = true;
  #    };
  #  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vim.enable
  vim = {
    enable = true;
    plugins = with nixpkgs-master.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-startify
      vim-tmux-navigator
    ];
    settings = {
      ignorecase = true;
    };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=${config.xdg.configHome}/vim/backups
      set directory=${config.xdg.configHome}/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/Projects',
        \ '~/Documents',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
    '';
  };

  alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = "Block";
      };

      window = {
        opacity = 1.0;
        padding = {
          x = 24;
          y = 24;
        };
      };

      # Fix for shell path when launching from desktop
      # When launching from desktop, $SHELL may point to /bin/zsh instead of
      # the Nix-managed shell, causing environment issues
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };

      font = {
        normal = {
          family = "MesloLGS NF";
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
        ];
      };

      colors = {
        primary = {
          background = "0x1f2528";
          foreground = "0xc0c5ce";
        };

        normal = {
          black = "0x1f2528";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xc0c5ce";
        };

        bright = {
          black = "0x65737e";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xd8dee9";
        };
      };
    };
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable
  #  ssh = {
  #    enable = true;
  #    enableDefaultConfig = false;
  #    includes = [
  #      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
  #        "/home/${user}/.ssh/config_external"
  #      )
  #      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
  #        "/Users/${user}/.ssh/config_external"
  #      )
  #    ];
  #    matchBlocks = {
  #      "*" = {
  #        # Set the default values we want to keep
  #        sendEnv = [ "LANG" "LC_*" ];
  #        hashKnownHosts = true;
  #      };
  #      "github.com" = {
  #        identitiesOnly = true;
  #        identityFile = [
  #          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
  #            "/home/${user}/.ssh/id_github"
  #          )
  #          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
  #            "/Users/${user}/.ssh/id_github"
  #          )
  #        ];
  #      };
  #    };
  #  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.tmux.enable
  tmux = {
    enable = true;
    package = nixpkgs-master.tmux;
    plugins = with nixpkgs-master.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      yank
      prefix-highlight
      {
        plugin = power-theme;
        extraConfig = ''
          set -g @tmux_power_theme 'gold'
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum

        # Use the Home Manager XDG state directory. This is written as an
        # absolute path because tmux.conf is not evaluated by a shell.
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '${config.xdg.stateHome}/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
    terminal = "screen-256color";
    prefix = "C-x";
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      # Remove Vim mode delays
      set -g focus-events on

      # Enable full mouse support
      set -g mouse on

      # -----------------------------------------------------------------------------
      # Key bindings
      # -----------------------------------------------------------------------------

      # Unbind default keys
      unbind C-b
      unbind '"'
      unbind %

      # Split panes, vertical or horizontal
      bind-key x split-window -v
      bind-key v split-window -h

      # Move around panes with vim-like bindings (h,j,k,l)
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-l select-pane -R

      # Smart pane switching with awareness of Vim splits.
      # This is copy paste from https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
    '';
  };
}
