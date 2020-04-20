# Simple Web cluster using NGINX and Windows Containers

This is a quick example of how to use NGINX on a Windows container to reverse proxy over other containers, with the option to gracefully reload the configuration.

## System Configuration
This demo was set up on Windows 10 1909 and Docker For Windows 2.2.0.5.  Two new host records have been added `test1.my-host.local` and `test2.my-host.local` both pointing at `127.0.0.1`

## The nginx container
NGINX on is only 32bit on Windows, or at least offically.  There are more 64bit varients out there, but none of those are true native 64bit applications.  So nanoserver is out and so the next choice is servercore.

For the most part the container is a simple, a basic servercore image with nginx added to it and some config files.  NGINX is configured to load its proxy configs from a directory and this directory is mapped to an external volume.

Finally there is a powershell file to control how NGINX is run.

The compose file sets up this container as well as an exmaple node.

## Running the demo
1. Run `docker network create -d nat cluster` to set up the network the containers will be attached to.  By default it will only be the gateway container that has any ports exposed.
2. Run `docker-compose up -d` to start the gateway and the first node. Accessing [localhost](http://localhost) or [test2.my-host.local](http://test2.my-host.local) will display the default NGINX page and [test1.my-host.local](http://test1.my-host.local) will show the demo asp core site.
3. Run `docker run -d --name cluster-node-beta --network cluster mcr.microsoft.com/dotnet/framework/samples:aspnetapp` to start the second node.
4. Copy node-beta.conf into proxies directory
3. Run `docker exec cluster-gateway powershell ./docker-entrypoint.ps1 -command reload` to reload the NGINX config. Now [test2.my-host.local](http://test2.my-host.local) will show the aspnet demo site,