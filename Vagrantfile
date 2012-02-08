# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define "ariadne"

  # Load required rubygems with helpful error if not installed.
  begin
    require 'inifile'
  rescue LoadError
    print "Please ensure that the 'inifile' ruby gem is installed.\n"
    print "Vagrant command execution aborted.\n"
    exit
  end

  # Import configs from ini file.
  ini = IniFile.new("config/config.ini")

  # Use 1) ENV variable, 2) INI config file, then 3) Default
  box     = ENV['box']     ||= ini['vagrant']['box']     ||= "hardy64"
  project = ENV['project'] ||= ini['vagrant']['project']

  # Mash of box names and urls
  baseboxes = {
    "hardy64" => "https://myplanet.box.com/shared/static/pkmp7lus3ojvd4vlusuj.box",
    "lucid64" => "http://files.vagrantup.com/lucid64.box"
  }

  config.vm.box = box
  config.vm.box_url = baseboxes[box]

  config.vm.network "33.33.33.10"

  # Detect if squid is running
  squid_running = true unless %x[ ps ax | grep -v 'grep' | grep 'squid.conf' ].empty?

  config.vm.forward_port "web", 80, 8080

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = [ "cookbooks", "cookbooks-overrides" ]
    chef.roles_path     = "roles"

    chef.add_role("ariadne")

    # Used to set .wgetrc and .curlrc to proxy
    chef.json = {
      :squid => squid_running,
      :vagrant => {
        :project => project
      }
    }
  end
end
