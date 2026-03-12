# Home Manager security tools (Bitwarden desktop + CLI)
{ pkgs, ... }: {
  home.packages = with pkgs; [
    bitwarden-desktop
    bitwarden-cli
  ];
}
