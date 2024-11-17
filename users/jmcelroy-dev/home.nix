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

  programs.git = {
    userName = "Jonathan McElroy";
    userEmail = "jonathanpmcelroy@gmail.com";
  };
}