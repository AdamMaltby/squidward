#!/bin/sh

#turn off errors - will force quit script on error
set -e
#set variables for easy reference & reuse
squidlogdir=/var/log/squid
yesterday=$(date -d '1 day ago' '+%F')

#batch move access/cache.log files and rename
mv $squidlogdir/access.log $squidlogdir/access.$yesterday.log
mv $squidlogdir/cache.log $squidlogdir/cache.$yesterday.log

#create (rotate) new blank log files
/usr/sbin/squid -k rotate

# uncomment below to enable optional move yesterdays log to storage and tar.gz
# archivedir=/some/location
# sleep 60
# mv $squidlogdir/access$yesterday.log $archivedir/
# tar cvfz $archivedir/$yesterday.tar.gz $archivedir/*.$yesterday.log

