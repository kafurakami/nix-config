{ config, pkgs, lib, ... }: {

  programs.kitty.enable = true;
  programs.kitty.shellIntegration.enableZshIntegration = true;
  xdg.configFile."kitty/kitty.conf".source = ./kitty/kitty.conf;
  xdg.configFile."kitty/colors.conf".source = ./kitty/colors.conf;

}
