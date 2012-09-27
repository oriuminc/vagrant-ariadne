#
# Author:: Patrick Connolly (<patrick@myplanetdigital.com>)
# Copyright:: Copyright (c) 2012 Myplanet Digital, Inc.
# License:: Apache License, Version 2.0
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

module Ariadne
  module Helpers

    # SEE: http://stackoverflow.com/a/8191279/504018
    def give_ssh_agent_root
      # find a parent process' ssh agent socket
      agents = {}
      ppid = Process.ppid
      Dir.glob('/tmp/ssh*/agent*').each do |fn|
        agents[fn.match(/agent\.(\d+)$/)[1]] = fn
      end

      while ppid != '1'
        if (agent = agents[ppid])
          ENV['SSH_AUTH_SOCK'] = agent
          break
        end
        File.open("/proc/#{ppid}/status", "r") do |file|
          ppid = file.read().match(/PPid:\s+(\d+)/)[1]
        end
      end

      # Comment this line out to allow ssh-agent to be missing
      fail "Could not find running ssh agent - Is config.ssh.forward_agent enabled in Vagrantfile?" unless ENV['SSH_AUTH_SOCK']
    end

    # Use this to restart a service that may or may not be present.
    # It will currently act every chef run.
    def restart_service(service)
      res = run_context.resource_collection.lookup("service[#{service}]") rescue nil

      if res
        ruby_block "trigger-notify-restart-#{service}" do
          #block { true }
          notifies :restart, "service[#{service}]"
        end
      end
    end
  end
end

