# Ariadne [![Pronunciation](http://cdn4.iconfinder.com/data/icons/cc_mono_icon_set/blacks/16x16/sound_high.png)](http://static.sfdict.com/dictstatic/dictionary/audio/luna/A06/A0674700.mp3)

[![Build Status][travisci-badge]][travisci]
[![Dependency Status][gemnasium-badge]][gemnasium]
[![Code Climate][codeclimate-badge]][codeclimate]

**Ariadne is in active development at Myplanet Digital, and should be
considered beta code. Although we dogfood the project, stability and
full documentation not yet guaranteed.**

> Remember, Ariadne, you are the dreamer, you build this world. I am the
> subject, my mind populates it.
>
> *-- Cobb, Inception*

- Source: https://github.com/myplanetdigital/ariadne

Ariadne is a standardized virtual machine (VM) development environment for
easily developing Drupal sites in a local sandbox that is essentially identical
to a fully-configured hosted solution. Once several simple system requirements
have been met, it can be set up using only a few commands from your computer's
terminal.

It attempts to emulate Acquia's infrastructure as closely as possible (with
added development tools), using cookbooks and roles that can easily be used to
deploy an actual cluster.

Ariadne has been tested on Mac OS/X Snow Leopard & Lion and Ubuntu 12.04 (and it
should work on other flavours of Linux). Theoretically, Vagrant should support
Windows as well, although Ariadne has not been tested on it.

## How It Works

Vagrant uses Virtualbox to boot a stripped-down virtual machine image, and then
uses the Chef configuration management tool (one of the few components installed
on the VM initially) to bring that blank slate into a fully configured state.

The guest virtual machine is configured identically, regardless of the host
computer's operating system and configuration.

## Requirements

*Tested versions in parentheses.*

- [Virtualbox][vbox-downloads] (4.1.23)
- [Vagrant][about-vagrant] (1.0.3)
- [Ruby version manager (RVM)][about-rvm] (1.14.1), installed by running:

        $ curl -L get.rvm.io | bash -s 1.16.7 # Install/Update RVM

  After this is done, you should open a new shell. If you are sure that you
  already have rvm installed, you can run `rvm reload` instead.

- On OS/X:
    - [OSX GCC Installer][about-osx-gcc-installer] (10.6) or Xcode (note that
    Xcode may not be fully tested).
- On Ubuntu (`sudo apt-get install` these):
    - `build-essential` (11.5ubuntu2)
    - `libssl-dev` (1.0.1-4ubuntu5.2)
    - `libreadline5` (5.2-11)
    - `libreadline-gplv2-dev` (5.2-11) - called `libreadline5-dev` on natty
      (11.04) or earlier
    - `zlib1g` (1:1.2.3.4.dfsg-3ubuntu4)
    - `zlib1g-dev` (1:1.2.3.4.dfsg-3ubuntu4)
    - `nfs-common` (1:1.2.5-3ubuntu3)
    - `nfs-kernel-server` (1:1.2.5-3ubuntu3)

## Quick Start

Run these commands to set up Ariadne:

    git clone https://github.com/myplanetdigital/ariadne.git
    cd ariadne
    # The RVM configuration script (.rvmrc) script will now run and ensure you
    # have the right version of ruby and the correct gems.
    rake setup # Runs first-time setup commands

You're now set up and ready to boot a machine. This can be either the simple
**demo** site (packaged with Ariadne), or full-fledged **Ariadne project**.

### Booting a demo

If you'd like to spin up the demo site (currently a simple Drupal install on a
basic virtual machine), just run this command:

    $ vagrant up

This command will take a while to finish the first time you run it, because
Vagrant must download the disk image for the guest operating system (which can
be several hundred megabytes in size), and set up the virtual machine's
hard-drive for the first time (which involves downloading and installing any
required software to the guest machine).

When it's done, you can visit http://example.dev/ to view the demo website!

### Booting an Ariadne project

If you already have an Ariadne project (basically a Chef cookbook), you can boot
that instead of the demo.

Either place the Ariadne project in the `cookbooks-projects` folder, or run

    $ rake "init_project[GITURL]" # don't forget the quotes!

to clone the project at the specified [Git URL][git-url-docs] into the correct
folder for you. Note that for your typing convenience, it will remove the prefix
`ariadne-` from the folder name if it exists.

Once the project is in place, run

    $ project=FOLDERNAME vagrant up

to spin up the project. The `project=FOLDERNAME` tells Chef which folder in
`cookbooks-projects` to use for the final provisioning step.

### After booting

After the demo or project-specific VM has spun up, here are several commands
that might be useful:

    $ rake send_gitconfig                  # Send your personal gitconfig to the virtual machine.
    $ vagrant ssh-config >> ~/.ssh/config  # Adds an entry to your ssh config.

Congratulations! You now have a configured server image on your local
machine, available at http://example.dev!

#### Ariadne Project

Since Ariadne can also be used to spin up specific Ariadne projects, you
can also run this with a [Git URL][git-url-docs] pointing to an Ariadne
project repo.

    $ rake "init_project[GITURL]"
    $ project=PROJECTNAME vagrant up

An Ariadne project is basically a Chef cookbook to take the VM through
the last mile of project-specific configuration. An example of an
Ariadne project cookbook is available in the
`cookbooks-projects/example` folder of this project, which is run when
setting up the demo site above.

The Rake command in the code above clones the specified repository into the
`cookbooks-projects` folder (removing the `ariadne-` from the new directory
name if it exists). This folder is shared with the guest machine. The
`project=PROJECTNAME` tells Chef which folder in `cookbooks-projects` to use
for the final provisioning step.

For simple Drupal projects, you could copy the `cookbooks-override/ariadne`
folder and use it as a basis for your own Ariadne project.

## Goals

- Use your preferred tools from the local host machine
  (Drush, IDE, etc.)
- Changes should be immediately observable in browser
- Implement as little server configuration as possible that is specific
  to the Vagrant environment. It will strive to be as "production-like"
  as possible.
- Configured with advanced performance tools (Varnish,
  Memcache, APC, etc.)
- Configured with Percona, the drop-in MySQL replacement used by
  enterprise Drupal hosting providers.
- Configured with debugging tools (xhprof, xdebug, webgrind)
- Provision VM as quickly as possible (persistent shared folders for
  caches)

## Features

### Incredibly standardized environment

We've tried to lock everything down as much as possible, to ensure that
when one user encounters an issue, we all encounter it together. Here
are the tools we've used:

- **Recommended version of Virtualbox** to boot the virtual machines.
- **Standard baseboxes** reliably built with [Veewee][veewee], an
  automated basebox-building tool.
- **Ruby Version Manager (RVM)** to ensure a specific ruby version.
- **Bundler** to ensure specific versions of critical gem packages and
  their dependencies.
- **Librarian** to ensure specific versions of Chef cookbooks are
  used, which in turn ensures identical VM configuration.

### SSH agent forwarding

Your host machine's SSH session is forwarded into the VM, so when you
SSH in or run Chef, the system will have all the same access that you
have on your host machine. In other words, if you can clone a git repo
or SSH into a remote machine from your host machine, you'll be able to
do it on the VM as well. Wahoo!

### Persistent apt cache

Every time Vagrant provisions a machine, the VM must redownload all the
software packages using the apt package manager. Normally the VM caches
all the downloaded files in a special directory, but this directory is lost
whenever a VM is destroyed and rebuilt. For this reason, we share the
directory in `tmp/apt/cache`, so it will persist between VM builds.

### [vagrant-dns server][vagrant-dns]

**OSX only!**

Built-in DNS server for resolving vagrant domains. Server stops
and starts with VM itself, and it can be easily uninstalled (see
vagrant-dns README).

If you find yourself in a broken system state related to URL's that
aren't resolving, there's a rake task to restart vagrant-dns. (You can
list all rake tasks using `rake -T` or `rake -D`.)

## Upgrading

Should you pull changes or switch branches, you'll very likely need to
rerun the setup. At the very least, you should exit and re-enter the
ariadne directory so that RVM will rerun the `.rvmrc` script, where some
setup happens. You should then run `rake setup` again.

If you want to be extra sure that you're running in the same environment
that your version of Ariadne was tested on, rerun the RVM setup script,
then open a new shell. (The version of RVM that Ariadne was tested on
might vary, and this ensure you're using the exact same one.) You can
also ensure that you're using the recommended version of Virtualbox,
verifiable in this README.

## Notes

- <a name="note-gcc-installer" /> Xcode should also work (as opposed to just the OXS GCC installer),
    although it will not always be fully tested.
- <a name="note-ubuntu-reqs" /> If running Ubuntu, there are several required packages:

        apt-get install build-essential libssl-dev libreadline5 zlib1g zlib1g-dev nfs-common nfs-kernel-server

  And one more that depends on your Ubuntu codename version and architecture:
    - Precise 12.04: `apt-get install libreadline-gplv2-dev`
    - Lucid 10.04, 32-bit: `apt-get install lib32readline5-dev`
    - Lucid 10.04, 64-bit: `apt-get install lib64readline5-dev`

- For the demo, the default password is set to "admin" during
  site-install. Also, while the local site can send mail to actual
  email addresses, the default email for admin is set to
  `vagrant@localhost`, so that any sent mail will be readable at
  `/var/mail/vagrant` in the VM. This default is mainly to prevent
  site-install errors, and can be edited via the admin user's account
  page.
- Several configuration settings can be tweaked in the
  `roles/config.yml`: `project`, `basebox`, `memory`, `cpu_count`.
  Alternatively, any one of these can also be set on the command line
  while running vagrant commands, and the values will be written into
  `config.yml`. For example: `memory=2000 cpu_count=4 vagrant reload` will
  reload the VM using 4 cores and with 2GB of RAM.
- These is a special environment variable that can be set for use
  during any vagrant command that results in a chef run: `clean=true
  vagrant provision`. It is up the each external ariadne project cookbook
  to implement this feature, but the intention is that it makes it simpler
  to wipe out any data directories needed to rebuild the site.  For
  example, `vagrant provision` will not run `drush make` and `drush
  site-install` when it detects that the docroot is already present, but
  setting the `clean=true` variable can tell chef to delete the docroot,
  and so the site will be rebuilt as it was during the first chef run.
- If your project's individual ariadne cookbook (for last-mile
  configuration) has implemented it, you can specify the branch of
  your project to build:

        branch=123-story-description clean=true vagrant provision

  Keep in mind that the `branch` flag might not have any effect in
  some case, such as the default `example` project.
- Several baseboxes that are presumed to work for Ariadne are
  available for use: `lucid32` & `lucid64`. (More may be added to
  `config/baseboxes.yml` in the future.)
- Ariadne's DNS resolver is set up to send all `*.dev` domains to the
  localhost, ie. Vagrant.
- Ariadne uses agent forwarding to forward the host machine's ssh
  session into the VM, including keys and passphrases stored by
  ssh-agent. What this means is that your VM will have the same Git/SSH
  access that you enjoy on your local machine.
- The standard MySQL port `3306` inside the VM has been forwarded to
  port `9306` on the local machine. This was done to avoid conflicts
  on systems where `3306` is already in use by MySQL on the local machine.
  When the VM is booted, you may connect your MySQL GUI to port `9306` to
  access the VM's MySQL directly.
- The chef roles installed in the VM are partially configurable via
  `config.yml` or the command-line. Any role in the `roles/` directory
  can be used to build the environment. We are working to allow any
  reasonable combination of roles, but this is still a work in progress.
  Order of roles will affect success of build. These are valid ways to
  build Ariadne:

        roles=acquia,dev_tools vagrant up                       # DEFAULT
        roles=apache2_mod_php,memcache,mysql,drupal vagrant up  # NO VARNISH

## Known Issues

- Having dnsmasq installed on the host computer can lead to unexpected
  behavior related to `resolv.conf` in the VM. This will manifest as a
  failure to upgrade chef (via rubygems) during boot, right off the bat.
- Various issues like DNS, network connectivity, easy gitconfig setup,
  etc.  can be dealt with using the various rake tasks. To see all the
  available tasks and their descriptions, run `rake -T` (for short
  descriptions) or `rake -D` (for full descriptions).
- When `cd`ing into non-root of project directory, for example
  `ariadne/data`, `.rvmrc` will create new directories relative to
  that dir. See notes in the `.rvmrc` for info on why normal bash script
  approach is avoided.
- It seems that some network connections (seems to be Rogers-related),
  will result in misconfigurations of `/etc/resolv.conf` in the VM. If
  your VM is unable to download packages or run `apt-get update`, please
  compare the `/etc/resolv.conf` of the VM with that on your host computer
  (which presumeably works fine). Copy the relevant bits from your host
  machine. Working on sorting out the origins of this.
- Oh god. The lucid64 basebox is 64 bit, so you must have a system
  running in 64-bit mode in order to boot it. Some models of 64-bit
  Macbooks will boot to 32-bit mode by default. Please run `uname -m` and
  ensure the system architecture is `x86_64`. (Alternatively, `i386`
  indicates 32-bit mode.) [This Apple knowledgebase
  article][apple-sys-arch] should help you configure your machine
  correctly if it's not already.
- Ariadne has been tested with a lucid64 basebox that was built on
  **2012-05-07T21:00:04Z**. Please consider downloading a newer build
  if yours is out of date. To see when your basebox was built, run this
  command:

        $ sed -n 's/.*lastStateChange="\(.*\)".*/\1/p' ~/.vagrant.d/boxes/lucid64/box.ovf

- LogMeIn Hamachi is known to cause issues with making `pear.php.net`
  unreachable, and so the environment won't build.
- Sometimes you might get an error like this while running `vagrant up`:

        The VM failed to remain in the "running" state while attempting to boot.
        This is normally caused by a misconfiguration or host system incompatibilities.
        Please open the VirtualBox GUI and attempt to boot the virtual machine
        manually to get a more informative error message.

    Should this occur, running `vagrant reload` seems to skirt the issue
    until you have time to restart your system.

- If vagrant seems to freeze at "Waiting for VM to boot", try
  cancelling (CTRL-C on Mac) and running `vagrant reload`. This will
  usually go away after a system restart anyhow.

## To Do

https://github.com/myplanetdigital/ariadne/issues

- Doc the need to refresh browser for DNS **or** run dns rake task
  first.
- Create sister project to provide a base install profile that is
  pre-configured to use the advanced components (Memcache, Varnish,
  etc.) In progress: [2ndleveldeep][2ndleveldeep-profile]
- Either avoid using the confusing word "host" (vs "guest" VM) to
  describe local machine, or define terminology somewhere.
- Add proper string support using `i18n` gem.
- Convert to rubygem?
- Convert example project to use `drush qd --no-server`.

## License and Author

Author:: [Patrick Connolly][patcon] (<patrick@myplanetdigital.com>)
[![endorse][coderwall-badge]][coderwall]

Contributors:: https://github.com/myplanetdigital/ariadne/contributors

Copyright:: 2012, Myplanet Digital, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

<!-- Links -->
   [patcon]:                  http://about.me/patcon
   [coderwall]:               http://coderwall.com/patcon
   [coderwall-badge]:         http://api.coderwall.com/patcon/endorsecount.png
   [codeclimate]:             https://codeclimate.com/github/myplanetdigital/ariadne
   [codeclimate-badge]:       https://codeclimate.com/badge.png
   [gemnasium]:               https://gemnasium.com/myplanetdigital/ariadne
   [gemnasium-badge]:         https://gemnasium.com/myplanetdigital/ariadne.png 
   [travisci]:                http://travis-ci.org/myplanetdigital/ariadne
   [travisci-badge]:          https://secure.travis-ci.org/myplanetdigital/ariadne.png?branch=develop
   [condel]:                  https://github.com/myplanetdigital/condel
   [CD-summary]:              http://continuousdelivery.com/2010/02/continuous-delivery/
   [about-rvm]:               https://rvm.io/
   [about-vagrant]:           http://vagrantup.com/
   [about-cap]:               https://github.com/capistrano/capistrano/wiki
   [about-vagrant-kick]:      https://github.com/arioch/vagrant-kick#readme
   [install-rvm]:             http://beginrescueend.com/rvm/install/
   [about-osx-gcc-installer]: https://github.com/kennethreitz/osx-gcc-installer#readme
   [about-xdebug]:            http://xdebug.org/
   [install-xdebug-emacs1]:   http://code.google.com/p/geben-on-emacs/source/browse/trunk/README
   [install-xdebug-emacs2]:   http://puregin.org/debugging-php-with-xdebug-and-emacs-on-mac-os-x
   [vbox-downloads]:          http://www.virtualbox.org/wiki/Downloads
   [vagrant-dns]:             https://github.com/BerlinVagrant/vagrant-dns#readme
   [network-fix-ref]:         http://stackoverflow.com/questions/10378185/vagrant-a-better-to-way-to-reset-my-guest-vagrant-vms-network
   [install-zsh]:             http://jesperrasmussen.com/switching-bash-with-zsh
   [install-oh-my-zsh]:       https://github.com/robbyrussell/oh-my-zsh#setup
   [apple-sys-arch]:          http://support.apple.com/kb/ht3773
   [2ndleveldeep-profile]:    https://github.com/myplanetdigital/2ndleveldeep#readme
   [git-url-docs]:            http://git-scm.com/docs/git-clone#_git_urls
   [gitflow]:                 https://github.com/nvie/gitflow#readme
   [veewee]:                  https://github.com/jedi4ever/veewee#readme
