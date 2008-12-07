#!/bin/sh

export AWS_ACCESS_KEY_ID='id'
export AWS_SECRET_ACCESS_KEY='key'
/usr/bin/mysqldump -uroot --complete-insert fb_bbclistenlive > /home/duncan/backup.sql
/usr/bin/s3cmd put whomwah:bbclistenlive_backup.sql /home/duncan/backup.sql >/dev/null 2>&1
