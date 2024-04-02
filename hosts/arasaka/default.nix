{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system.nix
    ./hardware-configuration.nix
  ];


  networking.hostName = "arasaka"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  environment.systemPackages = with pkgs; [
    neovim
    plymouth
    wget
    exfat
    pciutils
    keyd
    git
    curl
    asusctl
    unstable.supergfxctl
  ];

  # Plymouth
  boot.loader.systemd-boot.enable = true;
  boot.consoleLogLevel = 2;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";

  # Setting up Keyd config
  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [shift]

    [main]
    capslock = overload(control, esc)
    rightalt = -
  '';

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # AMD GPU
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
