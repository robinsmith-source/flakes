# NixOS Steam module (import by device, not Home Manager)
{ config, lib, ... }:
let
  cfg = config.workstation.gaming;
in
{
  options.workstation.gaming.enable = lib.mkEnableOption "Steam and gaming";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
