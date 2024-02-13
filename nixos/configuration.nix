# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ 
  inputs,
  lib,
  outputs,
  config, 
  pkgs, 
  ... 
}: {
  imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];
  
    config = {
      allowUnfree = true;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
  ];

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix comamnds consistent as well!
  # nix.nixPath = ["/etc/nix/path"];
  # environment.etc = 
  #   lib.mapAttrs'
  #   (name: value: {
  #     name = "nix/path/${name}";
  #     value.source = value.flake;
  #   })
  #   config.nix.registry;



  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.consoleLogLevel = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";

  networking.hostName = "arasaka"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    
    extraPackages = with pkgs; [
    	vaapiVdpau
	libvdpau-va-gl
    ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  services.thermald.enable = false;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        FastConnectable = "true";
        Experimental = "true";
      };
    };
  };

  services.power-profiles-daemon.enable = true;
  systemd.services.power-profiles-daemon = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };

  #services.tlp = {
  #  enable = true;
  #  settings = {
  #    CPU_BOOST_ON_AC = 1;
  #    CPU_BOOST_ON_BAT = 0;
  #    CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #  };
  #};

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # AMD GPU
   services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  
  # environment.plasma5.excludePackages = with pkgs.libsForQt5; [
  #   elisa
  #   gwenview
  #   kate
  #   khelpcenter
  #   plasma-browser-integration
  #   print-manager
  # ];

  programs.dconf.enable = true;


  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Iosevka" "NerdFontsSymbolsOnly" ]; })
    jetbrains-mono
  ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.murphodinger = {
    isNormalUser = true;
    initialPassword = "correcthorsebatterystaple";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # services.supergfxd = {
  #  enable = true;
  # };

  # systemd.services.supergfxd.path = [ pkgs.pciutils ];

  # services.asusd.enable = true;
  # services.asusd.enableUserService = true;
  
  # services = {
  #   asusd = {
  #     enable = true;
  #     enableUserService = true;
  #   };
  # };

  # Hyprland
  # programs.hyprland = {
  #  enable = true;
  #  xwayland.enable = true;
  # };

  # Keyd
  # Create systemd service
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

  # Setting up Keyd config
  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [shift]

    [main]
    capslock = overload(control, esc)
    rightalt = -
  '';

  services.openvpn.servers = {
     arasaka = { config = '' config /home/murphodinger/.vpn/arasaka.ovpn ''; autoStart = false; updateResolvConf = true; };
  };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

