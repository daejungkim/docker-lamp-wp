#!/bin/bash

GC_DIR="$HOME/gizur-wp-21"

if ! hash git 2>/dev/null; then
  echo >&2 "You need to install git - visit http://git-scm.com/downloads"
  echo >&2 "or, use install-gitless.sh instead."
  exit 1
fi

if [ -d "$GC_DIR" ]; then
  echo "=> gizur-wp-21 is already installed in $GC_DIR, trying to update"
  echo -ne "\r=> "
  cd $GC_DIR && git pull
else
  # Cloning to $GC_DIR
  git clone https://github.com/gizur/gizur-wp-21.git $GC_DIR  
fi

cd $GC_DIR/container && docker -H=tcp://127.0.0.1:4243' build .

echo "=> Installed $DC_DIR"

