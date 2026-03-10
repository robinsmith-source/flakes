{ pkgs, ... }: {
  # ── Alacritty ────────────────────────────────────────────────────────────────
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding      = { x = 10; y = 8; };
        decorations  = "None";   # let niri/compositor draw the frame
        opacity      = 0.95;
        blur         = true;
        dynamic_title = true;
      };
      font = {
        normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        bold   = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
        italic = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
        size   = 12.0;
      };
      # Catppuccin Mocha colour scheme
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        normal = {
          black   = "#45475a";
          red     = "#f38ba8";
          green   = "#a6e3a1";
          yellow  = "#f9e2af";
          blue    = "#89b4fa";
          magenta = "#f5c2e7";
          cyan    = "#94e2d5";
          white   = "#bac2de";
        };
        bright = {
          black   = "#585b70";
          red     = "#f38ba8";
          green   = "#a6e3a1";
          yellow  = "#f9e2af";
          blue    = "#89b4fa";
          magenta = "#f5c2e7";
          cyan    = "#94e2d5";
          white   = "#a6adc8";
        };
        cursor = {
          cursor = "#f5e0dc";
          text   = "#1e1e2e";
        };
      };
      cursor.style = { shape = "Block"; blinking = "On"; };
      keyboard.bindings = [
        { key = "V"; mods = "Control|Shift"; action = "Paste"; }
        { key = "C"; mods = "Control|Shift"; action = "Copy"; }
        { key = "Plus";  mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Key0";  mods = "Control"; action = "ResetFontSize"; }
      ];
      scrolling.history = 10000;
      selection.save_to_clipboard = true;
    };
  };

  # ── Zsh (mirrors CachyOS default zsh setup) ─────────────────────────────────
  programs.zsh = {
    enable = true;
    enableCompletion    = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size       = 100000;
      save       = 100000;
      path       = "$HOME/.local/share/zsh/history";
      ignoreDups = true;
      share      = true;
      extended   = true;
    };

    initExtra = ''
      # Better completions
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'

      # History navigation with arrow keys
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey '^P'   history-substring-search-up
      bindkey '^N'   history-substring-search-down

      # Useful options (CachyOS defaults)
      setopt autocd
      setopt correct
      setopt globdots
      setopt extendedglob
      setopt nocaseglob
      setopt rcexpandparam
      setopt numericglobsort
      setopt nobeep

      # fzf-tab: use fzf for tab completion (if available)
      # source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';

    shellAliases = {
      # Modern replacements (same as CachyOS default)
      ls    = "eza --icons=always";
      ll    = "eza --icons=always -l --git";
      la    = "eza --icons=always -la --git";
      lt    = "eza --icons=always --tree --level=2";
      lta   = "eza --icons=always --tree --level=2 -a";
      cat   = "bat --pager=never";
      grep  = "grep --color=auto";
      diff  = "delta";
      du    = "dust";
      df    = "duf";

      # Git shortcuts
      g   = "git";
      gs  = "git status";
      ga  = "git add";
      gaa = "git add -A";
      gc  = "git commit -m";
      gp  = "git push";
      gpl = "git pull";
      gl  = "git log --oneline --graph --decorate --all";
      gd  = "git diff";
      gco = "git checkout";
      gcb = "git checkout -b";

      # NixOS shortcuts
      rebuild  = "sudo nixos-rebuild switch --flake .#$(hostname)";
      upgrade  = "nix flake update && sudo nixos-rebuild switch --flake .#$(hostname)";
      cleanup  = "sudo nix-collect-garbage -d && sudo nix store optimise";
      search   = "nix search nixpkgs";

      # Misc
      ".."  = "cd ..";
      "..." = "cd ../..";
      mkdir = "mkdir -pv";
      cp    = "cp -iv";
      mv    = "mv -iv";
      rm    = "rm -iv";
    };

    plugins = [
      {
        name = "zsh-history-substring-search";
        src  = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];
  };

  # ── Starship prompt ──────────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$os$username$hostname$directory$git_branch$git_status$nodejs$python$rust$golang$cmd_duration$line_break$character";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
        vimcmd_symbol  = "[❮](bold blue)";
      };
      os = {
        disabled = false;
        style    = "bold blue";
      };
      directory = {
        style              = "bold blue";
        truncate_to_repo   = true;
        truncation_length  = 3;
        truncation_symbol  = "…/";
      };
      git_branch = {
        style  = "bold purple";
        symbol = " ";
      };
      git_status = {
        style    = "bold red";
        ahead    = "⇡\${count}";
        behind   = "⇣\${count}";
        modified = "!";
        staged   = "+";
        untracked = "?";
      };
      nodejs = { symbol = " "; style = "bold green"; };
      python = { symbol = " "; style = "bold yellow"; };
      cmd_duration = {
        min_time = 2000;
        style    = "bold yellow";
      };
    };
  };

  # ── FZF (fuzzy finder) ───────────────────────────────────────────────────────
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--border rounded"
      "--layout reverse"
      "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
      "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
      "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    ];
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
  };

  # ── Zoxide (smarter cd) ──────────────────────────────────────────────────────
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];  # replace cd with zoxide
  };

  # ── Modern CLI tools ─────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    eza       # modern ls
    bat       # modern cat with syntax highlighting
    fd        # modern find
    ripgrep   # modern grep
    delta     # better git diffs
    dust      # intuitive disk usage
    duf       # better df
    bottom    # system monitor (btm)
    procs     # modern ps
    sd        # modern sed
    hyperfine # benchmarking
    tokei     # code statistics
  ];
}
