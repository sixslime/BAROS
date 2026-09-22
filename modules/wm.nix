{ config, pkgs, inputs, ... }:

{
  services.displayManager.lemurs = {
    enable = true;
    settings = {

    };
  };
  programs.wayland.miracle-wm = {
    enable = true;
  };
}