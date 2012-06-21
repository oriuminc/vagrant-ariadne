# -*- mode: ruby -*-
# vi: set ft=ruby :

# Add our custom strings to the load path
I18n.load_path << File.expand_path("../config/locales/en.yml", __FILE__)

current_dir = File.dirname(__FILE__)

# Import configs from YAML file.
yml = YAML.load_file "#{current_dir}/config/config.yml"

# Use 1) ENV variable, then 2) YAML config file
basebox   = ENV['basebox']   ||= yml['basebox']
project   = ENV['project']   ||= yml['project']
memory    = ENV['memory'].to_i    ||= yml['memory'].to_i
cpu_count = ENV['cpu_count'].to_i ||= yml['cpu_count'].to_i

# Raise error if running 64-bit VM on 32-bit host system.
class AriadneError < Vagrant::Errors::VagrantError
  error_key "ariadne_arch_crosscheck"
end
raise AriadneError if basebox.match('64$') && `uname -m`.chomp === 'i386'

# Write property to YAML config file
yml['basebox'] = basebox
yml['project'] = project
yml['memory'] = memory
yml['cpu_count'] = cpu_count
File.open("#{current_dir}/config/config.yml", 'w') { |f| YAML.dump(yml, f) }

Vagrant::Config.run do |config|
  config.vm.define "ariadne"

  # Mash of box names and urls
  baseboxes = {
    "hardy64" => "https://myplanet.box.com/shared/static/pkmp7lus3ojvd4vlusuj.box",
    "lucid64" => "http://files.vagrantup.com/lucid64.box",
    "lucid32" => "http://files.vagrantup.com/lucid32.box",
  }

  config.vm.box = basebox
  config.vm.box_url = baseboxes[basebox]

  config.vm.network :hostonly, "33.33.33.10"

  config.vm.customize ["modifyvm", :id, "--memory", memory]
  config.vm.customize ["modifyvm", :id, "--cpus", cpu_count]

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
  config.vm.share_folder "gem-cache", "/opt/ruby/lib/ruby/gems/1.8/cache", "#{current_dir}/tmp/ruby/1.9.1/cache", :nfs => nfs_flag
  config.vm.share_folder "html", "/mnt/www/html", "#{current_dir}/data/html", :nfs => nfs_flag

  config.vm.forward_port 80, 8080
  config.vm.forward_port 3306, 9306, :auto => true

  # Update Chef in VM to specific version before running provisioner
  config.vm.provision :shell do |shell|
    shell.path = "config/upgrade_chef.sh"
    shell.args = "0.10.8" # Chef version
  end

  config.vm.provision :chef_solo do |chef|
    chef.roles_path = "roles"

    chef.cookbooks_path = [ "cookbooks", "cookbooks-override", "cookbooks-projects" ]

    # Set up basic environment
    chef.add_role "ariadne"

    # Add recipe for example site if no project set.
    project_recipe = project.empty? ? "ariadne::example" : project
    chef.add_recipe project_recipe

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
