{ config, pkgs, inputs, ... }:
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

  systemd.services.display-manager = {
    description = "Lemurs";
    unitConfig = {
      Wants = [ "systemd-user-sessions.service" ];
      After = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
      ];
    };
    serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      TTYPath = "/dev/tty1";
      TTYReset = "yes";
      TTYVHangup = "yes";
      # clear the console before starting:
      TTYVTDisallocate = true;
    };
    # don't kill a user session when using nixos-rebuild:
    restartIfChanged = false;
  };

  environment.etc."lemurs/wayland/miracle-wm" = {
    text = ''
      #!/bin/sh
      exec dbus-run-session miracle-wm
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