{pkgs, ...}: {
  ##################################################################################################################
  #
  # Jonthan's Dev Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix

    ../../home/programs
    ../../home/shell
  ];

  home = {
    username = "jmcelroy-dev";
  };

  programs.git = {
    userName = "Jonathan McElroy";
    userEmail = "jonathanpmcelroy@gmail.com";
  };
}