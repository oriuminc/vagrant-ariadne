#
# Cookbook Name:: ariadne
# Recipe:: example
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

project = 'example'
site = "#{project}.dev"

directory "/mnt/www/html" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

bash "Downloading drupal..." do
  cwd "/mnt/www/html"
  code <<-EOH
  http_proxy=http://33.33.33.1:3128 drush -y dl drupal --drupal-project-rename=#{project}
  (cd #{project} && drush -y site-install minimal --db-url=mysqli://root:#{node['mysql']['server_root_password']}@localhost/#{project})
  chown -R #{node['apache']['user']}:vagrant #{project}
  #chmod -R 440 #{project}
  EOH
  notifies :restart, "service[varnish]"
  not_if "test -e /mnt/www/html/#{project}"
end

web_app site do
  template "sites.conf.erb"
  server_name site
  server_aliases [ "www.#{site}" ]
  docroot "/mnt/www/html/#{project}"
end
