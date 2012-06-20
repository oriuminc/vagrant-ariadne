#!/bin/sh

if [ "`knife -v | awk '{print $NF}'`" != "$1" ]; then
  echo "Upgrading Chef to $1...";
  gem uninstall chef --all --ignore-dependencies --executables
  gem install chef -v $1 --no-rdoc --no-ri
fi
