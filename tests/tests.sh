#!/bin/bash
#
# TODO: check if xclip is installed
set -o nounset
set -o errexit

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
readonly DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${DIR}

vagrant up --provider virtualbox

vagrant ssh storage \
    -c 'echo deb http://ktln2.org/Easy-backup/apt   sid main | \
        sudo tee --append /etc/apt/sources.list.d/easy-backup.list'
vagrant ssh storage \
    -c 'echo deb http://httpredir.debian.org/debian unstable main | \
        sudo tee --append /etc/apt/sources.list'
vagrant ssh storage \
    -c 'sudo apt-get update'
vagrant ssh storage \
    -c 'sudo apt-get install --yes --force-yes easy-backup-storage'

vagrant ssh storage \
    -c 'sudo cat /etc/rsnapshot-eb.conf'

vagrant ssh storage \
    -c 'sudo cat /root/.ssh/id_rsa_rsnapshot.pub' | xclip -selection clipboard

sleep 2

vagrant ssh storage \
    -c 'sudo cp /etc/rsnapshot-eb.conf /etc/rsnapshot.conf'

echo '#### when asked for domain name insert 192.168.33.3 in this test ###'
echo '### PRESS ANY KEY TO CONTINUE ###'

read

## ENDPOINT ##
vagrant ssh endpoint \
    -c 'echo deb http://ktln2.org/Easy-backup/apt   sid main | \
        sudo tee --append /etc/apt/sources.list.d/easy-backup.list'
vagrant ssh endpoint \
    -c 'sudo apt-get update'
vagrant ssh endpoint \
    -c 'sudo apt-get install --yes --force-yes easy-backup-endpoint'

## FINALLY THE BACKUP ##
vagrant ssh storage \
    -c 'sudo rsnapshot -v daily'

