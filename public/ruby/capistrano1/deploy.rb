# this has been updated to work with my wordpress 2.0 install on textdrive.com

# This defines a deployment "recipe" that you can feed to capistrano
# (http://manuals.rubyonrails.com/read/book/17). It allows you to automate
# (among other things) the deployment of your application.

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :domain, "www.your-domain.com"
set :application, "wp_myapp"
set :user, "username"
set :repository, "http://#{domain}/svn/repos/trunk/#{application}/" 

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

role :web, "#{domain}"
role :app, "#{domain}"
role :db,  "#{domain}"

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :deploy_to, "/users/home/#{user}/sites/#{application}" # defaults to "/u/apps/#{application}"
# set :user, "flippy"            # defaults to the currently logged in user
# set :scm, :darcs               # defaults to :subversion
# set :svn, "/path/to/svn"       # defaults to searching the PATH
# set :darcs, "/path/to/darcs"   # defaults to searching the PATH
# set :cvs, "/path/to/cvs"       # defaults to searching the PATH
# set :gateway, "gate.host.com"  # default to no gateway
set :use_sudo, false

# =============================================================================
# SSH OPTIONS
# =============================================================================
# ssh_options[:keys] = %w(/path/to/my/key /path/to/another/key)
# ssh_options[:port] = 25

# =============================================================================
# TASKS
# =============================================================================
# Define tasks that run on all (or only some) of the machines. You can specify
# a role (or set of roles) that each task should be executed on. You can also
# narrow the set of servers to a subset of a role by specifying options, which
# must match the options given for the servers to select (like :primary => true)

# This overwrites the original task for our purposes
desc <<-DESC
A macro-task that updates the code, fixes the symlink, added the symlink
to the shared uploads folder. Finally takes a snapshot of the db.
DESC
task :deploy do
  transaction do
    update_code
    symlink
  end
end

desc "Cleanup after a deploy and then taking a dump of the db"
task :after_deploy do
  cleanup
  backup
end

desc "Link to uploads"
task :after_symlink do
  run "ln -nfs #{deploy_to}/#{shared_dir}/uploads/" \
    " #{deploy_to}/#{current_dir}/public/wp-content/uploads"
end
    
desc "Do a mysqldump of the db to the shared folder"
task :backup, :roles => :db do
  # the on_rollback handler is only executed if this task is executed within
  # a transaction (see below), AND it or a subsequent task fails.
  on_rollback { delete "#{deploy_to}/#{shared_dir}/system/dump.sql" }
  run "mysqldump -u username -p --lock-tables=FALSE databasename" \
      " > #{deploy_to}/#{shared_dir}/system/dump.sql" do |ch, stream, out|
    ch.send_data "databasepassword\n" if out =~ /^Enter password:/
  end
end