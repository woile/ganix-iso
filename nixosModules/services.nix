/** Include services and programs configuration */
{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    services = {
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
        home = "/media/media-store/media-center/transmission/";
      };

      avahi = {
        enable = true;
        nssmdns = true;
        publish.enable = true;
        publish.addresses = true;
        publish.workstation = true;
      };

      # media server

      jellyfin = {
        enable = true;
        openFirewall = true;
        group = "media";
      };

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

      ntp.enable = true;
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
