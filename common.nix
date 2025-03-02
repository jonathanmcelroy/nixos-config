{
    pkgs,
    ...
}:
let
    inherit (pkgs) lib;
in {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?

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

    # do garbage collection weekly to keep disk usage low
    nix = {
        optimise.automatic = true;
        gc = {
            automatic = lib.mkDefault true;
            dates = lib.mkDefault "weekly";
            options = lib.mkDefault "--delete-older-than 7d";
        };

        settings = {
            experimental-features = [
                "nix-command"
                "flakes"
            ];
        };
    };
}