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

      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        bbenoist.nix
        rust-lang.rust-analyzer
        mkhl.direnv
      ];

      userSettings = {
        git.confirmSync = false;
        window.titleBarStyle = "custom";
      };
    };
  };
}