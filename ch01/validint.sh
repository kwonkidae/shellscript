#!/bin/bash

validint()
{
  number="$1";
  min="$2";
  max="$3";

  if [ -z $number ] ; then
    echo "You didn't enter anything. Please enter a number." >&2
    return 1

  fi

  if [ "${number%${number#?}}" = "-" ] ; then
    testvalue="${number#?}"
  else
    testvalue="$number"
  fi

  nodigits="$(echo $testvalue | sed 's/[[:digit:]]//g')"

  if [ ! -z $nodigits ] ; then
    echo "Invalid number format! Only digits, no commas, spaces, etc." >&2
    return 1
  fi

  if [ ! -z $min ] ; then
    if [ "$number" -lt "$min" ] ; then
      echo "Your valud is too small: smallest acceptable valud is $min." >&2
      return 1
    fi
  fi

  if [ ! -z $max ] ; then
    if [ "$number" -gt "$max" ] ; then
      echo "Your value is too big: largest acceptable value is $max." >&2
      return 1
    fi
  fi
  return 0
}
