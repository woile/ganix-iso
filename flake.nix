{
  description = "Raspberry Pi with NixOS iso";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixos-generators, nixpkgs, ... }@inputs:
    let
      ganix = import ./loader/from_envs.nix;
      flakeContext = {
        inherit inputs;
        inherit ganix;
      };
    in
    {
      nixosModules = {
        system = import ./nixosModules/system.nix flakeContext;
        user-root = import ./nixosModules/user-root.nix flakeContext;
        services = import ./nixosModules/services.nix flakeContext;
      };
      packages = {
        aarch64-linux = {
          nixos = import ./packages/nixos.nix flakeContext;
        };
      };
    };
}
