{ config, pkgs, inputs, ... }:

{
    networking.networkmanager.enable = true;

    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
      };
    };

    programs.ssh = {
      startAgent = true;
    };
}