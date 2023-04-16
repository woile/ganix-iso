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

      # keychron fix (?)
      extraModprobeConfig = ''
        options hid_apple fnmode=0
      '';

      supportedFilesystems = [ "ntfs" ];

    };
    # Time
    time.timeZone = ganix.timezone;

    # Man
    documentation = {
      enable = false;  # save space
    };

    # System packages
    environment.systemPackages = with pkgs; [
      libraspberrypi
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
            pskRaw = "${ganix.wifi_network_psk}";
          };
        };

      };

      # Enable eth0 later
      # interfaces.eth0.useDHCP = true;
      # useDHCP = false;
    };

    sdImage.compressImage = false;
    sdImage.imageName = "${config.sdImage.imageBaseName}-${ganix.hostname}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.img";

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
      "/media/media-store" = {
        device = "/dev/sda2";
        fsType = "exfat";
        options = [
          "defaults"
          "gid=media"  # for non-root access
          "dmask=007"
          "fmask=117"  # not having everything be executable
      ];

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
