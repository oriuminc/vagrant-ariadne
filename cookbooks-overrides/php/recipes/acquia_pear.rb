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

# Bring PEAR version close to Acquia's 1.6.1
# php-pear package's default version too old to install apc...
current_vers = %x[ pear -V 2>&1 | grep -i PEAR | awk '{print $NF}' | tr -d '\n' ]
target_vers = "1.6.1"
php_pear "PEAR" do
  version target_vers
  options "--force"
  action :install
  only_if { Gem::Version.create(current_vers) != Gem::Version.create(target_vers)  }
end
