#
# Cookbook Name:: ariadne
# Recipe:: squid
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

%w{
  .wgetrc
  .curlrc
}.each do |file|
  cookbook_file "/home/vagrant/#{file}" do
    owner "vagrant"
    group "vagrant"
    mode "0644"
    # Delete unless squid running on host (default = :create)
    action :delete unless node['squid'] === true
  end
end

