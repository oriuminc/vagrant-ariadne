#
# Cookbook Name:: solr
# Recipe:: package
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

include_recipe "tomcat"

package "solr-tomcat"

%w{
  schema-solr3x.xml
  solrconfig-solr3x.xml
  protwords.txt
}.each do |file|
  link_path = "/etc/solr/conf/#{file.gsub("-solr3x", "")}"
  target_path = "/mnt/www/html/example/sites/all/modules/apachesolr/solr-conf/#{file}"

  link link_path do
    to target_path
    notifies :restart, "service[tomcat]"
    not_if %{[[ "$(readlink #{link_path})" == "#{target_path}" ]]}
  end
end
