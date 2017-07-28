$MOUNT_POINT="/mnt/"
$VPN_PROVIDER="NORDVPN"
$VPN_CONFIG="UK"
$VPN_USERNAME="username"
$VPN_PASSWORD="password"

docker create --privileged `
	--restart=always `
	--name transmission `
	-v $MOUNT_POINT/transmission:/data `
	-v /etc/localtime:/etc/localtime:ro `
	-e "OPENVPN_PROVIDER=$VPN_PROVIDER" `
	-e "OPENVPN_CONFIG=$VPN_CONFIG" `
	-e "OPENVPN_USERNAME=$VPN_USERNAME" `
	-e "OPENVPN_PASSWORD=$VPN_PASSWORD" `
	-e "OPENVPN_OPTS=--inactive 3600 --ping 10 --ping-exit 60" `
	-p 9091:9091 `
	haugene/transmission-openvpn

docker create `
  --name=radarr `
    -v $MOUNT_POINT/radarr-config:/config `
    -v $MOUNT_POINT/transmission/completed:/downloads `
    -v $MOUNT_POINT/plex/movies:/movies `
    -e PGID=1000 -e PUID=1000  `
    -e TZ=Europe/London `
    -p 7878:7878 `
  linuxserver/radarr

docker create `
	--name sonarr `
	-p 8989:8989 `
	-e PUID=1000 -e PGID=1000 `
	-v /dev/rtc:/dev/rtc:ro `
	-v $MOUNT_POINT/sonarr/config:/config `
	-v $MOUNT_POINT/plex/tv:/tv `
	-v $MOUNT_POINT/transmission/completed:/downloads `
	linuxserver/sonarr

docker create `
	--name=jackett `
	-v $MOUNT_POINT/jackett/config:/config `
	-v $MOUNT_POINT/jackett/downloads:/downloads `
	-e PGID=1000 -e PUID=1000 `
	-e TZ=Europe/London `
	-p 9117:9117 `
	linuxserver/jackett

docker create `
	--restart=always `
	--name plex    `
	--net=host `
	-v $MOUNT_POINT/plex-config:/config `
	-v $MOUNT_POINT/plex:/data `
	timhaak/plex

#    -p 32400:32400 `
#	-p 1900:1900/udp `
#	-p 3005:3005 `
#	-p 5353:5353/udp `
#	-p 8324:8324 `
#	-p 32410:32410/udp `
#	-p 32412:32412/udp `
#	-p 32413:32413/udp `
#	-p 32414:32414/udp `
#	-p 32469:32469 `