#!/bin/bash

locatedb="/var/locate.db"

if [ "$(whoami)" != "root" ] ; then
  echo "Must be root to run this command." >&2
  exit
fi

find / -print > $locatedb

exit 0
