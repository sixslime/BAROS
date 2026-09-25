{ config, pkgs, inputs, identity, ... }:

{
    users = {
        defaultUserShell = pkgs.nushell;
        users = {
            ${identity.primaryUser} = {
                isNormalUser = true;
                description = "${identity.primaryUser}";
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