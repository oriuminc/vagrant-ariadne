#
# Author::  Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Recipe:: acquia_pear
#
# Copyright 2011, Opscode, Inc.
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

# Load pear Ohai plugin from this cookbook
plugin_path = File.expand_path "#{File.dirname(__FILE__)}/../files/default/plugins"
Ohai::Config[:plugin_path] << plugin_path

o = ohai "reload_pear" do
  plugin "pear"
end

# Run at resource compilation too, to avoid errors when using log resource
o.run_action(:reload)

# Bring PEAR version close to Acquia's 1.6.1
# php-pear package's default version too new to install old apc...

#declared_pear_version = Gem::Version.create("1.6.1")

# Needs a unique resource name or else wonkiness
p = php_pear "PEAR-compile-pecl" do
  package_name "PEAR"
  #version declared_pear_version.to_s
  version "1.6.1"
  options "--force"
  action :install
  only_if do
    declared_pear_version = Gem::Version.create(p.version)
    original_pear_version = node['languages']['pear']['version']
    original_pear_version = Gem::Version.create(original_pear_version)
    original_pear_version != declared_pear_version
  end
end
