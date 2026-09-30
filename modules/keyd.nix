{ config, pkgs, inputs, ... }:
let
    keydPackage = pkgs.keyd
    keydGen = inputs.axiom-keyd-gen.packages.${pkgs.stdenv.hostPlatform.system}.default;
    generatedFile = pkgs.runCommand "axiom-keyd-gen" {} "${keydGen}/bin/SixSlime.AxiomKeydGen < ${../axioms/keyboard.toml} > $out";
in
{
    # so 'keyd' command is available.
    environment.systemPackages = [
        keydPackage
    ];
    services.keyd = {
        enable = true;
        package = pkgs.keyd;
        keyboards.default = {
            ids = ["*"];
            extraConfig = builtins.readFile generatedFile;
        };
    };
}