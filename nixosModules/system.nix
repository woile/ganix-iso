{ inputs, ganix, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  imports = [
    inputs.self.nixosModules.services
    inputs.self.nixosModules.user-root
  ];
  config = {
    system = {
      stateVersion = "23.05";
    };

    boot = {
      kernelParams = ["cma=256M"];

      # !!! Otherwise (even if you have a Raspberry Pi 2 or 3), pick this:
      # kernelPackages = pkgs.linux_rpi3;

      # Cleanup tmp on startup
      cleanTmpDir = true;

      loader = {
        # NixOS wants to enable GRUB by default
        grub.enable = false;
        # raspberryPi.enable = true;
        raspberryPi.version = ganix.raspberry_model;
        generic-extlinux-compatible.enable = true;
        # generic-extlinux-compatible.populateCmd = lib.mkForce {};
      };
    };
    # Time
    time.timeZone = ganix.timezone;

    # Man
    documentation = {
      enable = false;  # save space
    };

    # System packages
    environment.systemPackages = with pkgs; [
      # libraspberrypi
      # ntp
      vim
      git
      wget
      jq
      docker-compose
      # bat # cat
      # exa # ls
      # ripgrep # grep
      # fd # find
      # procs # ps
      # sd # sed
      # du-dust # du
      # bandwhich
      # xh # http
      # macchina
    ];

    hardware = {
      # enableRedistributableFirmware = {
      #   _type = "override";
      #   content = false;
      #   priority = 50;
      # };

      # see https://github.com/NixOS/nixpkgs/issues/115652#issuecomment-1033489751
      enableRedistributableFirmware = true;
      firmware = [
        pkgs.firmwareLinuxNonfree
        pkgs.wireless-regdb
      ];

      bluetooth = {
        # package = pkgs.bluez;
        enable = false;
        powerOnBoot = false;
      };

    };

    networking = {
      hostName = ganix.hostname;
      firewall.enable = false;
      interfaces.wlan0 = {
        useDHCP = true;
        # ipv4.addresses = [{
        #   # I used static IP over WLAN because I want to use it as local DNS resolver
        #   address = "192.168.100.4";
        #   prefixLength = 24;
        # }];
      };

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

    # boot.loader.grub.enable = false;
    # # Enables the generation of /boot/extlinux/extlinux.conf
    # # boot.loader.generic-extlinux-compatible = lib.mkDefault {enable = false; populateCmd = "";};
    # # boot.loader.generic-extlinux-compatible.enable = lib.mkForce false;
    # # boot.loader.generic-extlinux-compatible.populateCmd = lib.mkForce "";
    # boot.loader.raspberryPi = {
    #   enable = true;
    #   version = ganix.raspberry_model;
    # };


    i18n = {
      defaultLocale = "en_US.UTF-8";
    };

    # Nix
    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
      '';
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
