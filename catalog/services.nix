{nodes}: {
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

  openwrt = {
    host = nodes.sun;
    port = 80;

    dashy.section = "networks";
    dashy.description = "OpenWRT";
    dashy.icon = "favicon";
  };

  radarr = {
    host = nodes.mars;
    port = 7878;

    dashy.section = "entertainment";
    dashy.description = "Radarr Movie Manager";
    dashy.icon = "favicon";
  };

  # prowlar = {
  #   host = nodes.mars;
  #   port = 9696;
  #
  #   dashy.section = "entertainment";
  #   dashy.description = "Prowlar";
  #   dashy.icon = "favicon";
  # }

  # flaresolverr = {
  #   host = nodes.mars;
  #   port = 8191;
  #
  #   dashy.section = "entertainment";
  #   dashy.description = "Flaresolverr"; 
  #   dashy.icon = "favicon";
  # }

  # lidarr = {
  #   host = nodes.mars;
  #   port = 8686;

  #   dashy.section = "entertainment";
  #   dashy.description = "Lidarr Music Manager";
  #   dashy.icon = "favicon";
  # };

  # transmission = {
  #   host = nodes.mars;
  #   port = 9091;
  #   dashy.section = "entertainment";
  #   dashy.description = "Transmission";
  #   dashy.icon = "favicon";
  # }
}
