{
  description = "BAROS nixos configuration flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    axiom-keyd-gen = {
      url = "github:sixslime/BAROS.axiom-keyd-gen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "";
    };
  };
  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations.BAROS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # TODO: use builtins.fromTOML to parse our cool configs, then pass via specialArgs.
      specialArgs = { inherit inputs; };
      modules = [
        ./modules
        ./hardware-configuration.nix
      ];
    };
  };
}