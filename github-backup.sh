#!/bin/sh

export FILE="$DESTDIR/github-backup-`date '+%Y%m%d%H%M'`.tar.gz"

echo "smtputf8_enable=no" >> /etc/postfix/main.cf
postfix start
mkdir -p $DESTDIR

( github-backup -t $GITHUB_TOKEN --repositories --pulls --hooks -P -F -O $GITHUB_ORG -i -o $DESTDIR && \
tar -czf $FILE $DESTDIR/repositories && \
aws s3 cp $FILE $S3DEST && \
rm -f $FILE ) 2>&1 | tee $DESTDIR/github-backup.log

( cat <<_EOF_
From: GitHub Backup <backup@localhost>
To: $EMAIL
Subject: GitHub Backup $FILE

_EOF_
cat $DESTDIR/github-backup.log ) | sendmail $EMAIL

sleep 30
