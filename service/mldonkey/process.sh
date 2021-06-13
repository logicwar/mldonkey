#!/bin/sh

#########################################
##          RUN THE SERVICES           ##
#########################################

#Delete any *.ini.tmp files which may prevent mldonkey to start
cd /var/lib/mldonkey
rm -f *.ini.tmp

#Launch mldonkey
exec mldonkey

