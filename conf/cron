#
# Regular cron jobs for the easy-backup package
#
#
0 1	* * *	root	su - postgres -c '/usr/bin/pg_dumpall' > /var/cache/easy-backup/sql/postgres.sql
0 1	* * *	root	dpkg --get-selections > /var/cache/easy-backup/dpkg-selections.bk
# https://www.debian-administration.org/article/669/Cloning_a_Debian_system_-_identical_packages_and_versions
0 1	* * *	root	aptitude -q -F "\%?p=\%?V \%M" --disable-columns search \~i > /var/cache/easy-backup/package-version.list
