#!/bin/bash

. validfloat.sh

if validfloat $1 ; then
  echo "$1 is valid floating-point value."
fi
