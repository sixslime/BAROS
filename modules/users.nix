{ config, pkgs, inputs, ... }:

{
    users = {
        defaultUserShell = pkgs.nushell;
        users = {
            six = {
                isNormalUser = true;
                description = "six";
                extraGroups = [ "networkmanager" "wheel" "seat" ];
                password = "the";
            };
        };
        users.root = {
            password = "the";
        };
    };
    
    security.sudo = {
        enable = true;
        wheelNeedsPassword = false;
    };
}