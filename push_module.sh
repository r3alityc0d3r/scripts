#!/bin/bash

if [ -n "$1" ]; then
  MODULE=$1
else
  echo "no module listed"; exit 99;
fi

if [ -n "$2" ]; then
  BRANCH=$2
else
  echo "no branch listed"; exit 99;
fi

cd $MODULE
git add .
git commit -m "fixing puppet spec"
git push origin $BRANCH
cd ..
