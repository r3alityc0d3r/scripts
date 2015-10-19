#!/bin/bash

INPUT=modules.csv
OLDIFS=$IFS

IFS=
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read module
do
  cd $module
  rake spec &>/dev/null
  RESULT=$?
  if [ $RESULT != 0 ]; then
    echo "[$module] rspec failed"
  else
    echo "[$module] rspec passed"
  fi
  cd ..
done < $INPUT
IFS=$OLDIFS
