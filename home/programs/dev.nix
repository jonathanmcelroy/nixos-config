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
  };
}