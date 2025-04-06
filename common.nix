{
  config,
  pkgs,
  catalog,
  ...
}:
let
  inherit (pkgs) lib;

  # Get all catalog services for this host
  host_services = builtins.filter (service: service.host.hostName == config.networking.hostName) (
    builtins.attrValues catalog.services
  );

  # Set each service enable flag to true
  solar_system_enabled_services = builtins.listToAttrs (
    builtins.map (service: {
      name = service.name;
      value = {
        enable = true;
      };
    }) host_services
  );

  # Define the static metrics for roles and services
  host_roles = catalog.nodes.${config.networking.hostName}.roles;
  host_roles_file_content = lib.concatStringsSep "\n" (
    builtins.map (role: "role{role=\"${role}\"} 1") host_roles
  ) + "\n";
  host_services_metric_content = lib.concatStringsSep "\n" (
    builtins.map (service: 
      let
        port = if builtins.hasAttr "port" service then toString service.port else "unknown";
      in
        "service{host=\"${config.networking.hostName}\", name=\"${service.name}\", port=\"${port}\"} 1"
    ) host_services
  ) + "\n";

in
{
  imports = [
    ./modules # Include all the custom modules

    # Users on all systems
    ./users/jmcelroy-dev
    ./users/nixos-deploy
  ];

  ############################################################################
  # General
  ############################################################################

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "23.11";

  ############################################################################
  # Locale
  ############################################################################

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Timezone
  time.timeZone = "America/Chicago";

  # Keyboard
  services.xserver.xkb.layout = "us";

  ############################################################################
  # Services
  ############################################################################

  # OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Start ssh-agent when sshing in
  programs.ssh.startAgent = true;

  # Gather prometheus metrics
  services.prometheus.exporters.node = {
    enable = true;
    port = catalog.services.prometheus.node_exporter_port;
    enabledCollectors = [
      "logind"
      "systemd"
    ];
    openFirewall = true;
    extraFlags = ["--collector.textfile.directory" "/etc/textfile_collector"];
  };
  environment.etc = {
    "textfile_collector/role.prom" = {
      text = host_roles_file_content;
      mode = "0644";
    };
    "textfile_collector/services.prom" = {
      text = host_services_metric_content;
      mode = "0644";
    };
  };


  # dconf must be enabled for random programs to work
  programs.dconf.enable = true;

  # Start solar-system services
  solar-system = solar_system_enabled_services;

  ############################################################################
  # Secrets
  ############################################################################

  sops.defaultSopsFile = ./secrets/github-runner.yaml;
  sops.secrets.github-runner-token = { };
  sops.secrets.grafana-discord-alert-webhook = {
    sopsFile = ./secrets/grafana.yaml;
  };

  ############################################################################
  # Package Management
  ############################################################################

  # GC monthly to keep disk usage low
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
    settings = {
      trusted-users = [
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bat
    bind
    curl
    git
    jq
    lf
    lsof
    nmap
    python3
    sysstat
    tree
    vim
    wget
    lm_sensors # Hardware sensors
  ];
}
