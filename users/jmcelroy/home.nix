{pkgs, ...}: {
  ##################################################################################################################
  #
  # Jonthan's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix

    ../../home/programs
  ];

  programs.git = {
    userName = "Jonathan McElroy";
    userEmail = "jonathanpmcelroy@gmail.com";
  };
}