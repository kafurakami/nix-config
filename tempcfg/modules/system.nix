{
  pkgs,
  lib,
  ...
}: let
  username = "murphodinger";
in {

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.murphodinger = {
    isNormalUser = true;
    description = "murphodinger";
    initialPassword = "correcthorsebatterystaple";
    extraGroups = [ "wheel" ] # Enable 'sudo' for the user.
  };
  
  # Enable Flakes Globally, and set cache mirror
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

  substituters = [
    "https://cache.nixos.org"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Iosevka" "NerdFontsSymbolsOnly" ]; })
    jetbrains-mono
  ];

  # Enable sounds using Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Some default packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
    plymouth
    wget
    exfat
    keyd
    git
    curl
    ranger
  ];

  # Enable TLP
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        FastConnectable = "true";
	Experimental = "true";
      };
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      openssl
    ];
  };

  systemd.services.keyd = {
    description = "key remapping daemon";
    requires = [ "local-fs.target" ];
    after = [ "local-fs.target" ];
    wantedBy = [ "sysinit.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.keyd}/bin/keyd";
      # Restart = "on-failure";
    };
  };

  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [shift]

    [main]
    capslock = overload(control, esc)
    rightalt = -
  '';

  services.thermald.enable = false;

  services.power-profiles-daemon.enable = false;

  programs.dconf.enable = true;

}

