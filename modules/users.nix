{ config, pkgs, inputs, identity, lib, ... }:

{
    users.users = {
        ${identity.primaryUser} = {
            isNormalUser = true;
            description = "${identity.primaryUser}";
            extraGroups = [ "networkmanager" "wheel" "seat" ];
            password = "the";
        };
        root = {
            password = "the";
        };
    };

    security.sudo = {
        enable = true;
        wheelNeedsPassword = false;
    };

    # sets interactive shells to nushell:
    programs.bash.interactiveShellInit = ''
      if [[ $(< /proc/$PPID/comm) != nu && -z $BASH_EXECUTION_STRING ]]; then
        shopt -q login_shell && LOGIN_OPTION=--login || LOGIN_OPTION=
        exec ${lib.getExe pkgs.nushell} $LOGIN_OPTION
      fi
    '';
}