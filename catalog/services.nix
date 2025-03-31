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

  grafana = {
    host = nodes.mars;
    port = 3001;

    dashy.section = "monitoring";
    dashy.description = "Grafana";
    dashy.icon = "favicon";
  };

  jellyfin = {
    host = nodes.mars;
    port = 8096;

    dashy.section = "networks";
    dashy.description = "Jellyfin Media";
    dashy.icon = "favicon";
  };
}
