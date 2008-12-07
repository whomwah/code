require 'mongrel_cluster/recipes'

set :domain,        "<domain>"
set :application,   "bbclistenlive"
set :user,          "facebook"
set :mysql_user,    "root"
# Fetch repos location form the source, this was the correct
# code gets deployed even once released ...
set :repository,    (`svn info | grep URL`).split(' ').last.chomp
set :db_name,       "fb_#{application}"
set :deploy_via,    :copy
set :deploy_to,     "/home/#{user}/apps/#{application}"
set :rails_env,     "production"
set :mongrel_conf,  "#{current_path}/config/mongrel_cluster.yml"
set :use_sudo,      false
set :cron,          "0,15,30,45 * * * * rake -f #{current_path}/Rakefile tva:sync >/dev/null 2>&1"

ssh_options[:paranoid] = false

role :app, "#{domain}"
role :web, "#{domain}"
role :db,  "#{domain}", :primary => true

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    restart_mongrel_cluster
  end
  
  task :after_deploy do
    add_cron
    cleanup
  end

  desc "Appends a cron job for app to the current list"
  task :add_cron do
    if not cron.to_s.strip.length == 0
      cron_entry = <<-VAR
# Start: #{application}
#{ cron.to_s.strip }
# End: #{application}
VAR

      run <<-CMD
{ crontab -l 2>/dev/null | sed '/^# Start: #{application}/,/^# End: #{application}/d';
echo #{shell_escape(cron_entry)}; } | crontab -
CMD
    end
  end

  desc "Backs up the apps db and downloads it to your app dir"
  task :backup do
    filename = "/tmp/dbbackup_#{Time.now.to_s.gsub(/ /, "_")}.sql.gz"
    on_rollback { run "rm #{filename}" }
    run "mysqldump -uroot #{db_name} | gzip > #{filename}"
    `rsync duncan@#{roles[:db][0].host}:#{filename} /Users/dunc/Backups/web/`
    run "rm #{filename}"
  end  

  desc "Remove the apps cron job from the list"
  task :remove_cron do
    run "crontab -l 2>/dev/null | sed '/^# Start: #{application}/,/^# End: #{application}/d' | crontab -"
  end
  
  def add_quotes(s, q) #:nodoc:
    q + s.gsub('\\', '\\\\\\').gsub(q, '\\' + q) + q
  end
  
  def shell_escape(s) #:nodoc:
    '$' + add_quotes(s, "'").gsub("\n", '\\n')
  end
end
