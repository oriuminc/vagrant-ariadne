#
# Cookbook Name:: ariadne
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

# Drush can't create when run by vagrant user
directory "/tmp/drush" do
  owner "vagrant"
  group "vagrant"
  mode "0777"
end

# Create ~/.drush/ so available for other things to be dropped in.
directory "/home/vagrant/.drush" do
  owner "vagrant"
  group "vagrant"
  mode "0700"
end

# PHP cli and apache processes share php.ini,
# so must explicitly set needs of drush.
file "/home/vagrant/.drush/drush.ini" do
  owner "vagrant"
  group "vagrant"
  mode "0644"
  content "memory_limit = -1"
end

# Drop in bash_profile script so that ssh'ing leads to project docroot.
bash_profile "login-dir" do
  user "vagrant"
end

# Delete default project dirs if `clean` envvar set.
if node['ariadne']['clean']
  project = node['ariadne']['project']

  # Some drupal files might be unwritable so set perms to 777.
  execute "chmod -R 777 /mnt/www/html/#{project}" do
    only_if "test -d /mnt/www/html/#{project}"
  end

  # Delete dirs recursively if they exist.
  %W{
    /vagrant/data/profiles/#{project}
    /mnt/www/html/#{project}
  }.each do |dir|
    directory dir do
      recursive true
      action :delete
      only_if "test -d #{dir}"
    end
  end
end

if node['instance_role'] == 'vagrant'
  ::Chef::Resource::RubyBlock.send(:include, Ariadne::Helpers)
  ruby_block "Give root access to the forwarded ssh agent" do
    block do
      give_ssh_agent_root
    end
  end
end
