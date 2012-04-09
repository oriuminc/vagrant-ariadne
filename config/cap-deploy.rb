###################################
## capistrano-drush-make configs ##
###################################

set :deploy_via, :drush_make
set :strategy, Capistrano::Deploy::Strategy::DrushMake.new(self)
set :drush_makefile, "local.condel.build"

############################
## capistrano-ash configs ##
############################

# Needed to avoid error
set :multisites, {}
set :default_multisite, "condel.dev"

set :stages, %w[ dev staging ]
set :default_stage, "dev"

########################
## capistrano configs ##
########################

set :application, "condel"
set :scm, "git"
set :repository, "https://github.com/myplanetdigital/condel.git"

