{ config, pkgs, inputs, ... }:
let
    keydGen = inputs.axiom-keyd-gen.packages.${pkgs.system}.default;
    generatedFile = pkgs.runCommand "axiom-keyd-gen" {} "${keydGen}/bin/SixSlime.AxiomKeydGen < ${./axioms/keyboard.toml} > $out";
in
{
    services.keyd = {
        enable = true;
        keyboards.default = {
            ids = ["*"];
            extraConfig = builtins.readFile generatedFile;
        };
    };
}