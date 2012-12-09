#
# Regular cron jobs for the easy-backup package
#
#
0 1	* * *	root	su - postgres -c '/usr/bin/pg_dumpall' > /var/cache/easy-backup/sql/postgres.sql
0 1	* * *	root	dpkg --get-selections > /var/cache/easy-backup/dpkg-selections.bk
