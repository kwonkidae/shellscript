#!/bin/sh
echo "Hello World"
echo $(which neqn)
cat $(which neqn)

RESULT='-x "/bin/sh"'
echo $RESULT
if [ ! -x "/bin/sh1" ] ; then
  echo "no executable"
fi
