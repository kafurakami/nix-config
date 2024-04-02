{ 
  inputs,
  lib,
  outputs,
  config,
  pkgs,
  ...
}: {

  # For other home manager modules
  imports = [
    ./hyprland
  ];
  
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];

    config = {
      # For unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Home Directory
  home = {
    username = "murphodinger";
    homeDirectory = "/home/murphodinger";
  };

  home.packages = with pkgs; [
  # Utilites
  gparted
  steam-run
  libsForQt5.yakuake
  libsForQt5.gwenview
  mpv
  qbittorrent
  galaxy-buds-client
  unstable.appimage-run

  # CLI utilites
  curl
  fzf
  lsd
  btop
  ripgrep
  aria2
  ranger
  glibc
  nixpkgs-fmt
  gcc13
  libgccjit
  libwebp
  wl-clipboard

  # VPN
  cloudflare-warp
  mullvad-vpn

  # Editors
  vscode

  # Gaming
  bottles
  lutris
  cemu
  unstable.ryujinx
  protonup-qt
  discord
  winetricks
  wineWowPackages.stable
  steam

  # Browsers
  firefox
  brave

  # Entertainment
  stremio
  netflix
  spotify

  # Fonts
  # (nerdfonts.override { fonts = [ "Iosevka" "NerdFontsSymbolsOnly" ]; })
  # jetbrains-mono

  ];
    
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    # EDITOR = "emacs";
  };

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # ZSH Config
  programs.zsh = {
  enable = true;

  shellAliases = {
    ls = "lsd";
    ll = "lsd -l";
  };

  plugins = [
    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
      owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.7.0";
        sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
      };
    }
  ];

  initExtra = ''
    source $HOME/.p10k.zsh
    eval "$(direnv hook zsh)"
  '';
  
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "fzf" "direnv" ]; 
    custom = "$HOME/.omz-custom/";
    theme = "powerlevel10k/powerlevel10k";
  };

  syntaxHighlighting.enable = true; 
  enableAutosuggestions = true;
  };

  # Kitty Config
  programs.kitty.enable = true;
  #programs.kitty.shellIntegration.enableFishIntegration = true;
  programs.kitty.shellIntegration.enableZshIntegration = true;
  xdg.configFile."kitty/kitty.conf".source = ./kitty/kitty.conf;
  xdg.configFile."kitty/colors.conf".source = ./kitty/colors.conf;

  # LSD Config
  xdg.configFile."lsd/config.yaml".source = ./lsd/config.yaml;

  # Direnv Config
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
