namespace :backup do
  desc "back db to s3"
  task :db do
    `AWS_ACCESS_KEY_ID='id'`
    `AWS_SECRET_ACCESS_KEY='key'`
    `mysqldump -uroot fb_bbclistenlive > /home/duncan/backup.sql`
    `s3cmd put whomwah:bbclistenlive_backup.sql /home/duncan/backup.sql`
  end
end
