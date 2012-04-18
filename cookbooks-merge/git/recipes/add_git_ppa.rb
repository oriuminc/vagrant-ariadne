#
# Cookbook Name:: git
# Recipe:: add_git_ppa
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

# Need to get
apt_repository "git-core" do
  uri "http://ppa.launchpad.net/git-core/ppa/#{node['platform']}"
  distribution node['lsb']['codename']
  components [ "main" ]
  key "E1DF1F24"
end
