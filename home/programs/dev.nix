{
  pkgs,
  config,
  ...
}: {
  programs = {
    git = {
      enable = true;
      extraConfig = {
        init = { defaultBranch = "main"; };
      };
    };

    vscode = {
      enable = true;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      mutableExtensionsDir = false;

      extensions = [
        pkgs.vscode-extensions.vscodevim.vim
        pkgs.vscode-extensions.bbenoist.nix
      ];

      userSettings = {
        git.confirmSync = false;
        window.titleBarStyle = "custom";
      };
    };
  };
}