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
site = "#{project}.localdomain"

directory "/var/www/#{project}" do
  group "www-data"
  owner "www-data"
  mode "0755"
end

file "/var/www/#{project}/index.php" do
  owner "www-data"
  group "www-data"
  mode "0755"
  content <<-EOH
<?php
print phpinfo();
?>
  EOH
  notifies :restart, "service[varnish]"
end

web_app site do
  template "sites.conf.erb"
  server_name site
  server_aliases [ "www.#{site}" ]
  docroot "/var/www/#{project}"
end
