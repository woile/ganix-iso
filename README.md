# Ganix ISO

> Build custom ISO images for Nix using github actions

## Goals

Easy to create, custom ISO images for [NixOS](https://nixos.org/) starting with raspberry pi.

The idea is to create a simple ISO image with some presets, then use something like
[deploy-rs](https://github.com/serokell/deploy-rs) to update the raspis.

## Usage

1. Fork this repo
2. Go to the github actions section
3. Trigger the workflow with the inputs you want to customize
4. Wait
5. Download the ISO

When you fork the repo, you can custommize the `ganix.nix` file, and you won't need to provide
the env variables for the github action

## TODO

- [x] Design template system
- [ ] Create flake derivation (?) to load SSH keys from env vars

## Development

### Check all is good

```sh
nix flake check
```

### Build

Supported arch `aarch64-linux`

```sh
nix build
```

### Burning image to SD-card

1. Plug USB.
2. Find out USB's location. On Mac use `diskutil list` (output e.g: `/dev/disk2`)
3. Burn the ISO to the USB

```sh
ISO_IMAGE="ISO_URL_HOSTED_ON_GITHUB"
curl -L "$ISO_IMAGE" | sudo dd of=/dev/disk2 bs=1m
```
