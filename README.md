## Docker based setup for running plex, sonarr and radarr. Downloads handled by transmission through a VPN

Steps:
1. Install docker https://docs.docker.com/engine/installation/#platform-support-matrix
1. Install docker-compose https://docs.docker.com/compose/install/
1. Run `git clone https://github.com/bodyloss/MediaCenterSetup`
1. `cd ./MediaCenterSetup`
1. Make your own `.env` file `cp .env.sample .env`
1. Edit the `.env` file where necessary
1. Open Jackett http://YOUR_IP:9117/Admin/Dashboard and add a tracker to use, click "Copy torznab feed" and save this for the next step.
1. Open Sonarr http://YOUR_IP:8989/
    1. Add a downloadclient of type transmission. The transmission docker container doesn't have a public URL as all traffic goes through VPN. You can use the internal docker network though. To get the IP address run `docker inspect transmission | grep \"IPAddress\"`, port is 9091
    1. Add a torznab custom indexer, paste in the torznab feed from the previous step. Also set the API key to the one displayed at the top of Jackett
    1. Click connect and add `Plex Media Server`. The url is your public IP address, and the username and password are those you sign into https://plex.tv with
    1. Click _Series_, _Add series_ and find one you want. Click _Add a path_ and set it to `/tv/`
1. Open Radarr http://YOUR_IP:7878/ and repeat the steps for Sonarr, except when you add a path set it to `/movies/`
1. Open Plex http://YOUR_IP:32400/web/index.html and libraries, Movies path is `/data/movies/` and TV path is `/data/tv/`

### Notes
This assumes you have one user who's PGID/PUID is 1000. Change this as needed if you arne't using the first user created

### Problems
For some reason Radarr downloads files though transmission as root rather than as the normal user. So you need to regularily `chown -R user:user $MOUNT_POINT/transmission/completed`, not sure how to fix this.
