# Format is as follows:
# COMPONENT remaining lines are command for retrieving version
COMMAND_MATRIX=$(cat <<EOF
Varnish varnishstat -V 2>&1 | grep -i ^varnish
PHP php -v | grep ^PHP | cut -d' ' -f2
PEAR pear -V 2>&1 | grep ^PEAR | cut -d' ' -f3
Memcached memcached -h 2>&1 | grep -i ^memcached | cut -d' ' -f2
Memcached-PECL pecl list | grep -E memcached[[:space:]]+
Memcached-APT dpkg-query -W | grep -E php5-memcached[[:space:]]+ | cut -f2
EOF)

# All the servers to test
servers=(ariadne spartan@ded-1039.prod.hosting.acquia.com)

# Step through COMMAND_MATRIX line by line
IFS=$'\n'$'\r'
(
  echo COMPONENT VAGRANT ACQUIA
  for line in $COMMAND_MATRIX; do
    # Get component
    COMPONENT=`echo $line | cut -d' ' -f1`
    echo "Checking $COMPONENT" 1>&2
    # Get command for retrieving version
    COMMAND=`echo $line | cut -d' ' -f2-`

    # Build row with column for each server
    ROW=$COMPONENT
    for (( i = 0 ; i < ${#servers[@]} ; i++ ))
    do
      # SSH into server
      RESULT=`ssh -q ${servers[$i]} "$COMMAND"`
      # Strip newline
      RESULT=`echo $RESULT`
      if [[ ! "$RESULT" ]]; then
        RESULT="---"
      fi

      # Append server results to row
      ROW="$ROW $RESULT"
    done
    echo $ROW
  done
) | column -t
