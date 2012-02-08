# This script is used to diff the runs easily,
# as the changes in log tails indicate functionality
echo "Running 'vagrant kick' 1 of 2..."
vagrant kick > tests/tmp.log
echo "Running 'vagrant kick' 2 of 2..."
(sleep 5 && echo "Diffing test runs...") & vagrant kick | diff tests/tmp.log -
rm tests/tmp.log
