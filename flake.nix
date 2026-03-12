{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # CachyOS kernel — LTS with BORE scheduler, performance patches + binary cache
    # Do NOT override its nixpkgs — kernel patches must match the pinned version.
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # Niri — scrollable-tiling Wayland compositor (NixOS/HM modules + binary cache)
    niri.url = "github:sodiboo/niri-flake";

    # Noctalia shell (Quickshell-based desktop shell for niri)
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, noctalia, ... }@inputs:
    let
      username = "robin";

      mkSystem = { hostname, system ? "x86_64-linux", extraModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = [
            home-manager.nixosModules.home-manager
            niri.nixosModules.niri
            ./hosts/${hostname}
            ./modules/nixos/common.nix
            ./modules/nixos/desktop
            ./modules/nixos/hardware/amd.nix
            {
              home-manager = {
                useGlobalPkgs   = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs username; };
                sharedModules = [
                  ({ osConfig, ... }: {
                    _module.args.hostName = osConfig.networking.hostName;
                  })
                ];
                users.${username} = {
                  imports = [
                    noctalia.homeModules.default
                    ./modules/home
                  ];
                };
              };
            }
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        laptop  = mkSystem { hostname = "laptop"; };
        desktop = mkSystem { hostname = "desktop"; };
      };
    };
}
