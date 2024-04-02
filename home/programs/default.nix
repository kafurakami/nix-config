{ lib, config, pkgs, ... }: {
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
}
