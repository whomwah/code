require 'capistrano/version'
load 'deploy'

set :domain, "whomwah.com"
set :user, "duncan"

set :application, "code.whomwah.com"
set :repository, "file://#{File.expand_path('.')}"

server "#{domain}", :app, :web, :db, :primary => true

set :deploy_via, :copy
set :copy_exclude, [".git", ".DS_Store"]
set :scm, :git
set :branch, "master"
set :deploy_to, "/home/#{user}/public_html/#{application}"
set :use_sudo, false
set :keep_releases, 2
set :git_shallow_clone, 1

ssh_options[:keys] = [ File.join( File.expand_path('~'), ".ssh", "whomwah" ) ]
ssh_options[:paranoid] = false

namespace :deploy do

  desc <<-DESC
  A macro-task that updates the code, fixes the symlink, added the symlink
  to the shared uploads folder. Finally takes a snapshot of the db.
  DESC
  task :default do
    transaction do
      update_code
      symlink
    end
  end
  
  task :update_code, :except => { :no_release => true } do
    on_rollback { run "rm -rf #{release_path}; true" }
    strategy.deploy!
  end

  task :after_deploy do
    cleanup
  end

end
