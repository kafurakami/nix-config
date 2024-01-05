{
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    userName = "kafurakami";
    userEmail = "zoldyck1179@gmail.com";
  };
}
