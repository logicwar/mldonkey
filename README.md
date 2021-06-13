[hub]:https://hub.docker.com/r/logicwar/mldonkey/
[MLDonkey_wikipedia]:https://en.wikipedia.org/wiki/MLDonkey
[tz_wikipedia]:https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

# [Docker Container for MLDonkey][hub]

This is a Docker image based on osixia/light-baseimage for running  MLDonkey 3.1.6.

MLDonkey is an open source, multi-protocol, peer-to-peer file sharing application that runs as a back-end server application on many platforms. It can be controlled through a user interface provided by one of many separate front-ends, including a Web interface, telnet interface and over a dozen native client programs. [Wikipedia][MLDonkey_wikipedia]

MLDonkey is free software, released under the terms of the GNU General Public License.

## Usage

```
docker create --name=mldonkey \ 
              -v <path for config files>:/var/lib/mldonkey:rw \
              -v <path for temporary files>:/mnt/mldonkey_tmp:rw \
              -v <path for completed downloaded files>:/mnt/mldonkey_completed:rw \
              -e PGID=<gid>
              -e PUID=<uid> \
              -e TZ=<timezone> \
              -p 4000:4000 \
              -p 4001:4001 \
              -p 4080:4080 \
              -p 20562:20562 \
              -p 20566:20566/udp \
              -p 16965:16965 \
              -p 16965:16965/udp \
              -p 6209:6209 \
              -p 6209:6209/udp \
              -p 6881:6881 \
              -p 6882:6882 \
              -p 3617:3617/udp \
              -p 4444:4444 \
              -p 4444:4444/udp \
              logicwar/mldonkey
```

## Parameters
* `-p 4000` - Telnet port
* `-p 4001` - GUI port
* `-p 4080` - HTTP port for the Web interface
* `-p 20562` - eDonkey2000 port
* `-p 20566/udp` - eDonkey2000 port
* `-p 16965` - Kad port (disabled by default)
* `-p 16965/udp` - Kad1 port (disabled by default)
* `-p 6209` - Overnet port (disabled by default)
* `-p 6209/udp` - Overnet port (disabled by default)
* `-p 6881` - BitTorrent Client port (disabled by default)
* `-p 6882`- BitTorrent Tracker port (disabled by default)
* `-p 3617/udp` - BitTorrent DHT port (disabled by default)
* `-p 4444` - BitTorrent DHT port (disabled by default)
* `-p 4444/udp` - BitTorrent DHT port (disabled by default)
* `-v /var/lib/mldonkey` - where LMS stores config and log files
* `-v /mnt/mldonkey_tmp` - local path for your audios
* `-v /mnt/mldonkey_completed` - local path for your playlists
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for timezone information : Europe/London, Europe/Zurich, America/New_York, ... ([List of TZ][tz_wikipedia])

For shell access while the container is running do `docker exec -it mldonkey /bin/bash`

### User / Group ID

For security reasons and to avoid permissions issues with data volumes (`-v` flags), you may want to create a specific "docker" user with proper right accesses on your persistant folders. To find your user **uid** and **gid** you can use the `id <user>` command as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

and finally specify your "docker" user `PUID` and group `PGID`. In this exemple `PUID=1001` and `PGID=1001`.

## Setting up the application 

The intitial setup is made by browsing to http://your_server_IP:4080 and begin configuring the MDDonkey Server.

The first thing to do is to **set a password for the admin user**. you can use the command in the input field: `useradd admin <your_password>`

By default only eDonkey is enabled. To enable the other networks go to `Options->Net` and set to `true` what you need.

## Container default configuation
|Network|Type|MLDonkey default|Default Container Setup|Configuration file|
|---|---|---|---|---|
|http_port|TCP|4080|4080|downloads.ini|
|telnet_port|TCP|4000|4000|downloads.ini|
|gui_port|TCP|4001|4001|downloads.ini|
|eDonkey2000|TCP|random|20562|donkey.ini|
|eDonkey2000|UDP|TCP port + 4|20566|donkey.ini|
|Kad|TCP|random|16965|donkey.ini, Kademlia section|
|Kad1|UDP|Same as TCP|16965|donkey.ini, Kademlia section|
|Overnet|TCP|random|6209|donkey.ini, Overnet section|
|Overnet|UDP|Same as TCP|6209|donkey.ini, Overnet section|
|BitTorrent Client |TCP|6882|6882|bittorrent.ini|
|BitTorrent Tracker |TCP|6881|6881|bittorrent.ini|
|BitTorrent DHT |UDP|random|3617|bittorrent.ini|
|DirectConnect|TCP|4444|4444|directconnect.ini|
|DirectConnect|UDP|Same as TCP|4444|directconnect.ini|



## Versions
+ **V0.2** Updated to to osixia/light-baseimage 1.3.3 and MLDonkey 3.1.6 , delete at boot "*.ini.tmp" files to ensure proper Core start
+ **V0.1** Initial Release 3.1.5