# Media PC config
{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../../vars
    ./hardware-configuration.nix

    ../../common/users/default-user.nix

    ../../../modules/nixos/common
    ../../../modules/nixos/optional/bootloader.nix
    ../../../modules/nixos/optional/pipewire.nix
    ../../../modules/nixos/optional/steam.nix
    ../../../modules/users
  ];

  users.io.enable = true;
  users.mantissa.enable = true;

  # install openrgb as root
  services.hardware.openrgb.enable = true;

  environment.systemPackages = with pkgs; [
    alejandra
    flex-launcher
    freetube
    jellyfin-media-player
    kitty
    moonlight-qt
    neovim
    # openrgb
    librewolf
    mpv
    vlc
    zsh
  ];

  services.xserver.enable = true; # optional
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kup = {
    isNormalUser = true;
    description = "Lavendel";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGojf3bWewBs4X1C8l8xG2DQZD3jcCGoB02NPt3J/ztM"
    ];
  };

  # TODO - Testing with Intel Arc

  #  nixpkgs.config.packageOverrides = pkgs: {
  #    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  #  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      libvdpau-va-gl
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  system.stateVersion = "25.11";
}
