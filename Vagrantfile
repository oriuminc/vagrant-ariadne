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

  if File.directory? File.expand_path "./data/apt-cache/partial/"
    config.vm.share_folder "apt-cache", "/var/cache/apt/archives", "./data/apt-cache", :owner => "root", :group => "root"
  end

  config.vm.share_folder "html", "/mnt/www/html", "./data/html"

  # Detect if squid is running
  squid_running = true unless %x[ ps ax | grep -v 'grep' | grep 'SquidMan' ].empty?

  config.vm.forward_port "web", 80, 8080

  # Update Chef if not at 0.10.8
  config.vm.provision :shell, :inline => 'if [ "`knife -v | awk \'{print $NF}\'`" != "0.10.8" ]; then echo "Upgrading Chef to 0.10.8..."; gem install chef -v 0.10.8; fi'

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = [ "cookbooks", "cookbooks-overrides" ]
    chef.roles_path     = "roles"

    chef.add_role("ariadne")

    # Used to set .wgetrc and .curlrc to proxy
    chef.json = {
      :mysql => {
        :server_debian_password => 'root',
        :server_root_password   => 'root',
        :server_repl_password   => 'root'
      },
      :squid => squid_running,
      :vagrant => {
        :project => project
      }
    }
  end
end
