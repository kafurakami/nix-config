{
  pkgs,
  config,
  ...
}: {

  home.packages = with pkgs; [
    stremio
    netflix
    spotify
  ];

  programs.mpv = {
    enable = true;
    defaultProfiles = ["gpu-hq"];
  };
}
