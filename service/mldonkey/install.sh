#!/bin/sh

#########################################
##           CREATE FOLDERS            ##
#########################################
# Create files and directories folders
mkdir -p \
	/mnt/mldonkey_completed/files \
	/mnt/mldonkey_completed/directories

#########################################
##          SET PERMISSIONS            ##
#########################################
# create a "docker" user
useradd -U -d /var/lib/mldonkey docker

