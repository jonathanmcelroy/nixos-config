{ 
    nodes,
}:
{
    adguard = {
        host = nodes.mars;
        port = 3000;

        dashy.section = "networks";
        dashy.description = "Ad Blocker";
        dashy.icon = "h1-adguardhome";
    }
}