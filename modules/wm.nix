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

  services.displayManager = {
    enable = true;
    autoLogin = {
      enable = true;
      user = identity.primaryUser;
    }
  }
}