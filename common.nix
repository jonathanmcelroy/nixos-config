{
    pkgs,
    ...
}:
let
    inherit (pkgs) lib;
in {
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