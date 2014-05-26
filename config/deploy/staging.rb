##################################
##### SET THESE VARIABLES ########
##################################
set :domain, 'alpha.jumpstart.ge'
set :server_name, 'dev-storybuilder.jumpstart.ge'
set :full_app_name, "Story-Builder-Staging2" # unique name of application
set :user, "story-builder-staging" # name of user on server
set :github_account_name, "JumpStartGeorgia" # name of accout on git hub
set :github_repo_name, "Interactive-Story-Builder" # name of git hub repo
set :branch, "ruby2" # name of branch to deploy
set :rails_env, :staging # name of environment: production, staging, ...
set :stage, :staging
set :unicorn_worker_count, 5 # number of unicorn workers
set :unicorn_port_num, 8122 # must be a unique port number for this application
set :server_timeout, 30 # time in seconds before server timesout
set :enable_ssl, false # whether we're using ssl or not
##################################

puts "-- staging.rb"

server fetch(:domain), user: fetch(:user), roles: [:web, :app, :db], primary: true # server where app is located

#set :repo_url, 'git@example.com:me/my_repo.git'
set :repo_url, "git@github.com:#{fetch(:github_account_name)}/#{fetch(:github_repo_name)}.git"

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:full_app_name)}"

