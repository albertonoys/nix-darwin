{
  config,
  pkgs,
  lib,
  inputs,
  home-manager,
  ...
}: let
  user = "noys";
  name = "Alberto Noys";
  email = "albertonoys@gmail.com";
in {
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.lib.mkForce "/Users/${user}/.nix-profile/bin/fish";
  };

  homebrew = {
    enable = true;
    global.autoUpdate = true;
    global.brewfile = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    casks = pkgs.callPackage ./casks.nix {};
    brews = [
      "bitwarden-cli"
      "ffmpeg"
      "topgrade"
    ];
    masApps = {
      "WhatsApp Messenger" = 310633997;
      "TickTick:To-Do List, Calendar" = 966085870;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    # useUserPackages = true;
    backupFileExtension = "nixbckp";
    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      home = {
        packages = pkgs.callPackage ./packages.nix {};
        file.".config" = {
          source = ../../dotfiles;
          recursive = true;
          executable = true;
        };
        stateVersion = "24.05";
      };
      programs = {
        bat.enable = true;
        bottom.enable = true;
        btop.enable = true;
        bun.enable = true;
        direnv.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        fd.enable = true;
        fzf.enable = true;
        gh.enable = true;
        home-manager.enable = true;
        jq.enable = true;
        lazygit.enable = true;
        neovim.enable = true;
        ripgrep.enable = true;
        thefuck.enable = true;
        zoxide.enable = true;

        atuin = {
          enable = true;
          settings = {
            dialect = "uk";
            style = "compact";
            inline_height = 20;
            show_preview = true;
            enter_accept = true;
            sync.records = true;
            dotfiles.enabled = false;
          };
        };

        fish = {
          enable = true;
          shellAliases = {
            ".." = "cd ..";
            rld = "source ~/.config/fish/config.fish";
            aliasList = "alias | bat --paging=never --wrap=never --language=fish";
            ding = "tput bel";

            ls = "eza --oneline --all --group-directories-first";
            ll = "eza --long --all --sort=modified --group-directories-first --header --smart-group --git --color=always --icons=always";
            tree = "eza --tree --all --icons=auto";

            "gc." = "git checkout .";
            gd = "git diff | bat --language diff";
            lg = "lazygit";
            gg = "lazygit";
            gs = "git status";

            vim = "nvim";
            v = "nvim";
            top = "btop";
          };
          shellInit = ''
            if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
              source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
            end
            if test -f /nix/var/nix/profiles/default/etc/profile.d/nix.fish
              source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
            end

            # Setup editor
            set -x EDITOR "nvim"

            # Setup Homebrew
            eval (/opt/homebrew/bin/brew shellenv)

            # Ensure Homebrew binaries are in PATH
            # fish_add_path /opt/homebrew/bin
            # fish_add_path /opt/homebrew/sbin

            fish_add_path ~/.local/bin

            # Ensure local binaries are in PATH
            # fish_add_path /usr/local/bin

            # Setup Java
            set -x JAVA_HOME "${pkgs.openjdk17}/libexec/openjdk"
            fish_add_path $JAVA_HOME/bin
          '';
          functions = {
            fish_greeting = lib.mkDefault "";
            bind_bang = ''
              switch (commandline -t)
              case "!"
                commandline -t $history[1]; commandline -f repaint
              case "*"
                commandline -i !
              end
            '';
            bind_dollar = ''
              switch (commandline -t)
              case "!"
                commandline -t ""
                commandline -f history-token-search-backward
              case "*"
                commandline -i '$'
              end
            '';
            fish_user_key_bindings = ''
              bind ! bind_bang
              bind '$' bind_dollar
            '';
            hf = ''
              eval (history | fzf -i)
            '';
            shell = ''
              nix-shell --packages $argv
            '';
          };
          plugins = [
            {
              name = "tide";
              src = pkgs.fetchFromGitHub {
                owner = "IlanCosman";
                repo = "tide";
                rev = "a34b0c2809f665e854d6813dd4b052c1b32a32b4";
                sha256 = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
              };
            }
            {
              name = "done";
              src = pkgs.fishPlugins.done.src;
            }
            {
              name = "bass";
              src = pkgs.fishPlugins.bass.src;
            }
          ];
        };

        zsh = {
          enable = true;
          autocd = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          shellAliases = {
            cd = "z";
            ".." = "cd ..";
            ls = "eza --oneline --all --group-directories-first";
            ll = "eza --long --all --sort=modified --group-directories-first --header --smart-group --time-style=relative --git --color=always --icons=always";
            lg = "lazygit";
            gs = "git status";
            vim = "nvim";
            v = "nvim";
          };

          plugins = [
            {
              name = "powerlevel10k";
              src = pkgs.zsh-powerlevel10k;
              file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
            {
              name = "powerlevel10k-config";
              src = lib.cleanSource ../../dotfiles/zsh;
              file = "p10k.zsh";
            }
          ];

          initExtraFirst = ''
            if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
              . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
              . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
            fi

            # Setup Homebrew
            # eval "$(/opt/homebrew/bin/brew shellenv)"

            # Ensure Homebrew binaries are in PATH
            # export PATH="/opt/homebrew/bin:$PATH"
            # export PATH="/opt/homebrew/sbin:$PATH"

            export EDITOR="vim"

            export JAVA_HOME="${pkgs.openjdk17}/libexec/openjdk";
            export PATH=$JAVA_HOME/bin:$PATH

            # direnv
            eval "$(direnv hook zsh)"

            # nix shortcuts
            shell() {
                nix-shell '<nixpkgs>' -A "$1"
            }

            # ---- Zoxide (better cd) ----
            eval "$(zoxide init zsh)"

            # Zsh arrow key bindings
            bindkey '^[[A' history-search-backward
            bindkey '^[[B' history-search-forward
          '';
        };

        git = {
          enable = true;
          ignores = ["*.swp"];
          userName = name;
          userEmail = email;
          lfs = {
            enable = true;
          };
          extraConfig = {
            init.defaultBranch = "main";
            core = {
              editor = "vim";
              autocrlf = "input";
            };
            pull.rebase = true;
            rebase.autoStash = true;
          };
        };

        vim = {
          enable = true;
          plugins = with pkgs.vimPlugins; [vim-airline vim-airline-themes vim-startify vim-tmux-navigator];
          settings = {ignorecase = true;};
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
            set backupdir=~/.config/vim/backups
            set directory=~/.config/vim/swap

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
              \ '~/.local/share/src',
              \ ]

            let g:airline_theme='bubblegum'
            let g:airline_powerline_fonts = 1
          '';
        };

        ssh = {
          enable = true;
          includes = [
            "/Users/${user}/.ssh/config_external"
          ];
          matchBlocks = {
            "github.com" = {
              identitiesOnly = true;
              identityFile = [
                "/Users/${user}/.ssh/id_github"
              ];
            };
          };
        };

        tmux = {
          enable = false;
          plugins = with pkgs.tmuxPlugins; [
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
              plugin = resurrect;
              extraConfig = ''
                set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
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
      };
    };
  };
}
