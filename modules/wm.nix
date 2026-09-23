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
      Wants = [ "systemd-user-sessions.service" ];
      After = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
        "getty@tty2.service"
      ];
    };
    serviceConfig = {
      ExecStart="${lib.getExe' pkgs.lemurs "lemurs"}";
      Type = "idle";
      StandardInput = "tty";
      TTYPath = "/dev/tty2";
      TTYReset = "yes";
      TTYVHangup = "yes";
      # clear the console before starting:
      TTYVTDisallocate = true;
    };
    # don't kill a user session when using nixos-rebuild:
    restartIfChanged = false;
    aliases = [ "display-manager.service" ];
  };

  environment.etc."lemurs/wayland/miracle" = {
    text = ''
      #!/bin/sh
      exec ${lib.getExe' services.dbus.dubsPackage "dbus-run-session"} ${lib.getExe' pkgs.miracle-wm "miracle-wm"}
    '';
    mode = "0755";
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
}