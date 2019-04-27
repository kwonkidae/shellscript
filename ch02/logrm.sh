#!/bin/bash

removelog="remove.log"

if [ $# -eq 0 ] ; then
  echo "Usage: $0 [-s] list of files or directories" >&2
  exit
fi

if [ "$1" = "-s" ] ; then
  shift
else
  echo "$(date): ${USER}: $@" >> $removelog
fi

/bin/rm "$@"

exit
