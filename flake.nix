{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, noctalia, ... }@inputs:
    let
      system   = "x86_64-linux";
      username = "robin";

      mkWorkstation = { deviceModule, hmImports }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = [
            deviceModule
            home-manager.nixosModules.home-manager
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
                users.${username}.imports = hmImports;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        laptop = mkWorkstation {
          deviceModule = ./devices/laptop;
          hmImports = [
            noctalia.homeModules.default
            ./home/common.nix
            ./home/fish.nix
            ./home/niri.nix
          ];
        };

        desktop = mkWorkstation {
          deviceModule = ./devices/desktop;
          hmImports = [
            noctalia.homeModules.default
            ./home/common.nix
            ./home/fish.nix
            ./home/niri.nix
          ];
        };
      };
    };
}
