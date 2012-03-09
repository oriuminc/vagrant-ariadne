#
# Cookbook Name:: ariadne
# Recipe:: php_cli_restrict_ini
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

cli_dir = "/etc/php5/cli/conf.d"

link cli_dir do
  action :delete
  only_if "test -L #{cli_dir}"
end

directory cli_dir do
  owner "root"
  group "root"
  mode "0755"
end

%w{
  apc
  curl
  gd
  memcache
  mysqli
  mysql
  pdo
  pdo_mysql
}.each do |mod|
  link "#{cli_dir}/#{mod}.ini" do
    owner "root"
    group "root"
    to "/etc/php5/conf.d/#{mod}.ini"
    not_if "test -L #{cli_dir}/#{mod}.ini"
  end
end
