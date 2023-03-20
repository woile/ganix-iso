{ inputs, ... }@flakeContext:
let
  nixosModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.self.nixosModules.system
    ];
  };
in
inputs.nixos-generators.nixosGenerate {
  system = "aarch64-linux";
  format = "sd-aarch64";
  modules = [
    nixosModule
  ];
}
