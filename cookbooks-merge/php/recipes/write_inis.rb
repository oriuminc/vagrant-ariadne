#
# Author:: Patrick Connolly <patrick@myplanetdigital.com>
#
# Cookbook Name:: php
# Recipe:: write_inis
#
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

modules = Array.new
node['php']['directives'].each_key do |mod|
  modules << mod
end
modules.uniq!

modules.each do |name|
  template "#{node['php']['ext_conf_dir']}/#{name}.ini" do
    source "extension.ini.erb"
    cookbook "php"
    owner "root"
    group "root"
    mode "0644"
    variables(:name => name, :directives => node['php']['directives'][name])
  end
end
