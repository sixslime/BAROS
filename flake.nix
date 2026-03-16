{
  description = "BAROS nixos configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    axiom-keyd-gen = {
      url = "github:sixslime/BAROS.axiom-keyd-gen";
      inputs.nixpkgs.follows = "nixpkgs";
    }
  };
  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations.BAROS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # TODO: use builtins.fromTOML to parse our cool configs, then pass via specialArgs.
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./keyd.nix
      ]
    };
  };
}