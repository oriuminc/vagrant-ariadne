# Format is as follows:
# COMPONENT remaining lines are command for retrieving version
COMMAND_MATRIX=$(cat <<EOF
Varnish varnishstat -V 2>&1 | grep -i ^varnish | cut -d' ' -f2 | cut -d- -f2
Git git --version | awk '{print \$NF}'
MySQL mysql -V | awk '{print \$5}' | cut -d, -f1
Drush drush --version | awk '{print \$NF}'
Drush_Make drush make --version -n 2>/dev/null | grep -E ^[[:digit:]]
PHP php -v | grep ^PHP | awk '{print \$2}'
PEAR pear -V 2>&1 | grep ^PEAR | awk '{print \$3}'
Memcached memcached -h 2>&1 | grep -i ^memcached | awk '{print \$2}'
APC-PHP-cli       php --ri apc       | grep -i ^version  | awk '{print \$3}'
Memcache-PHP-cli  php --ri memcache  | grep -i ^revision | awk '{print "r" \$4}' # No version info in 2.2.0
Memcached-PHP-cli php --ri memcached | grep -i ^version  | awk '{print \$3}'
Xdebug-PHP-cli    php --ri xdebug    | grep -i ^version  | awk '{print \$3}'
APC-PECL       pecl list | grep APC                      | awk '{print \$2}'
Memcache-PECL  pecl list | grep -E memcache[[:space:]]+  | awk '{print \$2}'
Memcached-PECL pecl list | grep -E memcached[[:space:]]+ | awk '{print \$2}'
Xdebug-PECL    pecl list | grep xdebug                   | awk '{print \$2}'
APC-APT        dpkg-query -Wf='\${Version}' php*-apc       2>/dev/null
Memcache-APT   dpkg-query -Wf='\${Version}' php*-memcache  2>/dev/null
Memcached-APT  dpkg-query -Wf='\${Version}' php*-memcached 2>/dev/null
Xdebug-APT     dpkg-query -Wf='\${Version}' php*-xdebug    2>/dev/null
EOF)

# All the servers to test
servers=(ariadne spartan@ded-1039.prod.hosting.acquia.com)
#servers=(spartan@ded-1039.prod.hosting.acquia.com)

# Step through COMMAND_MATRIX line by line
IFS=$'\n'$'\r'
(
  printf '%20s\n' | tr ' ' '-'
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
  done | sort
) | column -t
