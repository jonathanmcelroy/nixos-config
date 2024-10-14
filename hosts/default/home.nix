{ inputs, config, pkgs, ... }:

let 
  dotfiles_path = builtins.fetchGit {
    url = "https://github.com/jonathanmcelroy/configuration.git";
    rev = "a7201d571f6ba9ca3494a951a8e0322fca42c8a7";
    name = "dotfiles";
  };
in {

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".local/bin/rebuild".text = ''
      #!/bin/bash

      sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos#default
    '';
  };

  # Create useful aliases
  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos#default";
  };
  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos#default";
  };

  # Configure vim/nvim
  programs.vim = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # coc.enable = true;
    extraLuaConfig = builtins.readFile ./nvim.lua;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
