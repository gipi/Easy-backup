#!/bin/bash
#
# TODO: check if xclip is installed
set -o nounset
set -o errexit

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
readonly DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

readonly LOG_FILE=${DIR}/tests.log
readonly PRINT_OUT="${PRINT_OUT:-pv -p --width 15 --delay-start 3}"

# FIXME: check return code
function execute_on() {
    # usage: print_out [storage|endpoint] "command to be executed"
    echo -e "\e[31m$1\e[0m\e[1m  \t$2\e[0m"
    vagrant ssh $1 -c "$2" 2>&1 | tee --append ${LOG_FILE} | ${PRINT_OUT} 2>&1 > /dev/null
}

cd ${DIR}

vagrant up --provider virtualbox

execute_on storage \
    'sudo sed -i s/pager/text/ /etc/apt/listchanges.conf'

execute_on storage \
    'echo deb http://ktln2.org/Easy-backup/apt   sid main | \
        sudo tee --append /etc/apt/sources.list.d/easy-backup.list'

execute_on storage \
    'echo deb http://httpredir.debian.org/debian unstable main | \
        sudo tee --append /etc/apt/sources.list'
execute_on storage \
    'sudo apt-get update'

execute_on storage \
    'sudo apt-get install --yes --force-yes $(apt-cache depends easy-backup-storage | awk /Depends:/{print\$2})'

echo '#### when asked for domain name insert 192.168.33.3 in this test ###'
echo '### PRESS ANY KEY TO CONTINUE ###'

read

vagrant ssh storage \
    -c 'sudo apt-get install --yes --force-yes easy-backup-storage'

execute_on storage \
    'sudo cat /etc/rsnapshot-eb.conf'

echo '#### the public key is saved into the clipboard ###'
sleep 3

vagrant ssh storage \
    -c 'sudo cat /root/.ssh/id_rsa_rsnapshot.pub' | tr -d '\n' | xclip -selection clipboard

execute_on storage \
    'sudo cp /etc/rsnapshot-eb.conf /etc/rsnapshot.conf'

## ENDPOINT ##
execute_on endpoint \
    'echo deb http://ktln2.org/Easy-backup/apt   sid main | \
        sudo tee --append /etc/apt/sources.list.d/easy-backup.list'
execute_on endpoint \
    'sudo apt-get update'

vagrant ssh endpoint \
    -c 'sudo apt-get install --yes --force-yes easy-backup-endpoint'

## FINALLY THE BACKUP ##
echo '##############################################'
echo '### now we check that effectively all work ###'
echo '##############################################'

vagrant ssh storage \
    -c 'sudo rsnapshot -v daily'

