# Format is as follows:
# COMPONENT remaining lines are command for retrieving version
COMMAND_MATRIX=$(cat <<EOF
PHP php -v | grep ^PHP | cut -d' ' -f2
PEAR pear -V 2>&1 | grep ^PEAR | cut -d' ' -f3
Xdebug php -v | grep -i xdebug
EOF)

# All the servers to test
servers=(ariadne spartan@staging-1041.prod.hosting.acquia.com spartan@ded-1039.prod.hosting.acquia.com)

# Step through COMMAND_MATRIX line by line
IFS=$'\n'$'\r'
(
  echo COMPONENT VAGRANT STAGING PRODUCTION
  for line in $COMMAND_MATRIX; do
    # Get component
    COMPONENT=`echo $line | cut -d' ' -f1`
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
