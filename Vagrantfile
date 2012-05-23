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
  box     = ENV['box']     ||= ini['vagrant']['box']     ||= "lucid64"
  project = ENV['project'] ||= ini['vagrant']['project']

  # Mash of box names and urls
  baseboxes = {
    "hardy64" => "https://myplanet.box.com/shared/static/pkmp7lus3ojvd4vlusuj.box",
    "lucid64" => "http://files.vagrantup.com/lucid64.box"
  }

  config.vm.box = box
  config.vm.box_url = baseboxes[box]

  config.vm.network :hostonly, "33.33.33.10"

  # Use vagrant-dns plugin to configure DNS server
  config.dns.tld = "dev"
  config.dns.patterns = [ /^.*#{project}.dev$/ ]

  config.vm.share_folder "apt-cache", "/var/cache/apt/archives", "./data/apt-cache", :nfs => true
  config.vm.share_folder "gem-cache", "./tmp/ruby/1.9.1/cache", "./tmp/ruby/1.9.1/cache", :nfs => true
  config.vm.share_folder "html", "/mnt/www/html", "./data/html", :nfs => true

  config.vm.forward_port 80, 8080
  config.vm.forward_port 3306, 3306

  # Update Chef in VM to specific version before running provisioner
  config.vm.provision :shell do |shell|
    shell.path = "config/upgrade_chef.sh"
    shell.args = "0.10.8" # Chef version
  end

  config.vm.provision :chef_solo do |chef|
    # Include roles/ and any directories of format */roles/
    chef.roles_path = [ "roles" ]
    roledirs = File.join("*", "roles")
    chef.roles_path = chef.roles_path | Dir.glob(roledirs)

    chef.cookbooks_path = [ "cookbooks", "cookbooks-merge" ]
    # Also include any directories of format */cookbooks
    ckbkdirs = File.join("*", "cookbooks")
    chef.cookbooks_path = chef.cookbooks_path | Dir.glob(ckbkdirs)

    chef.add_role "ariadne"
    #chef.add_recipe "project_#{project}"

    chef.json = {
      "mysql" => {
        "server_debian_password" => "root",
        "server_root_password"   => "root",
        "server_repl_password"   => "root",
        "allow_remote_root" => true,
        "bind_address" => "0.0.0.0",
      },
      "ariadne" => {
        "project" => project
      }
    }
  end
end
