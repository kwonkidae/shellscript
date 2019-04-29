#!/bin/bash

archivedir="$HOME/.deleted-files"
realrm="$(which rm)"
move="$(which mv)"

dest=$(pwd)

if [ ! -d $archivedir ] ; then
  echo "$0: No deleted files directory: nothing to unrm" >&2
  exit 1
fi

cd $archivedir

if [ $# -eq 0 ] ; then
  # -F 파일 형식을 알리는 문자를 각 파일 뒤에 추가한다. 일반적으로 실행파일은 "*", 경로는 "/", 심블릭 링크는 "@", FIFO는 "|", 소켓은 "=", 일반적인 파일은 없다.
  # -C 정렬 방식을 세로로 한다.
  echo "Contents of your deleted files archive (sorted by date):"
  ls -FC | sed -e 's/\([[:digit:]][[:digit:]]\.\)\{5\}//g' \
    -e 's/^/ /'
  exit 0
fi

# -d 경로안의 내용을 나열하지 않고, 그 경로를 보여준다.(이것은 쉘 스크립트에서 유용하게 쓰인다.)
matches="$(ls -d *"$1" 2> /dev/null | wc -l)"

if [ $matches -eq 0 ] ; then
  echo "No match for \"$1\" in the deleted file archive." >&2
  exit 1
fi

if [ $matches -gt 1 ] ; then
  echo "More than one file or directory match in the archive:"
  index=1
  # -t 파일 시간 순으로 정열한다. 최근 파일이 제일 먼저.
  for name in $(ls -td *"$1")
  do
    datetime="$(echo $name | cut -c1-14 | \
      awk -F. '{ print $5"/"$4" at "$3":"$2":"$1 }')"
      filename="$(echo $name | cut -c16-)"
      if [ -d $name ] ; then
        filecount="$(ls $name | wc -l | sed 's/[^[:digit:]]//g')"
        echo " $index) $filename (contents = ${filecount} items, " \
             " deleted = $datetime)"
      else
        # -s 파일 크기를 1Kb 단위로 나타낸다
        # -k 파일 크기가 나열되면, kb 단위로 보여준다
        # 1 강조색
        size="$(ls -sdk1 $name | awk '{ print $1}')"
        echo " $index)    $filename (size = ${size}Kb, deleted = $datetime)"
      fi
      index=$(( $index + 1))
  done
  echo ""
  /bin/echo -n "Which version of $1 should I restore ('0' to quit)? [1] : "
  read desired
  if [ ! -z "$(echo $desired | sed 's/[[:digit:]]//g')" ] ; then
    echo "$0: Restore canceled by user: invalid input." >&2
    exit 1
  fi

  if [ ${desired:=1} -ge $index ] ; then
    echo "$0: Restore canceled by user: index value too big." >&2
    exit 1
  fi

  if [ $desired -lt 1 ] ; then
    echo "$0: Restore canceled by user." >&2
    exit 1
  fi

  restore="$(ls -td1 *"$1" | sed -n "${desired}p")"
  # -e 기존에 있는지 체크
  if [ -e "$dest/$1" ] ; then
    echo "\"$1\" already exists in this directory. Cannot overwrite." >&2
    exit 1
  fi

  /bin/echo -n "Restoreing file \"$1\" ..."
  $move "$restore" "$dest/$1"
  echo "done."

  /bin/echo -n "Delete the additional copies of this file? [y] "
  read answer

  if [ ${answer:=y} = "y" ] ; then
    $realrm -rf *"$1"
    echo "Deleted."
  else
    echo "Additional copies retained."
  fi
else
  if [ -e "$dest/$1" ] ; then
    echo "\"$1\" already exists in this directory. Cannot overwrite". >&2
    exit 1
  fi

  restore="$(ls -d *"$1")"

  /bin/echo -n "Restoring file \"$1\" ... "
  $move "$restore" "$dest/$1"
  echo "Done."
fi

exit 0



46.166.139.140
