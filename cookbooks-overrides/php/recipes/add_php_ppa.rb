#
# Cookbook Name:: php
# Recipe:: add_php_ppa
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

cookbook_file "/etc/apt/preferences.d/php-preferences" do
  owner "root"
  group "root"
  mode "0644"
end

# Need to get
apt_repository "txwikinger-php" do
  uri "http://ppa.launchpad.net/txwikinger/php5.2/#{node['platform']}"
  distribution node['lsb']['codename']
  components [ "main" ]
  keyserver "keyserver.ubuntu.com"
  key "9CC59506"
  notifies :run, "execute[apt-get update]", :immediately
end
