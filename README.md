# NixOS dotfiles

Shared NixOS and Home Manager configuration with Niri, Hyprland, Noctalia
and Stylix. Machine-specific settings live in separate flakes that import
this repository.

Supports `x86_64-linux`. Uses systemd-boot/UEFI by default.

## Setup

On an existing NixOS installation, run as your normal user:

```sh
nix --extra-experimental-features 'nix-command flakes' run \
  'github:kamenkremen/dotfiles?ref=reusable-config#init-machine'
```

Creates `~/nixos-configs/<hostname>` with your current hostname and user,
copies `/etc/nixos/hardware-configuration.nix`, and prompts for the existing
NixOS and Home Manager state versions. Prints build and activation commands
when finished. Pass `-- --help` for options.

## Machine configuration

In the generated directory:

- `machine.nix` — hostname, user, state versions and module imports.
- `system.nix` — machine-specific NixOS settings, including bootloader and disks.
- `home.nix` — machine-specific Home Manager settings.

The [machine template](templates/machine) uses [lib.mkHost](lib/mk-host.nix)
to expose the configuration as `nixosConfigurations.local`.

## Updates

From your machine's configuration directory:

```sh
nix flake update dotfiles --flake path:.
sudo nixos-rebuild switch --flake 'path:.#local'
```

The configured Zsh provides `update` to rebuild without updating dependencies.
It uses `~/nixos-configs/<hostname>` or the directory set in `NIXOS_CONFIG_DIR`.
