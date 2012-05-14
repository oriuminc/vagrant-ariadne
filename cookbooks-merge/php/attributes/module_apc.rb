#
# Author:: Patrick Connolly <patrick@myplanetdigital.com>
#
# Cookbook Name:: php
# Attributes:: module_apc
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

default['php']['directives']['apc'] = {
  "enabled"          => "1",
  "shm_segments"     => "1",
  "optimization"     => "0",
  # No "M" suffix for shm_size in old APC versions.
  "shm_size"         => "96", # See Acquia ini note (per-site php.ini).
  "ttl"              => "7200",
  "user_ttl"         => "7200",
  "num_files_hint"   => "1024",
  "mmap_file_mask"   => "/dev/zero", # See Acquia ini note
  "enable_cli"       => "1",
  "cache_by_default" => "1",
}
