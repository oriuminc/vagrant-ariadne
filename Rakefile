class String
  # Strip leading whitespace from each line that is the same as the 
  # amount of whitespace on the first line of the string.
  # Leaves _additional_ indentation on later lines intact.
  # SEE: http://stackoverflow.com/a/5638187/504018
  def unindent
    gsub /^#{self[/\A\s*/]}/, ''
  end
end

desc "Prepare Ariadne environmnet to spin up a project.

This runs librarian-chef to install cookbooks, creates properly-permissioned
temporary vagrant-dns files, and creates several empty directories required for
sharing with the VM."
task :setup do
  # Write the config file if doesn't exist.
  unless File.exists?("roles/config.yml")
    p "Creating roles/config.yml..."
    conf = File.open("roles/config.yml", "w")
    conf.puts <<-EOF.unindent
      ---
      basebox: lucid64
      project: example
      branch: develop
      memory: 1000
      cpu_count: 2
      roles: acquia,dev_tools

      # If building an install profile according to Myplanet layout assumptions,
      # enter its repository URL here. (Otherwise, leave blank.)
      repo_url: ''
    EOF
    conf.close
  end
  p "Installing cookbooks using Librarian gem..."
  system "librarian-chef install"
  if RUBY_PLATFORM =~ /darwin/
    p "Starting vagrant-dns server..."
    p "(You may be prompted for your system password.)"
    system "vagrant dns --restart"
    system "rvmsudo vagrant dns --install"
  end

  rel_dirs = %w{
    tmp/apt/cache/partial
    tmp/drush/cache
    data/html
    data/make
    data/profiles
    cookbooks-projects
  }
  p "Creating required directories:"
  rel_dirs.each do |rel_dir|
    p rel_dir
    abs_dir = File.join(Dir::pwd, rel_dir)
    FileUtils.mkdir_p abs_dir
  end
end

desc "Import an Ariadne project from an external git repo.

If the repo name is prefixed with 'ariadne-', this will be stripped before
cloning to `cookbooks-projects`."
task :init_project, [:repo] do |t, args|
  repository_name = args.repo.sub(/\.git$/, '').split(/([\w-]+)?$/)[-1]
  project_name = repository_name.sub(/^ariadne-/, '')
  system "git clone #{args.repo} cookbooks-projects/#{project_name}"
end

desc "Restarts the network service inside the VM.

This often needs to be run when you've changes wifi hotspots or have been
disconnected temporily. If the VM is taking a long to time provision, or timing
out, run this task."
task :fix_network do
  require 'vagrant'
  env = Vagrant::Environment.new
  env.vms.each do |id, vm|
    raise Vagrant::Errors::VMNotCreatedError if !vm.created?
    raise Vagrant::Errors::VMNotRunningError if vm.state != :running

    vm.channel.sudo("/etc/init.d/networking restart")
  end
end

desc "Clear DNS cache and restart resolver. (OSX only!)

Sometimes the Mac's DNS resolver controlled by vagrant-dns can go wonky. This
will clear the Mac's DNS cache and restart the vagrant-dns resolver."
task :restart_dns do
  # Raise exception immediately unless running OSX
  raise "vagrant-dns only works on OSX!" unless RUBY_PLATFORM =~ /darwin/

  p "Uninstalled DNS resolver..."
  p "(You may be prompted for your system password.)"
  system "rvmsudo vagrant dns --uninstall"

  p "Removing temporary files..."
  system "rm -r ~/.vagrant.d/tmp/dns"

  p "Restarting DNS server..."
  system "vagrant dns --restart"

  p "Re-installing DNS resolver..."
  system "rvmsudo vagrant dns --install"

  p "Flushing OSX DNS cache..."
  system "scacheutil -flushcache"
end

desc "Transfers your user-specific .gitconfig to the VM.

While this will transfer lots of personal settings into the VM, it perhaps most
importantly ensures that your commits are tied to your name and email. This
will ensure that your commits are properly linked your GitHub account."
task :send_gitconfig do
  require 'vagrant'
  env = Vagrant::Environment.new
  env.vms.each do |id, vm|
    raise Vagrant::Errors::VMNotCreatedError if !vm.created?
    raise Vagrant::Errors::VMNotRunningError if vm.state != :running

    ssh_info = vm.ssh.info
    ssh_host = ssh_info[:host]
    ssh_port = ssh_info[:port]
    ssh_user = ssh_info[:username]
    private_key_path = ssh_info[:private_key_path]

    system "scp -i #{private_key_path} -P #{ssh_port} ~/.gitconfig #{ssh_user}@#{ssh_host}:~"
    raise "Could not find .gitconfig in home directory (~)." if $? != 0
    puts ".gitconfig sent to #{vm.name} VM!"
  end
end

desc "WARNING! Will bring Ariadne back to a pristine state, good-as-new.

This will:
* uninstall the DNS resolver and tmp vagrant-dns files
* destroy the VM
* delete cookbooks, gems, apt packages, project-specific data & tmp dns files
* remove ariadne ruby version and source"
task :fresh_start do
  system "rvmsudo vagrant dns --uninstall"
  system "vagrant destroy --force"
  system "rm -r ~/.vagrant.d/tmp/dns"
  system "rm -rf tmp/ cookbooks/ .bundle/"
  system "chmod -R u+w data/html/; rm -rf data/html data/make cookbooks-projects/*;"
  system "rvm remove 1.9.3-p194-ariadne"
end

namespace :test do
  desc "Runs foodcritic linter"
  task :foodcritic do
    if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
      cmd = %w{
        bundle exec foodcritic cookbooks*/*
        --include test/support/foodcritic/*
        --epic-fail any
        --tags ~CINK001
        --tags ~FC011
        --tags ~FC031
      }
      sh cmd.join(" ")
    else
      puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
    end
  end

  desc "Runs knife cookbook test"
  task :knife do
    cmd = %w{
      bundle exec knife cookbook test
      $(ls -m cookbooks-override | tr -d ',')
      $(ls -m cookbooks-projects | tr -d ',')
      --config=test/support/knife.rb
    }
    sh cmd.join(" ")
  end
end
