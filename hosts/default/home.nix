{ config, pkgs, ... }:

let 
  dotfiles_path = builtins.fetchGit {
    url = "https://github.com/jonathanmcelroy/configuration.git";
    rev = "a7201d571f6ba9ca3494a951a8e0322fca42c8a7";
    name = "dotfiles";
  };
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jmcelroy";
  home.homeDirectory = "/home/jmcelroy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

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

    ".config/vimrc".source = dotfiles_path + "/.vimrc";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jmcelroy/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Create useful aliases
  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos#default";
  };
  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos#default";
  };

  # Enable git
  programs.git = {
    enable = true;
    userName = "Jonathan McElroy";
    userEmail = "jonathanpmcelroy@gmail.com";
  };

  # Configure vim/nvim
  programs.vim = {
    enable = true;
    # extraConfig = builtins.readFile (dotfiles_path + "/.vimrc");
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
