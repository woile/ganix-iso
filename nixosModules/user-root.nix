{ inputs, ganix, ... }@flakeContext:
{ config, lib, pkgs, ... }:
let
  ssh_pub_files = lib.filterAttrs (k: v: v == "regular" && lib.hasSuffix ".pub" k) (builtins.readDir ../authorized_keys);
in
{
  config = {
    users = {
      users = {
        "${ganix.username}" = {
          isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" ];
          openssh.authorizedKeys.keys = lib.mapAttrsToList (k: v: builtins.readFile "${../authorized_keys}/${k}") ssh_pub_files;
        };
      };
    };
  };
}
