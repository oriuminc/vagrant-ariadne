#
# Author::  Joshua Timberman (<joshua@opscode.com>)
# Author::  Seth Chisamore (<schisamo@opscode.com>)
# Author::  Patrick Connolly (<patrick@myplanetdigital.com>)
# Cookbook Name:: php
# Recipe:: module_apc
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

require_recipe "build-essential"

case node['platform']
when "centos", "redhat", "fedora"
  %w{ httpd-devel pcre pcre-devel }.each do |pkg|
    package pkg do
      action :install
    end
  end
when "debian", "ubuntu"
  # apache2-threaded-dev needed for APC-3.0.19
  %w{ libpcre3-dev apache2-threaded-dev }.each do |pkg|
    package pkg do
      action :install
    end
  end
end

php_pear "apc" do
  version "3.0.19"
  directives ({
    :enabled          => 1,
    :shm_segments     => 1,
    :optimization     => 0,
    # No "M" suffix for shm_size in old APC versions.
    :shm_size         => "96", # See Acquia ini note (per-site php.ini).
    :ttl              => 7200,
    :user_ttl         => 7200,
    :num_files_hint   => 1024,
    :mmap_file_mask   => "/dev/zero", # See Acquia ini note
    :enable_cli       => 1,
    :cache_by_default => 1
  })
  action :install
end
