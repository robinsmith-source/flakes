{ config, lib, pkgs, ... }:
let
  cfg = config.workstation.baseline.packages;
in
{
  options.workstation.baseline.packages = {
    tools = lib.mkEnableOption "CLI tools and utilities";
    dev = lib.mkEnableOption "Development tools";
    apps = lib.mkEnableOption "Desktop applications";
  };

  config = {
    environment.systemPackages =
      (lib.optionals cfg.tools (with pkgs; [
        git
        curl
        wget
        htop
        tree
        eza
        bat
        ffmpeg
        nixfmt
        file
        pamixer
        tailscale
        unzip
        bluez
      ]))
      ++ (lib.optionals cfg.dev (with pkgs; [
        gcc
        terraform
        vscode
      ]))
      ++ (lib.optionals cfg.apps (with pkgs; [
        google-chrome
        nautilus
        discord
        spotify
        obsidian
        pavucontrol
        libsForQt5.qt5ct
        rose-pine-cursor
        papirus-icon-theme
        adw-gtk3
        adwaita-icon-theme
      ]));
  };
}
