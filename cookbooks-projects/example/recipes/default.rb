#
# Cookbook Name:: example
# Recipe:: default
#
# Copyright 2012, Myplanet Digital, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#

include_recipe "ariadne::default"

project = "example"

bash "Installing Drupal..." do
  action :nothing
  user "vagrant"
  group "vagrant"
  code <<-EOH
    drush -y si \
      --root=/mnt/www/html/#{project} \
      --db-url=mysqli://root:root@localhost/#{project} \
      --site-name="Ariadne Vanilla Drupal Example" \
      --site-mail=vagrant+site@localhost \
      --account-mail=vagrant+admin@locahost \
      --account-name=admin \
      --account-pass=admin
  EOH
end

bash "Downloading Drupal..." do
  user "vagrant"
  group "vagrant"
  cwd "/mnt/www/html"
  code <<-EOH
    drush -y dl drupal \
      --drupal-project-rename=#{project} \
      --cache
  EOH
  not_if "test -d /mnt/www/html/#{project}"
  notifies :run, "bash[Installing Drupal...]", :immediately
end

site = "#{project}.dev"

web_app site do
  cookbook "ariadne"
  template "sites.conf.erb"
  port node['apache']['listen_ports'].to_a[0]
  server_name site
  server_aliases [ "www.#{site}" ]
  docroot "/mnt/www/html/#{project}"
  notifies :reload, "service[apache2]"
end

# Since Varnish isn't guaranteed to exist, need a helper function to restart service.
::Chef::Recipe.send(:include, Ariadne::Helpers)
restart_service "varnish"
