#
# Cookbook Name:: solr
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

require_recipe "tomcat"
require_recipe "ark"

solr_version = "3.5.0"
ark "solr" do
  url "http://archive.apache.org/dist/lucene/solr/#{solr_version}/apache-solr-#{solr_version}.tgz"
  version solr_version
  owner node['tomcat']['user']
end

link "#{node['tomcat']['webapp_dir']}/solr-example.war" do
  to "#{node['ark']['prefix_home']}/solr/example/solr/apache-solr-#{solr_version}.war"
  owner node['tomcat']['user']
  group node['tomcat']['group']
end
