The most difficult part in maintaining a system is the backup procedure:
tedious to setup and to maintain; with ``easy backup`` I hope to change this.

It has two backends: ``rsnapshot`` and ``rdiff-backup``, each with its own
characteristics; in order to use you must create the binary packages and
install the one with the backend of your choice

```
$ git clone https://github.com/gipi/Easy-backup.git
$ cd Easy-backup
$ fakeroot debian/rules binary
# dpkg -i easy-backup-<backend>.deb
<insert public key and username for backup>
```

##RSNAPSHOT

In the system where you want to store the backups, create a rsnapshot
like the one stored at /usr/share/easy-backup/conf/rsnapshot.conf and
add a line in a crontab file in order to schedule it. Just this!

##RDIFF-BACKUP

Install ``rdiff-backup`` client side and launch it so to obtain the
backup (you can configure cron client-side using the example in 
``/usr/share/easy-backup/conf/`` directory).

##DATABASES

If you want to dump databases from the remote system, use the script
in /usr/share/easy-backup/conf/cron and decomment your choosen backend.

WARNING: installing manually the package (by dpkg) can cause an error,
it's possible to fix executing

 $ apt-get -f install

In order to test the connection you can use

 $ ssh backupuser@mydomain.com 'echo miao true'

and see if all is ok.
