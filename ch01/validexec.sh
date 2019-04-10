#!/bin/bash
. validint.sh
if validint "$1" "$2" "$3" ; then
 echo "Input is a valid integer within your constraints."
fi
