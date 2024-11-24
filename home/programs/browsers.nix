{
  ...
}: {
  programs = {
    chromium = {
      enable = true;
      commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
      extensions = [
        # {id = "";}  // extension id, query from chrome web store
      ];
    };

    firefox = {
      enable = true;

      policies = {
        SearchSuggestionsEnabled = true;
        SearchEngines.Default = "DuckDuckGo";
      };

      # profiles.dev = {
      #   extensions = [
      #     "bitwarden_password_manager"
      #   ];
      # };
    };
  };
}