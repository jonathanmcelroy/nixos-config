{
  pkgs,
  config,
  ...
}: {
  programs = {
    git = {
      enable = true;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
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
        vadimcn.vscode-lldb
        mkhl.direnv
        gitlab.gitlab-workflow
        github.copilot
        github.copilot-chat
        github.vscode-github-actions
        github.vscode-pull-request-github
      ];

      userSettings = {
        editor = {
          formatOnSave = true;
          rulers = [
            80
            120
          ];
          tabCompletion = "on";
        };
        git.confirmSync = false;
        window.titleBarStyle = "custom";
        github.copilot.enable = {
          markdown = true;
        };
      };
    };
  };
}
