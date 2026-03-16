{ config, pkgs, inputs, ... }:
let
    keydGen = inputs.axiom-keyd-gen.packages.${pkgs.system}.default;
    configString = pkgs.runCommand "axiom-keyd-gen" {} "${keydGen}/bin/SixSlime.AxiomKeydGen < ${./axioms/keyboard.toml} > $out";
{
    services.keyd = {
        enable = true;
        keyboards.default = {
            ids = ["*"];
            extraConfig = configString;
        };
    };
};