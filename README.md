Jonathan McElroy's NixOS configuration
======

This repository is to store my configuration-as-code for all my machines. It uses nix flakes to manage the configuration. The configuration is stored in the `flake.nix` file.

Usage
-----

In all the following commands, `$hostname` is optional and will default to the current host's hostname if not provided.

To test a host's configuration on the current host, run `test-deploy-local` in the repo:
```bash
nix run .#test-deploy-local $hostname
```
If the host is rebooted, the configuration will be reverted to the last deployed configuration.

To deploy a host's configuration to the current host, run `deploy-local` in the repo:
```bash
nix run .#deploy-local $hostname
```

To test a host's configuration on a host via ssh, run the following command:
```bash
nix run .#test-deploy $hostname
```
If the host is rebooted, the configuration will be reverted to the last deployed configuration.

To deploy a host's configuration to a host via ssh, run the following command:
```bash
nix run .#deploy $server
```

To explore the configuration, run the following command:
```bash
nix repl
```
followed by:
```
nix-repl> :lf .
nix-repl> nixosConfigurations.earth.config.systemd.network.networks
{
    "10-lan" = { ... };
}
```

Architecture
------------

All the hosts are listed in the catalog/nodes.nix file (taking inspiration from [this repo](https://github.com/jhillyerd/homelab)), pointing at the appropriate config files. 

Each machine's software configuration is stored in `hosts/{hostname}.nix`. Each machine's hardware configuration is stored in `hw/{hostname}.nix`

The split enables VM testing by invoking the software configuration alone and ensuring that we can at least boot and ssh in.

Hardware configuration should be as minimal as possible to ensure that as much is tested as possible.

All the global services are stored in catalog/services.nix, so each machine knows where each service is located. Each host looked at the configuration to determine which services to enable.

All custom modules are stored in `modules/`. Each one should have an `enable` flag to enable it for a host.

Software configuration is further split into other directories:
1. System configuration should go into `modules`.
2. User configuration should go into `users/{user}/`
3. Anything defining nixos home-manager configuration should go into `home`. The modules used by a user should be called from `users/{user}/home.nix`

Resources
---------

[NixOS manual](https://nix.dev/manual/nix/2.18/language/)

[NixOS and flakes book](https://nixos-and-flakes.thiscute.world/)

[NixOS options search](https://search.nixos.org/options?channel=24.05)

[NixOS packages search](https://search.nixos.org/packages?channel=24.05)

[NixOS home manager options search](https://home-manager-options.extranix.com/?release=release-24.05)