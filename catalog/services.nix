{
  nodes,
}:
{
  dashy = {
    host = nodes.mars;
    port = 80;

    dashy.section = "networks";
    dashy.description = "Dashboard";
    dashy.icon = "favicon";
  };

  adguard = {
    host = nodes.mars;
    port = 3000;

    dashy.section = "networks";
    dashy.description = "Ad Blocker";
    dashy.icon = "favicon";
  };
}
