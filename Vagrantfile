# -*- mode: ruby -*-
# vi: set ft=ruby :

current_dir = File.dirname(__FILE__)

# Add our custom strings to the load path
I18n.load_path << File.expand_path("../config/locales/en.yml", __FILE__)

# Import configs from YAML file.
yml = YAML.load_file "#{current_dir}/config/config.yml"

# Use 1) ENV variable, then 2) YAML config file
basebox   = ENV['basebox']   ||= yml['basebox']
project   = ENV['project']   ||= yml['project']
repo_url  = ENV['repo_url']  ||= yml['repo_url']
branch    = ENV['branch']    ||= yml['branch']
memory    = ENV['memory']    ||= yml['memory'].to_s
cpu_count = ENV['cpu_count'] ||= yml['cpu_count'].to_s

# Raise error if running 64-bit VM on 32-bit host system.
class AriadneError < Vagrant::Errors::VagrantError
  error_key "ariadne_arch_crosscheck"
end

# Write property to YAML config file
yml['basebox'] = basebox
yml['project'] = project
yml['repo_url'] = repo_url
yml['branch'] = branch
yml['memory'] = memory.to_i
yml['cpu_count'] = cpu_count.to_i
File.open("#{current_dir}/config/config.yml", 'w') { |f| YAML.dump(yml, f) }

Vagrant::Config.run do |config|
  config.vm.define "ariadne"

  # Mash of box names and urls
  baseboxes = YAML.load_file "#{current_dir}/config/baseboxes.yml"

  config.vm.box = basebox
  config.vm.box_url = baseboxes[basebox]

  config.vm.network :hostonly, "33.33.33.10"

  config.vm.customize ["modifyvm", :id, "--memory", memory.to_i]
  config.vm.customize ["modifyvm", :id, "--cpus", cpu_count.to_i]

  # Forward keys and ssh configs into VM
  # Caveats: https://github.com/mitchellh/vagrant/issues/105
  config.ssh.forward_agent = true

  # Use vagrant-dns plugin to configure DNS server
  config.dns.tld = "dev"
  config.dns.patterns = [ /^.*\.dev$/ ]

  # Only enable NFS shares on *nix systems (Windows doesn't need).
  # Ref: http://vagrantup.com/v1/docs/nfs.html
  nfs_flag = (RUBY_PLATFORM =~ /linux/ or RUBY_PLATFORM =~ /darwin/)

  # Share directories for project data and various caches
  config.vm.share_folder "apt-cache", "/var/cache/apt/archives", "#{current_dir}/tmp/apt/cache", :nfs => nfs_flag
  config.vm.share_folder "drush-cache", "/home/vagrant/.drush/cache", "#{current_dir}/tmp/drush/cache", :nfs => nfs_flag
  config.vm.share_folder "html", "/mnt/www/html", "#{current_dir}/data/html", :nfs => nfs_flag

  config.vm.forward_port 80, 8080, :auto => true
  config.vm.forward_port 3306, 9306

  # Uncomment for testing, to speed up initial provisioning by preventing the
  # vbguest Vagrant plugin from upgrading the Virtualbox Guest Additions.
  #config.vbguest.no_install = true

  # Update Chef in VM to specific version before running provisioner
  config.vm.provision :shell do |shell|
    shell.path = "config/upgrade_chef.sh"
    shell.args = "10.14.2" # Chef version
  end

  config.vm.provision :chef_solo do |chef|
    chef.roles_path = "roles"

    chef.cookbooks_path = [ "cookbooks", "cookbooks-override", "cookbooks-projects" ]

    # Set up basic environment
    chef.add_role "ariadne"
    unless yml['repo_url'].empty?
      chef.add_recipe "ariadne::install_profile"
    else
      chef.add_recipe project
    end

    # Option so cookbooks can wipe files when set on command-line
    clean = true unless ENV['clean'].nil?

    chef.json = {
      "mysql" => {
        "server_debian_password" => "root",
        "server_root_password"   => "root",
        "server_repl_password"   => "root",
        "allow_remote_root" => true,
        "bind_address" => "0.0.0.0",
      },
      "ariadne" => {
        "project" => project,
        "repo_url" => repo_url,
        "branch" => branch,
        "clean" => clean,
      }
    }
  end
end
