{ 
  config, 
  pkgs,
  ...
}: {

  # For other home manager modules
  imports = [
    ./programs
    ./shell
  ];

  # Home Directory
  home = {
    username = "murphodinger";
    homeDirectory = "/home/murphodinger";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  # Enable home-manager
  programs.home-manager.enable = true;
}

