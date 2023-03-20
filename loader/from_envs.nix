let
  pkgs = import <nixpkgs> {};
  ganix = import ../ganix.nix;
  getOrElse = x: d: if x == "" then d else x;
  getOrElseNull = x: d: if x == null then d else x;

  # variables
  hostname_env = builtins.getEnv "INPUT_HOSTNAME";
  hostname_default = "rpi_holden";
  hostname = getOrElse hostname_env hostname_default;

  username_env = builtins.getEnv "INPUT_USERNAME";
  username_default = "woile";
  username = getOrElse username_env username_default;

  timezone_env = builtins.getEnv "INPUT_TIME_ZONE";
  timezone_default = "Europe/Amsterdam";
  timezone = getOrElse timezone_env timezone_default;

  raspberry_model_env = builtins.getEnv "INPUT_RASPBERRY_MODEL";
  raspberry_model_default = "3";
  raspberry_model = pkgs.lib.strings.toInt (getOrElse raspberry_model_env raspberry_model_default);

  ssh_key_name_env = builtins.getEnv "INPUT_SSH_KEY_NAME";
  ssh_key_name_default = null;
  ssh_key_name = getOrElse ssh_key_name_env ssh_key_name_default;

  ssh_key_env = builtins.getEnv "INPUT_SSH_KEY";
  ssh_key_default = null;
  ssh_key = getOrElse ssh_key_env ssh_key_default;

  wifi_enabled_env = builtins.getEnv "INPUT_WIFI_ENABLED";
  wifi_enabled_default = true;
  wifi_enabled = wifi_enabled_default; # TODO: convert str to bool

  wifi_network_name_env = builtins.getEnv "INPUT_WIFI_NETWORK_NAME";
  wifi_network_name_default = "";
  wifi_network_name = getOrElse wifi_network_name_env wifi_network_name_default;

  wifi_network_psk_env = builtins.getEnv "INPUT_WIFI_NETWORK_PSK";
  wifi_network_psk_default = "";
  wifi_network_psk = getOrElse wifi_network_psk_env wifi_network_psk_default;

 in {
  hostname = getOrElseNull ganix.hostname hostname;
  username = getOrElseNull ganix.username username;
  timezone = getOrElseNull ganix.timezone timezone;
  raspberry_model = getOrElseNull ganix.raspberry_model raspberry_model;
  ssh_key_name = getOrElseNull ganix.ssh_key_name ssh_key_name;
  ssh_key = getOrElseNull ganix.ssh_key ssh_key;
  wifi_enabled = getOrElseNull ganix.wifi_enabled wifi_enabled;
  wifi_network_name = getOrElseNull ganix.wifi_network_name wifi_network_name;
  wifi_network_psk = getOrElseNull ganix.wifi_network_psk wifi_network_psk;
 }