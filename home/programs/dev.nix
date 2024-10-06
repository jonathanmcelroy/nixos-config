{
  pkgs,
  config,
  username,
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