{ config, pkgs, inputs, lib, identity, ... }:
# lets just fist ourselves.
# aint never use no lemurs and miracle-wm. actually, aint never use no miracle-wm.
# just fucking using sway with no login bro idc.
{
  programs.sway = {
    enable = true;
    extraPackages = (with pkgs; [
      brightnessctl
      pulseaudio
      grim
      swayidle
      swaybg
      alacritty
    ]);
    extraOptions = [
      "--unsupported-gpu"
    ];
  };

  services.greetd = {
    enable = true;
    restart = true;
    settings = rec {
      initial_session = {
        command = lib.getExe' pkgs.sway "sway";
        user = identity.primaryUser;
      };
      default_session = initial_session;
    };
  };
}