# Sops

Sops is tool that allows a user to edit config files with encrypted values.

[Official Documentation](https://github.com/mozilla/sops)

[Sops Nix](https://github.com/Mic92/sops-nix)

## Overview of Sops Nix

The idea behind sops nix is that we configure sops nix with the age keys generated from the public ssh keys for the various areas that need to decode the keys. Those will be the developer writing the config, and each of the hosts that needs to decode the config to run the services.

## Calculating age public keys

Because the developer will have a default ssh key, we don't need to generate an age key for them. However, to calculate the public age key from the developer's ssh key, run the following command:

```bash
nix-shell -p ssh-to-age --run "ssh-to-age < ~/.ssh/id_ed25519.pub"
```

To calculate the public age key from a host's ssh key, run the following command, filling in `$HOST` with the correct value:

```bash
nix-shell -p ssh-to-age --run 'ssh-keyscan $HOST | ssh-to-age'
```

Add those keys to .sops.yaml appropriately.

## Edit sops files

To edit a sops file, run the following command:

```bash
nix-shell -p sops --run "sops edit secrets/example.yaml"
```

If you have added a key to the sops configuration, run the following command to rekey the sops file:

```bash
nix-shell -p sops --run "sops updatekeys secrets/example.yaml"
```

## Deployment

You can only 