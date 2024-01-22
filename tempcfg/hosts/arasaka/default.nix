{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system.nix
    ./hardware-configuration.nix
  ];

  # Set boot config
  boot = {
    # Setting systemd as bootloader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Enable Plymouth
    plymouth.enable = true;
    plymouth.theme = "bgrt";

    # Don't display ACPI "errors"
    consoleLogLevel = 3;
  };

  services.xserver.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Networking Options
  networking = {
    hostName = "arasaka";
    networkmanager.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
