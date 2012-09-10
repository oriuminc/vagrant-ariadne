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

# Allow SSH and Git to work with github.com and git.*.com without manually
# allowing host keys.
cookbook_file "/etc/ssh/ssh_config" do
  owner "root"
  group "root"
  mode "0644"
end

# SEE: http://stackoverflow.com/a/8191279/504018
ruby_block "Give root access to the forwarded ssh agent" do
  block do
    # find a parent process' ssh agent socket
    agents = {}
    ppid = Process.ppid
    Dir.glob('/tmp/ssh*/agent*').each do |fn|
      agents[fn.match(/agent\.(\d+)$/)[1]] = fn
    end
    while ppid != '1'
      if (agent = agents[ppid])
        ENV['SSH_AUTH_SOCK'] = agent
        break
      end
      File.open("/proc/#{ppid}/status", "r") do |file|
        ppid = file.read().match(/PPid:\s+(\d+)/)[1]
      end
    end
    # Uncomment to require that an ssh-agent be available
    fail "Could not find running ssh agent - Is config.ssh.forward_agent enabled in Vagrantfile?" unless ENV['SSH_AUTH_SOCK']
  end
  action :create
end
