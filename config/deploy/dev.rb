# Stage specific settings

server 'ariadne', :app, :web, :primary => true
set :user, "vagrant"
set :deploy_to, "/mnt/www/html/#{stage}.#{application}" 
after 'drupal:symlink', 'drupal_protected:symlink'
