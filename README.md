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

- Source: https://github.com/myplanetdigital/vagrant-ariadne

Ariadne is a standardized virtual machine (VM) development environment for
easily developing Drupal sites in a local sandbox that is essentially identical
to a fully-configured hosted solution. Once several simple system requirements
have been met, it can be set up using only a few commands from your computer's
terminal.

It attempts to emulate Acquia's infrastructure as closely as possible (with
added development tools), using Chef cookbooks and roles that can easily be used
to deploy an actual cluster.

Ariadne has been tested on Mac OS/X Snow Leopard & Lion and Ubuntu 12.04 (and it
should work on other flavours of Linux). Theoretically, it should support
Windows as well, although Ariadne has not been tested on it.

## How It Works

Ariadne is a customized implementation of [Vagrant][about-vagrant].
Vagrant uses Virtualbox to boot a stripped-down virtual machine image,
and then uses the Chef configuration management tool (one of the few
components installed on the VM initially) to bring that blank slate into
a fully configured state.

The guest virtual machine is configured identically, regardless of the host
computer's operating system and configuration.

## Requirements

*Recommended versions in parentheses.*

- [Virtualbox][vbox-downloads] (4.1.23)
- [Ruby version manager (RVM)][about-rvm] (1.16.7)

        curl -L get.rvm.io | bash -s 1.16.7 # Install/Update RVM
        exec $SHELL                         # Relaunch shell

- On OS/X: _Xcode_ or _Command Line Tools for Xcode_

- On Ubuntu:

        apt-get install build-essential libreadline5 libssl-dev nfs-kernel-server

  - Ubuntu > 12.04: `apt-get install libreadline-gplv2-dev`

  - Ubuntu <= 11.04: `apt-get install libreadline5-dev`

## Quick Start

Run these commands to set up Ariadne:

    $ git clone https://github.com/myplanetdigital/vagrant-ariadne.git
    $ cd vagrant-ariadne

The RVM configuration script (.rvmrc) script will now run and ensure you
have the right version of ruby. When it's done, run the setup command
with

    $ rake setup

This is a non-destructive command that will download the correctly
versioned rubygem packages and Chef cookbooks, among other things. You
should run this command any time you upgrade or downgrade Ariadne.

You're now set up and ready to boot a machine. This can be either the simple
**example** site (included with Ariadne), or a full-fledged **Ariadne project**.

### Booting the example

If you'd like to spin up the demo site (currently a simple Drupal install on a
basic virtual machine), just run this command:

    $ vagrant up

This command will take a while to finish the first time you run it, because
Vagrant must download the disk image for the guest operating system (which can
be several hundred megabytes in size), and set up the virtual machine's
hard-drive for the first time (which involves downloading and installing any
required software to the guest machine).

When it's done, you can visit http://example.dev/ to view the example website!

### Booting an Ariadne project

If you already have an Ariadne project (basically a Chef cookbook), you can boot
that instead of the demo.

Either place the Ariadne project in the `cookbooks-projects` folder, or run

    $ rake "init_project[GITURL]" # don't forget the quotes!

to clone the project at the specified [Git URL][git-url-docs] into the
correct directory for you. Note that for your typing convenience, it will
remove the prefix `ariadne-` from the directory name if it exists.

Once the project is in place, run

    $ project=PROJECTNAME vagrant up

to spin up the project. The `project=PROJECTNAME` tells Chef which
directory in `cookbooks-projects` to use for the final provisioning
step.

Your site will be available at http://PROJECTNAME.dev/ when it is done.

### After booting

After the demo or project-specific VM has spun up, here are several commands
that might be useful:

    $ rake send_gitconfig                  # Send your personal gitconfig to the virtual machine.
    $ vagrant ssh-config >> ~/.ssh/config  # Adds an entry to your ssh config.

### At the end of the day

To shut down the virtual machine, run:

    $ vagrant halt

Later, you can run `vagrant up` to start the virtual machine again. This time,
setup will be quite fast because the virtual machine has already been set up.

If you want to rebuild the virtual machine from scratch (which you'll want to do
from time to time, to ensure you haven't introduced any invisible dependencies),
you can run:

    $ vagrant destroy

to delete the virtual hard disk (it won't delete the folder shared between your
computer and the virtual one). Next time you run `vagrant up`, Vagrant will
set up the virtual machine from scratch.

## Ariadne projects

As mentioned, an Ariadne project is just a Chef cookbook to take the VM through
the last mile of project-specific configuration. An example of an Ariadne
project cookbook is available in the `cookbooks-projects/example` folder of this
project. It's the project used to set up the demo site. For simple Drupal
projects, you could copy the example folder and use it as a basis for your own
Ariadne project.

## Deploying (WIP)

Ariadne can theoretically be used to provision a remote dedicated
server using the knife-solo tool. This does not yet work.

Pending deploy instructions:

```
export ARIADNE_PROJECT=myproject
export REMOTE_IP=123.45.67.89
echo -e "\nHost $ARIADNE_PROJECT\n  User root\n  HostName $REMOTE_IP" >> ~/.ssh/config
ssh-forever $ARIADNE_PROJECT -i path/to/ssh_key.pub # Enter root password when prompted.
# Install Chef on the server
knife prepare $ARIADNE_PROJECT --omnibus-version 10.14.4-1
# Run chef-solo on remote server
knife cook $ARIADNE_PROJECT nodes/dna.json --skip-syntax-check --skip-chef-check
```

## Goals and Features

- You can use your preferred tools (text editor, database browser, etc.)
  to work on the website.
- When you make a change, it should be immediately observable in your browser.
- Certain caches are stored in the persistant directory shared between the host
  and guest machines, making it faster to rebuild from scratch.
- Installs tools automatically:
    - Advanced performance tools: Varnish, Memcache, and APC.
    - Percona, the drop-in MySQL replacement used by enterprise Drupal hosting
      providers.
    - Debugging tools: xhprof, xdebug, webgrind.
- Except for the debugging tools, Ariadne strives to implement as little
  Vagrant-specific server configuration as possible (i.e.: strive to be as
  "production-like" as possible).
- E-mails sent by PHP will be forwarded to the nearest mail server, meaning you
  (and potentially, your clients) will recieve e-mails from the virtual machine.

## Differences from vanilla Vagrant

- **Incredibly standardized environment**: We've tried to lock everything down
  as much as possible, to ensure that when one user encounters an issue, we all
  encounter it together. Here are the tools we used:
    - A **recommended version of Virtualbox** to boot the virtual machines.
    - **Standard baseboxes** reliably built with [Veewee][veewee] (an automated
      basebox-building tool).
    - **Ruby Version Manager (RVM)** to ensure Vagrant runs on a specific ruby
      version.
    - **Bundler** to ensure Vagrant and our host-machine tools run on specific
      gem package versions.
    - **Librarian** to ensure specific versions of Chef cookbooks are used,
      which in turn ensures identical VM configuration.
- **SSH agent forwarding**: Your host machine's SSH session is forwarded into
  the VM, so when you SSH in or run Chef, the system will have all the same
  access that you have on your host machine. In other words, you can clone the
  same private git repositories or SSH into the same remote machines from your
  VMs as you can on your host machine.
- **Persistent apt cache**: Every time Vagrant provisions a machine, the VM must
  re-download all the software packages using the apt package manager. Normally
  the VM caches all the downloaded files in a special directory, but this
  directory is lost whenever a VM is destroyed and rebuilt. For this reason, we
  share the directory in `tmp/apt/cache`, so it will persist between VM builds.
- **[vagrant-dns server][vagrant-dns]** (OS/X only): Automatically configures
  a DNS server for resolving domains on virtual machines. This server stops and
  starts with VM itself, and it can be easily uninstalled (see the vagrant-dns
  README).

## Upgrading or debugging Ariadne itself

If you pull changes or switch branches in the Ariadne repository, you'll very
likely need to rerun the setup. At the very least, you should exit and re-enter
the vagrant-ariadne directory so that RVM will rerun the `.rvmrc` script (where some
setup happens). You should then run `rake setup` again.

## Troubleshooting

- If your host machine is not resolving Vagrant URLs and you're running OS/X,
  try running `rake restart_dns`.
- Ensure you are using a basebox with the same architecture as your system. In
  other words, running the lucid64 basebox on a 32-bit system is NOT going to
  work.
  This can be a problem for Snow Leopard users in some cases, because some
  models of 64-bit Macbooks will boot into 32-bit mode by default when running.
  Snow Leopard. Please run `uname -m` and check that the system architecture
  matches your basebox (`x86_64` = 64-bit; `i386` = 32-bit). [This Apple
  knowledgebase article][apple-sys-arch] should help you configure your machine
  correctly if it's not already.

## Notes

- The standard MySQL port `3306` inside the VM has been forwarded to port `9306`
  on the local machine. This was done to avoid conflicts on systems where `3306`
  is already in use by MySQL on the local machine. When the VM is booted, you
  may connect your MySQL GUI to port `9306` to access the VM's MySQL directly.
- Several baseboxes that are presumed to work for Ariadne are available for use:
  `lucid32` & `lucid64`. (More may be added to `config/baseboxes.yml` in the
  future.)
- Ariadne's DNS resolver is set up to send all `*.dev` domains to the localhost,
  ie. Vagrant.
- Ariadne uses agent forwarding to forward the host machine's ssh session into
  the VM, including keys and passphrases stored by ssh-agent. What this means is
  that your VM will have the same Git/SSH access that you enjoy on your local
  machine.

## Tips and tricks

- Several configuration settings can be tweaked in the `roles/config.yml` file:
  `project`, `basebox`, `memory`, `cpu_count`. Alternatively, any one of these
  can also be set on the command line while running vagrant commands, and the
  values will be written into `config.yml`. For example:
  `memory=2000 cpu_count=4 vagrant reload` will reload the VM using 4 cores and
  with 2GB of RAM.
- These is a special environment variable that can be set for use during any
  vagrant command that results in a chef run: `clean=true vagrant provision`. It
  is up the each external ariadne project cookbook to implement this feature,
  but the intention is that it makes it simpler to wipe out any data directories
  needed to rebuild the site.  For example, `vagrant provision` will not run
  `drush make` and `drush site-install` when it detects that the docroot is
  already present, but setting the `clean=true` variable can tell chef to delete
  the docroot, and so the site will be rebuilt as it was during the first chef
  run.
- If your project's individual ariadne cookbook (for last-mile configuration)
  has implemented it, you can specify the branch of your project to build:

        branch=123-story-description clean=true vagrant provision

  Keep in mind that the `branch` flag might not have any effect in some cases,
  such as the default `example` project.
- The chef roles installed in the VM are partially configurable via `config.yml`
  or the command-line. Any role in the `roles/` directory can be used to build
  the environment. We are working to allow any reasonable combination of roles,
  but this is still a work in progress. Order of roles will affect success of
  a build. These are valid ways to build Ariadne:

        roles=acquia,dev_tools vagrant up                       # DEFAULT
        roles=apache2_mod_php,memcache,mysql,drupal vagrant up  # NO VARNISH

## Known Issues

- Having dnsmasq installed on the host computer can lead to unexpected behavior
  related to `resolv.conf` in the VM. This will manifest as a failure to upgrade
  chef (via rubygems) during boot, right off the bat.
- When `cd`ing into non-root of project directory (for example, typing
  `$ cd vagrant-ariadne/data`), RVM will create new directories relative to that
  directory!. See notes in the `.rvmrc` for info on why normal bash script
  approach is avoided.
- It seems that some network connections (especially ones from Rogers Telecom)
  will result in misconfigurations of `/etc/resolv.conf` in the VM. If your VM
  is unable to download packages or run `apt-get update`, please compare the
  `/etc/resolv.conf` of the VM with that on your host computer (which
  presumeably works fine). Copy the relevant bits from your host machine. We're
  working on sorting out the origins of this.
- Ariadne has been tested with a lucid64 basebox that was built on
  **2012-05-07T21:00:04Z**. Please consider downloading a newer build if yours
  is out of date. To see when your basebox was built, run this command:

        $ sed -n 's/.*lastStateChange="\(.*\)".*/\1/p' ~/.vagrant.d/boxes/lucid64/box.ovf

- LogMeIn Hamachi is known to cause issues with making `pear.php.net`
unreachable, and so the environment won't build.
- Sometimes you might get an error like this while running `vagrant up`:

        The VM failed to remain in the "running" state while attempting to boot.
        This is normally caused by a misconfiguration or host system incompatibilities.
        Please open the VirtualBox GUI and attempt to boot the virtual machine
        manually to get a more informative error message.

  Should this occur, running `vagrant reload` may work, but we recommend that
  you restart your system.
- If vagrant seems to freeze at "Waiting for VM to boot", try aborting (CTRL-C)
  and running `vagrant reload`. This will usually go away after a system
  restart.

Please refer to https://github.com/myplanetdigital/vagrant-ariadne/issues?labels=bug&state=open
for a full list of bugs.

## To Do

- Document the need to refresh browser for DNS **or** run dns rake task first.
- Create sister project to provide a base install profile that is pre-configured
  to use the advanced components (Memcache, Varnish, etc.) In progress:
  [2ndleveldeep][2ndleveldeep-profile]
- Either avoid using the confusing word "host" (vs "guest" VM) to describe local
  machine, or define terminology somewhere.
- Add proper string support using `i18n` gem.
- Convert to rubygem?
- Convert example project to use `drush qd --no-server`.

## License and Author

Author:: [Patrick Connolly][patcon] (<patrick@myplanetdigital.com>)
[![endorse][coderwall-badge]][coderwall]

Contributors: https://github.com/myplanetdigital/vagrant-ariadne/graphs/contributors

Copyright: 2012, Myplanet Digital, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

<!-- Links -->
   [patcon]:                  http://about.me/patcon
   [coderwall]:               http://coderwall.com/patcon
   [coderwall-badge]:         http://api.coderwall.com/patcon/endorsecount.png
   [codeclimate]:             https://codeclimate.com/github/myplanetdigital/vagrant-ariadne
   [codeclimate-badge]:       https://codeclimate.com/badge.png
   [gemnasium]:               https://gemnasium.com/myplanetdigital/vagrant-ariadne
   [gemnasium-badge]:         https://gemnasium.com/myplanetdigital/vagrant-ariadne.png
   [travisci]:                http://travis-ci.org/myplanetdigital/vagrant-ariadne
   [travisci-badge]:          https://api.travis-ci.org/myplanetdigital/vagrant-ariadne.png?branch=develop
   [condel]:                  https://github.com/myplanetdigital/condel
   [CD-summary]:              http://continuousdelivery.com/2010/02/continuous-delivery/
   [about-rvm]:               https://rvm.io/
   [about-vagrant]:           http://vagrantup.com/
   [about-cap]:               https://github.com/capistrano/capistrano/wiki
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
