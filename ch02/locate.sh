#!/bin/bash

locatedb="/var/locate.db"

exec grep -i "$@" $locatedb
