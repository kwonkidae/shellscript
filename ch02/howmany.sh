#!/bin/bash

IFS=":"
count=0; nonex=0;

for directory in $PATH ; do
  if [ -d "$directory" ] ; then
    echo "$directory"
    for command in "$directory"/* ; do
      if [ -x "$command" ] ; then
        count="$(( $count + 1 ))"
      else
        nonex="$(( $nonex + 1 ))"
      fi
    done
  fi
done

echo "$count commands, and $nonex entries that weren't executable"

exit 0
