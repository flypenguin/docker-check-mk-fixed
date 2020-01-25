#!/usr/bin/env bash

set -x
cd /opt/omd/sites/cmk/etc/apache

# delete unneeded things
rm proxy-port.conf apache-own.conf

#sed -Ei \
#  -e 's/^UseCanonicalName.*/UseCanonicalName Off\nUseCanonicalPhysicalPort Off/g' \
#  apache.conf

# remove comments and empty lines from config files
sed -Ei \
  -e '/^\s*(#.*)?$/d' \
  *.conf \
  conf.d/*.conf

# change ServerName to something NOT 0.0.0.0:5000 ...
# strangely this seems to fix the issue
sed -i "/ServerName/d" listen-port.conf
echo "ServerName my.server.com" >> listen-port.conf

# reload apache gracefully
PIDFILE=$(cat apache.conf | grep PidFile | awk '{print $2}')
kill -USR1 $(cat $PIDFILE)

# make debugging with 'docker exec' nicer
echo 'alias ls="ls --color"' >> /root/.bashrc
echo 'alias ll="ls -lh"' >> /root/.bashrc
(apt-get update; apt-get install -y vim less) > /dev/null 2>&1
