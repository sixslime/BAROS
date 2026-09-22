{ config, pkgs, inputs, ... }:

{
    networking.hostName = "BAROS";
    system = {
      nixos = {
        label = "BAROS";
        tags = ["preface"];
      };
      stateVersion = "25.11";
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    time.timeZone = "America/Los_Angeles";

    i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LC_ADDRESS        = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT    = "en_US.UTF-8";
            LC_MONETARY       = "en_US.UTF-8";
            LC_NAME           = "en_US.UTF-8";
            LC_NUMERIC        = "en_US.UTF-8";
            LC_PAPER          = "en_US.UTF-8";
            LC_TELEPHONE      = "en_US.UTF-8";
            LC_TIME           = "en_US.UTF-8";
        };
    };

    console.keyMap = "us";
    services.xserver.xkb.layout = "us";

    programs.bash.enable = false;

    environment.systemPackages = (with pkgs; [
      nushell
      neovim
      bash
      git
    ]);

    nixpkgs.config.allowUnfree = true;
}