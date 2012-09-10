#!/bin/sh

if [ "`knife -v | awk '{print $NF}'`" != "$1" ]
then
  echo "Upgrading Chef to $1...";
  gem uninstall chef --all --ignore-dependencies --executables
  gem install chef -v $1 --no-rdoc --no-ri
fi

# If last line is `mesg n`, replace with conditional.
if [ "`tail -1 /root/.profile`" = "mesg n" ]
then
  echo 'Patching basebox to prevent future `stdin: is not a tty` errors...'
  sed -i '$d' /root/.profile
  cat << 'EOH' >> /root/.profile
  if `tty -s`; then
    mesg n
  fi
EOH
fi
