{ config, pkgs, inputs, lib, ... }:
# lets just fist ourselves.
# this is me re-implementing 'services.displayManagers.lemurs' and 'programs.wayland.miracle-wm' if they sucked.
{
  environment.systemPackages = (with pkgs; [
    lemurs
    miracle-wm
  ]);

  # -- LEMURS --
  security.pam.services.lemurs = {
    unixAuth = true;
    startSession = true;
    setLoginUid = false;
    #enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
  };

  services = {
    dbus.packages = [
      pkgs.lemurs
    ];
    seatd.enable = true;
    xserver.display = null;
  };

  systemd.services.lemurs = {
    unitConfig = {
      Description = "Lemurs";
      Wants = [
        "systemd-user-sessions.service"
      ];
      After = [
        "systemd-logind.service"
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
        "getty@tty2.service"
      ];
      # Conflicts = [
      #   "getty@tty2.service"
      # ];
    };
    serviceConfig = {
      ExecStart = "${lib.getExe' pkgs.lemurs "lemurs"}";
      Type = "idle";
      StandardInput = "tty";
      TTYPath = "/dev/tty2";
      TTYReset = "yes";
      TTYVHangup = "yes";
      TTYVTDisallocate = true;
    };
    restartIfChanged = false;
    aliases = [ "display-manager.service" ];
  };

  environment.etc = {
    "lemurs/wayland/miracle" = {
      text = ''
        #!/bin/sh
        exec ${lib.getExe' pkgs.miracle-wm "miracle-wm-session"};
      '';
      mode = "0755";
    };
    "lemurs/config.toml" = {
      text= ''
        tty = 2
        system_shell = "${lib.getExe' pkgs.bash "bash"}"
        initial_path = "/run/current-system/sw/bin"
        include_tty_shell = false
        shell_login_flag = "short"

        [wayland]
        scripts_path = "/etc/lemurs/wayland"
      '';
    };
  };

  # -- MIRACLE WM --
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  programs.dconf.enable = true;
  programs.xwayland.enable = true;
  services.graphical-desktop.enable = true;
  xdg.portal = {
    wlr.enable = false;
    extraPortals = [ ];
  };
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  services.xserver.enable = true;
}