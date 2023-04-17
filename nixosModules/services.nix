/** Include services and programs configuration */
{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    services = {
      ntp.enable = true;

      openssh = {
        enable = true;
        openFirewall = true;
        settings.PermitRootLogin = "yes";
        settings.PasswordAuthentication = false;
      };

      transmission = {
        enable = true;
        openFirewall = true;
        group = "media";
        settings = {
          download-dir = "/media/media-store/media-center/transmission/download";
          incomplete-dir = "/media/media-store/media-center/transmission/.incomplete";
        };
      };

      avahi = {
        enable = true;
        nssmdns = true;
        publish.enable = true;
        publish.addresses = true;
        publish.workstation = true;
      };

      # media server
      prowlarr = {
        enable = true;
        openFirewall = true;
      };

      radarr = {
        enable = true;
        openFirewall = true;
        group = "media";
      };

      sonarr = {
        enable = true;
        openFirewall = true;
        group = "media";
      };

      jellyfin = {
        enable = true;
        openFirewall = true;
        group = "media";
      };
    };

    programs = {
      starship = {
        enable = true;
      };
      bash.shellAliases = {
        df = "df -h";
        ".." = "cd ..";
        cat = "bat --style=plain -P";
        # ls = "exa --color=auto";
        # du = "dust -b";
        # neofetch = "macchina";
      };
    };

    # add docker
    virtualisation.docker.enable = true;
  };
}
