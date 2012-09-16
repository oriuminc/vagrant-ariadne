# This script is used to diff the runs easily,
# as the changes in log tails indicate functionality.

#### MUST BE RUN FROM VAGRANT PROJECT ROOT

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Running 'vagrant kick' 1 of 2..."
vagrant kick > ${DIR}/tmp.log
echo "Running 'vagrant kick' 2 of 2..."
vagrant kick | diff ${DIR}/tmp.log -
rm ${DIR}/tmp.log
