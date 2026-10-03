{ config, pkgs, inputs, lib, identity, ... }:
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
        command = lib.getExe config.programs.sway.package;
        user = identity.primaryUser;
      };
      default_session = initial_session;
    };
  };
}