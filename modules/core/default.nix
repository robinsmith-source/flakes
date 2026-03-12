# Core NixOS modules: baseline, packages, niri, virtualization, security
{ ... }: {
  imports = [
    ./baseline.nix
    ./niri.nix
    ./virtualization.nix
    #../programs/security
  ];
}
