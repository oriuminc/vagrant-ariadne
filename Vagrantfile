# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

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
  box = ENV['box'] ||= ini['vagrant']['box'] ||= "hardy64"

  # Mash of box names and urls
  baseboxes = {
    "hardy64" => "https://myplanet.box.com/shared/static/pkmp7lus3ojvd4vlusuj.box",
    "lucid64" => "http://files.vagrantup.com/lucid64.box"
  }

  config.vm.box = box
  config.vm.box_url = baseboxes[box]

  # config.vm.network :hostonly, "33.33.33.10"

  # config.vm.network :bridged

  # If exists, share the Squid cache directory between host and VM
  host_cache_dir = "~/Library/Caches/squid"
  if Dir.exists? File.expand_path(host_cache_dir)
    config.vm.share_folder "squid-cache", "/var/spool/squid3", host_cache_dir, :owner => "root", :group => "root"
  end

  config.vm.forward_port 80, 8080

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.roles_path     = "roles"

    chef.add_role("acquia")

    # You may also specify custom JSON attributes:
    #chef.json = { :mysql_password => "foo" }
  end
end
