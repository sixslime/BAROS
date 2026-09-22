{ ... }:

{
  imports = [
      ./system.nix
      ./networking.nix
      ./users.nix
      ./keyd.nix
      ./filesystem.nix
  ];
}