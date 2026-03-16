{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    networking = {
        hostName = "BAROS";
        networkmanager.enable = true;
    };

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

    services = {
        openssh = {
            enable = true;
            settings.PermitRootLogin = "yes";
        };
        xserver.xkb = {
            layout = "us";
        };
    };

    programs.bash.enable = false;

    users = {
        defaultUserShell = pkgs.nushell;
        users.six = {
            isNormalUser = true;
            description = "six";
            extraGroups = [ "networkmanager" "wheel" ];
        };
    };

    environment.systemPackages = with pkgs; [
        nushell
        neovim
        bash
        git
    ];

    nixpkgs.config.allowUnfree = true;

    system.nixos.label = "preface";
    system.stateVersion = "25.11";
}