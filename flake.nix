{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # CachyOS kernel + packages (chaotic-nyx overlay)
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Neovim configured declaratively
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs = { self, nixpkgs, home-manager, chaotic, nixvim, noctalia, ... }@inputs:
    let
      # !! Change to your username !!
      username = "robin";

      mkSystem = { hostname, system ? "x86_64-linux", extraModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = [
            chaotic.nixosModules.default
            home-manager.nixosModules.home-manager
            noctalia.nixosModules.default
            ./hosts/${hostname}
            ./modules/nixos/common.nix
            ./modules/nixos/cachyos.nix
            ./modules/nixos/desktop
            ./modules/nixos/hardware/amd.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                # Append ".backup" instead of failing when a file already exists.
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs username; };
                users.${username} = {
                  imports = [
                    nixvim.homeManagerModules.nixvim
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
