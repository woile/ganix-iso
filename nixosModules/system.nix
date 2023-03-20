{ inputs, ganix, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  imports = [
    inputs.self.nixosModules.services
    inputs.self.nixosModules.user-root
  ];
  config = {
    system = {
      stateVersion = "22.11";
    };

    # Time
    time.timeZone = ganix.timezone;

    # Man
    documentation = {
      enable = true;
    };

    # System packages
    environment.systemPackages = with pkgs; [
      ntp
      avahi
      vim
      git
      wget
      starship
      lm_sensors
      jq
      docker-compose
      bat # cat
      exa # ls
      ripgrep # grep
      fd # find
      procs # ps
      sd # sed
      du-dust # du
      bandwhich
      xh # http
      macchina
    ];

    hardware = {
      # enableRedistributableFirmware = {
      #   _type = "override";
      #   content = false;
      #   priority = 50;
      # };
      enableRedistributableFirmware = true;
      firmware = [
        pkgs.raspberrypiWirelessFirmware
      ];

      bluetooth = {
        # package = pkgs.bluez;
        enable = false;
        powerOnBoot = false;
      };

    };

    networking = {
      hostName = ganix.hostname;
      useDHCP = true;
      firewall.enable = false;

      wireless = {
        enable = ganix.wifi_enabled;
        interfaces = [ "wlan0" ];
        networks = {
          "${ganix.wifi_network_name}" = {
            psk = "${ganix.wifi_network_psk}";
          };
        };

      };

      # Enable eth0 later
      # interfaces.eth0.useDHCP = true;
      # useDHCP = false;
    };

    sdImage.compressImage = false;

    # NixOS wants to enable GRUB by default
    boot.loader.grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    boot.loader.generic-extlinux-compatible.enable = true;

    boot.loader.raspberryPi = {
      # enable = true;
      version = ganix.raspberry_model;
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
    };

    # Nix
    nix = {
      package = pkgs.nixUnstable;
      extraOptions = "experimental-features = nix-command flakes";
    };

    nixpkgs.config = {
      allowUnfree = true;
    };

    # File systems configuration for using the installer's partition layout
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
    };

    # !!! Adding a swap file is optional, but strongly recommended!
    swapDevices = [{ device = "/swapfile"; size = 1024; }];

    # User settings
    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
