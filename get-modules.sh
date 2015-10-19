#!/bin/bash

VERBOSE=false

for i in "$@"
do
case $i in
  -v|--verbose)
  VERBOSE=true
  ;;
  -b=*|--branch=*)
  BRANCH=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
  BRANCHING=true
  ;;
  -p|--purge)
  PURGE=true
  ;;
  *)

  ;;
esac
done

if $VERBOSE; then echo "Debugging output enabled"; fi
  

echo 'starting' > get-modules.log

INPUT=modules.csv
OLDIFS=$IFS
COUNT=1

IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
NUMMODS=`cat modules.csv | wc -l`
while read module
do
  if $PURGE; then
    rm $module -rf
  fi
  if [ ! -d $module ]; then
    if $VERBOSE; then echo "Module doesnt exist - downloading..."; fi
    REPO="git@ln0b10.homedepot.com:ose_automation_puppet/osepuppet-$module.git"
    if $VERBOSE; then
      echo "Getting Module: $module"
      echo "REPO: $REPO"
      echo "------------------------------"
    fi
    git clone $REPO $module >> ../get-modules.log 2>&1
    if $BRANCHING; then
      cd $module
      if $VERBOSE; then echo "Switching to branch $BRANCH"; fi
      git checkout $BRANCH >> ../get-modules.log 2>&1
      cd ..
    fi                    
  else
    if $VERBOSE; then echo "Module $module exists - updating..."; fi
    cd $module
    git fetch --all >>../get-modules.log 2>&1
    git pull --all >>../get-modules.log 2>&1
    if $BRANCHING; then
      if $VERBOSE; then echo "Switching to branch $BRANCH"; fi
      git checkout $BRANCH >>../get-modules.log 2>&1
    fi
    cd ..
  fi
  echo "Processing module $module [$COUNT/$NUMMODS]"
  COUNT=$((COUNT+1))
done < $INPUT
IFS=$OLDIFS
