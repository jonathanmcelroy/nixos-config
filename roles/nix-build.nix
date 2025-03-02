# Use if the node should allow building flakes
{ 
    lib,
    config,
    ...
}:
let
    inherit (lib);
    cfg = config.roles.nix-build;
{
    options = {
        roles.nix-build = {
            enable = mkEnableOption "Allow building flakes on this node";
        };
    };

    config = mkIf cfg.enable {
        nix.settings = {
            experimental-features = [
                "nix-command"
                "flakes"
            ];
        }
    }
}