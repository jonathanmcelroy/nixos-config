{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    ripgrep
    yq-go # https://github.com/mikefarah/yq
    htop

    # misc
    libnotify
    xdg-utils
    graphviz

    # productivity
    obsidian

    # cloud native
    docker-compose
    kubectl

    # Node
    nodejs
    nodePackages.npm
    nodePackages.pnpm
    yarn

    # Office
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    obsidian

    # Communication
    discord

    # Passwords
    keepassxc
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      # coc.enable = true;
      extraLuaConfig = builtins.readFile ./nvim.lua;
    };

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };

    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    jq.enable = true; # A lightweight and flexible command-line JSON processor
    ssh = {
      enable = true;
      includes = [
        "custom-config"
      ];
    };

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'exa --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
    };
  };

  services = {
    syncthing.enable = true;

    easyeffects.enable = true;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        # enabled-extensions = with pkgs.gnomeExtensions; [
        # ];
        disabled-extensions = [ ];
        enabled-extensions = with pkgs.gnomeExtensions; [
          system-monitor.extensionUuid
        ];
        favorite-apps = [
          "firefox.desktop"
          "code.desktop"
          "org.gnome.Console.desktop"
        ];
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
    };
  };
}
