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

branch = "master"
project = node['ariadne']['project']
site = "#{project}.dev"

git "/vagrant/data/condel" do
  repository "https://github.com/myplanetdigital/condel.git"
  reference branch
  additional_remotes Hash["write" => "git@github.com:myplanetdigital/condel.git"]
  action :checkout
end

%w{
  /vagrant/data/condel
}.each do |dir|
  bash "Checking out #{branch} branch of #{dir}" do
    user "vagrant"
    code <<-EOH
    cd #{dir} && git checkout #{branch}
    EOH
  end
end

directory "/mnt/www/html" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

bash "Running Drupal install script..." do
  user "vagrant"
  code ". #{node['filesystem']['v-root']['mount']}/config/scripts/01-build.sh"
  environment({
    'PROJECT'              => project,
    'SERVER_ROOT_PASSWORD' => node['mysql']['server_root_password'],
    'ACCOUNT_PASS'         => 'admin',
    'ACCOUNT_MAIL'         => 'vagrant@localhost'
  })
  not_if "test -e /mnt/www/html/#{project}"
end

web_app site do
  template "sites.conf.erb"
  server_name site
  server_aliases [ "www.#{site}" ]
  docroot "/mnt/www/html/#{project}"
end
