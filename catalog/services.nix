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

  coredns = {
    host = nodes.mars;
    port = 5353;

    domain = "solar-system.lan";

    dashy.section = "networks";
    dashy.description = "DNS";
    dashy.icon = "favicon";
  };
}
