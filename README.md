Ariadne
=======

[![Build Status](https://secure.travis-ci.org/myplanetdigital/ariadne.png?branch=develop)](http://travis-ci.org/myplanetdigital/ariadne)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/myplanetdigital/ariadne)

> Remember, Ariadne, you are the dreamer, you build this world. I am the
> subject, my mind populates it.
>
> *-- Cobb, Inception*

  - Source: https://github.com/myplanetdigital/ariadne

**Ariadne is in active development at Myplanet Digital, and should be
considered alpha code. Stability and full documentation not yet
guaranteed.**

Ariadne is a standardized virtual machine (VM) development environment
for easily developing Drupal sites in a local sandbox that is
essentially identical to a fully-configured hosted solution. It attempts
to emulate a dedicated Acquia/Pantheon server as closely as possible,
with added development tools. Once several simple system requirements
have been met, it can be set up using only a few commands from your
computer's terminal.

The current iteration aims to create a local Vagrant environment that mimics Acquia's
infrastructure as closely as possible, using cookbooks and roles that can easily be
used to deploy an actual cluster.

Tested on Mac OSX Snow Leopard & Lion and Ubuntu 12.04 (should work on
other flavours of Linux).

How It Works
------------

Vagrant uses Virtualbox to boot a stripped-down VM image, and then uses
the Chef configuration management tool (one of the few components
installed on the VM initially) to bring that blank slate into a fully
configured state.

The VM will be configured identically whether installed on Mac or Linux.
(Theoretically, Vagrant supports Windows as well, although Ariadne
is untested in this respect.)

Requirements
------------

*Tested versions in parentheses.*

  - [Virtualbox and Extension Pack][vbox-downloads] [[Note]](#note-vbox) (v4.1.22)
  - [OSX GCC Installer][about-osx-gcc-installer] [[Note]](#note-gcc-installer)
  - [RVM][about-rvm] (v1.15.8) - Dealt with in "Quick Start" below

For Ubuntu, you'll need to install the following packages:

    apt-get install build-essential libssl-dev libreadline5 libreadline-gplv2-dev zlib1g zlib1g-dev nfs-common nfs-kernel-server

Quick Start
-----------

### Setup

    $ curl -L get.rvm.io | bash -s 1.15.8    # Install/Update RVM
    $ rvm reload                             # Reloads RVM
    $ git clone https://github.com/myplanetdigital/ariadne.git
    $ cd ariadne                             # rvmrc script will run
    $ rake setup                             # Runs first-time setup commands

You're now set up and ready to boot a machine. This can be either a demo
site, or a specific project.

### Booting

Ariadne can be used to boot a simple **demo** or an **Ariadne project**.
Instructions for each are given in the following sections, but first
we'll note a few general items that apply to any approach:

  - After the demo or project-specific VM has spun up, here are several
    commands that might be useful:

        $ rake send_gitconfig                    # Send your personal gitconfig to VM
        $ vagrant ssh-config >> ~/.ssh/config    # OPTIONAL: Adds entry to ssh config

  - The `vagrant up` command will take quite some time regardless, but
    it will take longer on the first run, as it must download a basebox
    VM image, which can be several hundred MB.

#### Demo

If you'd like to spin up the demo site (currently a simple Drupal
install), just run this command:

    $ vagrant up

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

Goals
-----

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

Features
--------

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

Upgrading
---------

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

Notes
-----

<a name="note-vbox" />
  - Be sure to install your version's matching "Extension Pack" from the
    download page, as it contains the correct version of the [Virtualbox
    Guest Additions][vbox-guest] package. This provides utlities intended to
    be installed on any VM running on VBox. Thankfully, we'll be using a
    [Vagrant plugin called vbguest][vagrant-vbguest], which will handle
    copying this package into any VM that is out of date.
<a name="note-gcc-installer" />
  - Xcode should also work (as opposed to just the OXS GCC installer),
    although it will not always be fully tested.
  - For the demo, the default password is set to "admin" during
    site-install. Also, while the local site can send mail to actual
    email addresses, the default email for admin is set to
    `vagrant@localhost`, so that any sent mail will be readable at
    `/var/mail/vagrant` in the VM. This default is mainly to prevent
    site-install errors, and can be edited via the admin user's account
    page.
  - Several configuration settings can be tweaked in the
    `config/config.yml`: `project`, `basebox`, `memory`, `cpu_count`.
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
    on systems with `3306` is already in use by MySQL on the local machine.
    When the VM is booted, you may connect your MySQL GUI to port `9306` to
    access the VM's MySQL directly.
  - If your `config/config.yml` file is showing up as altered when
    running `git status`, and you'd like git to [un]ignore it locally:

        git update-index --[no-]assume-unchanged config/config.yml

Known Issues
------------

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

    Should this occur, running `vagrant reload` seems to skirt the issue.


To Do
-----

https://github.com/myplanetdigital/ariadne/issues

* Doc the need to refresh browser for DNS **or** run dns rake task
  first.
* Create sister project to provide a base install profile that is
  pre-configured to use the advanced components (Memcache, Varnish,
  etc.) In progress: [2ndleveldeep][2ndleveldeep-profile]
* Either avoid using the confusing word "host" (vs "guest" VM) to
  describe local machine, or define terminology somewhere.
* Add proper string support using `i18n` gem.
* Convert to rubygem?
* Convert example project to use `drush qd --no-server`.

Contributing
------------

Ariadne is being developed using the [git-flow tool][gitflow] and
methodology. The take-home message is that pull requests should be
submitted to the `develop` branch.

Here's the gist of how we're applying it:

  - New features happen on `develop` branch, not `master`.
  - Release branches are created in preparation for a tagged release,
    and only bugfixes happen on release branches.
  - When it seems all bugs are fixed on release branch, it's merged into
    `master`, tagged, and the release branch is removed.
  - When developing new features on `develop`, feature branches are
    recommended.

License and Author
------------------

Author:: [Patrick Connolly][patcon] (<patrick@myplanetdigital.com>)
[![endorse](http://api.coderwall.com/patcon/endorsecount.png)](http://coderwall.com/patcon)

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
   [vbox-guest]:              http://www.virtualbox.org/manual/ch04.html#idp5980192
   [vagrant-vbguest]:         https://github.com/dotless-de/vagrant-vbguest#readme
   [vagrant-dns]:             https://github.com/BerlinVagrant/vagrant-dns#readme
   [network-fix-ref]:         http://stackoverflow.com/questions/10378185/vagrant-a-better-to-way-to-reset-my-guest-vagrant-vms-network
   [install-zsh]:             http://jesperrasmussen.com/switching-bash-with-zsh
   [install-oh-my-zsh]:       https://github.com/robbyrussell/oh-my-zsh#setup
   [apple-sys-arch]:          http://support.apple.com/kb/ht3773
   [2ndleveldeep-profile]:    https://github.com/myplanetdigital/2ndleveldeep#readme
   [git-url-docs]:            http://git-scm.com/docs/git-clone#_git_urls
   [gitflow]:                 https://github.com/nvie/gitflow#readme
   [veewee]:                  https://github.com/jedi4ever/veewee#readme
