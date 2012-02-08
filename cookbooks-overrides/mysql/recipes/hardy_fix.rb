#
# Cookbook Name:: mysql
# Recipe:: hardy_fix
#
# Author:: Patrick Connolly <patrick@myplanetdigital.com>
# Author:: James Walker <james@myplanetdigital.com>
#
# Copyright 2011, Myplanet Digital
#
# All rights reserved - Do Not Redistribute
#

bash "Killing rogue mysqld_safe process" do
  user "root"
  code <<-EOH
  /etc/init.d/mysql stop
  killall -q mysqld_safe
  /etc/init.d/mysql start
  EOH
end
