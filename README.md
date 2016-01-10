First create the binary package

    $ fakeroot debian/rules binary
    # dpkg -i easy-backup.deb
    <insert public key and username for backup>

In the system where you want to store the backups, create a rsnapshot config file
like the one stored at ``/usr/share/easy-backup/conf/rsnapshot.conf`` and
add a line in a crontab file in order to schedule it. Just this!

If you want to dump databases from the remote system, use the script
in ``/usr/share/easy-backup/conf/cron`` and decomment your choosen backend.

WARNING: installing manually the package (by ``dpkg``) can cause an error,
it's possible to fix executing

    $ apt-get -f install

In order to test the connection you can use

    $ ssh backupuser@mydomain.com 'echo miao true'

and see if all is ok.

If installing the packages some errors happen use ``export DEBCONF_DEBUG=developer``.
