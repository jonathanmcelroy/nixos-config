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
  };

  prometheus = {
    host = nodes.mars;
    port = 9090;

    node_exporter_port = 9100;

    dashy.section = "monitoring";
    dashy.description = "Prometheus";
    dashy.icon = "favicon";
  };
}
