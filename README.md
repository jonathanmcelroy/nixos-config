Jonathan McElroy's NixOS configuration
======

This reposotory is to store my configuration-as-code for all my machines.  It uses flakes to manage the configuration. The configuration is stored in the `flake.nix` file.

Usage
-----

To test the configuration for the jmcelroy-home system, run the following command:
```bash
sudo nixos-rebuild test --flake '/usr/local/src/nixos-configuration#jmcelroy-home' --show-trace --print-build-logs --verbose
```

To install the configuration for the jmcelroy-home system, run the following command:
```bash
sudo nixos-rebuild switch --flake '/usr/local/src/nixos-configuration#jmcelroy-home' --show-trace --print-build-logs --verbose
```

To test a deployment to a server, run the following command:
```bash
nix run .#test-deploy $server
```

To actually deploy to a server, run the following command:
```bash
nix run .#deploy $server
```

To explore the configured values, run the following command:
```bash
nix repl
```
followed by:
```
nix-repl> :lf .
nix-repl> nixosConfigurations.jmcelroy-home.config.systemd.network.networks
{
    "10-lan" = { ... };
}
```

Architecture
------------

Each machine's configuration is stored in the `hosts/{hostname}` directory. The configuration is split into 2 pieces:

1. Hardware configuration in `hardware-configuration.nix`
2. Software configuration in `configuration.nix`

This is to enable VM testing by invoking the software configuration alone and ensuring that we can at least boot and ssh in.

Hardware configuration should be as minimal as possible to ensure that as much is tested as possible.

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