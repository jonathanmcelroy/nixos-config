{ 
    nodes,
}:
{
    adguard = {
        host = nodes.server1;
        port = 3000;

        dashy.section = "networks";
        dashy.description = "Ad Blocker";
        dashy.icon = "h1-adguardhome";
    }
}