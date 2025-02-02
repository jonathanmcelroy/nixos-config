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
        gitlab.gitlab-workflow
        github.copilot
        github.copilot-chat
        github.vscode-github-actions
      ];

      userSettings = {
        editor.formatOnSave = true;
        git.confirmSync = false;
        window.titleBarStyle = "custom";
        editor.rulers = [ 80 120];
      };
    };
  };
}