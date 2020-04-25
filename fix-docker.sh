#!/usr/bin/env bash

# $1 - site name
if [ ! -z "$1" ] ; then

  SITE="$1"

  echo "Fixing site '$SITE'"
  set -euo pipefail
  cd "/opt/omd/sites/${SITE}/etc/apache"

  # delete unneeded things
  echo "   Delete {proxy-port,apache-own}.conf"
  rm -f proxy-port.conf apache-own.conf

  # remove comments and empty lines from config files
  echo "   Formatting config files"
  find . -type f -iname "*.conf" -print0 \
    | xargs -0 sed -Ei -e '/^\s*(#.*)?$/d'

  # change ServerName to something NOT 0.0.0.0:5000 ...
  # strangely this seems to fix the issue
  echo "   Fixing apache config"
  sed -i "/ServerName/d" listen-port.conf
  echo "ServerName my.server.com" >> listen-port.conf

  # reload apache gracefully
  echo "   Reloading apache"
  PIDFILE=$(cat apache.conf | grep PidFile | awk '{print $2}')
  kill -USR1 $(cat $PIDFILE)

else

  find /opt/omd/sites -maxdepth 1 ! -path /opt/omd/sites -type d \
  | while read SITE; do
    $0 "$(basename "$SITE")"
  done

  echo "All sites fixed, exiting."

fi
