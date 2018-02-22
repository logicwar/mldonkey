#!/bin/sh

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

#Apply the given parameters on first boot (PGID, PUID, TZ)
if [ ! -f "/etc/initialbootpassed" ]
then
	echo "-------> Initial boot"
	if [ -n "${PGID}" ]
	then
		OLDGID=$(id -g docker)
		groupmod -g $PGID docker
		find / -group $OLDGID -exec chgrp -h docker {} \;
	fi

	if [ -n "${PUID}" ]
	then
		OLDUID=$(id -u docker)
		usermod -u $PUID docker
		find / -user $OLDUID -exec chown -h docker {} \;
	fi

	if [ -n "${TZ}" ]; then echo $TZ > /etc/timezone; fi

	touch /etc/initialbootpassed

	#Setup mldlonky (need to be started once to create the proper files before copying the defaults)
	mldonkey &
	echo "Waiting for mldonkey to start..."
	sleep 5
	/usr/lib/mldonkey/mldonkey_command -p "" "kill"

	# copy the config files
	cp -r /defaults/. /var/lib/mldonkey/

	# Set the permissions
	chown -R docker:docker \
		/var/lib/mldonkey \
		/mnt/mldonkey_completed \
		/mnt/mldonkey_tmp
else
	echo "-------> Standard boot"
fi

