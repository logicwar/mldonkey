FROM osixia/light-baseimage:1.1.1

#########################################
##             SET LABELS              ##
#########################################

# set version and maintainer label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Logicwar <logicwar@gmail.com>"


#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set correct environment variables
ENV LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"
ENV DEBIAN_FRONTEND=noninteractive MLDONKEY_DIR="/var/lib/mldonkey"

#########################################
##          DOWNLOAD PACKAGES          ##
#########################################

# Download and install Dependencies & Main Software
RUN \
 echo "**** Install Dependencies & Main Software ****" && \
 apt-get update && \
 apt-get install --no-install-recommends -y \
	mldonkey-server && \
 rm -rf \
	/var/lib/apt/lists/* \	
	/tmp/* \
	/var/tmp/* \
	/var/log/mldonkey \
	/var/lib/mldonkey/*

#########################################
##       COPY & RUN SETUP SCRIPT       ##
#########################################
# copy setup, default parameters and init files
COPY service /container/service
COPY defaults /defaults

# set permissions and run install-service script
RUN \
 chmod -R +x /container/service && \
 /container/tool/install-service


#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

EXPOSE 4000 4001 4080 20562 20566/udp 16965 16965/udp 6209 6209/udp 6881 6882 3617/udp 4444 4444/udp
VOLUME /var/lib/mldonkey /mnt/mldonkey_tmp /mnt/mldonkey_completed

