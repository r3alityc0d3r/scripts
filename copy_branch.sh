#!/bin/bash

for i in "$@"
do
  case $i in
    -s=*|--source=*)
      SOURCE=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
      echo $SOURCE
      ;;
    -d=*|--dest=*)
      DEST=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
      echo $DEST
      ;;
    *)

      ;;
  esac
done

INPUT=modules.csv
OLDIFS=$IFS
COUNT=1

IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read module
do
  cd $module
  git checkout -b $DEST
  git pull origin $DEST
  git merge origin/$SOURCE
  git push origin $DEST
  cd .. 
done < $INPUT
IFS=$OLDIFS
