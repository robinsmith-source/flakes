{ pkgs, ... }: {
  home.packages = with pkgs; [
    # ── Node.js ────────────────────────────────────────────────────────────
    nodejs          # LTS Node.js (nixpkgs tracks an LTS release)
    # corepack ships with Node.js; enable pnpm with:  corepack enable pnpm
    # pnpm is then managed per-project via packageManager field in package.json
    corepack        # Manages pnpm / yarn versions declared in package.json

    # ── Python ─────────────────────────────────────────────────────────────
    python3         # Python 3 interpreter
    uv              # Extremely fast Python package/project manager

    # ── GitHub CLI ─────────────────────────────────────────────────────────
    gh

    # ── Build / misc dev tools ─────────────────────────────────────────────
    gnumake
    gcc
    pkg-config

    # ── Container / compose ────────────────────────────────────────────────
    docker-compose

    # ── Data tools ─────────────────────────────────────────────────────────
    jq
    yq-go

    # ── HTTP ───────────────────────────────────────────────────────────────
    httpie
    curl
  ];

  # ── Git ────────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    # !! Fill in your details !!
    userName  = "Your Name";
    userEmail = "your@email.com";

    delta = {
      enable = true;
      options = {
        navigate    = true;
        light       = false;
        line-numbers = true;
        syntax-theme = "Catppuccin-mocha";
      };
    };

    extraConfig = {
      init.defaultBranch  = "main";
      push.autoSetupRemote = true;
      pull.rebase         = true;
      merge.conflictstyle = "zdiff3";
      diff.algorithm      = "histogram";
      rebase.autostash    = true;
      rebase.autosquash   = true;
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv"
      ".env.local"
    ];
  };

  # ── Direnv (auto-load .envrc / flake dev shells) ───────────────────────────
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
