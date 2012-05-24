Ariadne
=======

> Remember, Ariadne, you are the dreamer, you build this world. I am the
> subject, my mind populates it.
>
> *-- Cobb, Inception*

 * Source: https://github.com/myplanetdigital/ariadne

This project aims to create a local Vagrant environment that mimics Acquia's
infrastructure as closely as possible, using cookbooks and roles that can easily be
used to deploy an actual cluster.

This environent is being built in conjunction with a base installation
profile. Currently, this experimentation is being done with the [ConDel base
install profile][condel]. This is necessary, since many server
configurations can only be fully utilized with specific site
configuration. The long-term goal is to create an install profile that
is amenable to using Drupal in a development workflow, that utlizes
[Continuous Delivery][CD-summary] practices.

Quick Start
-----------

If you have any issues, please ensure you've installed the following
recommended software versions, which have been tested to work:

* [RVM](#req-rvm) v1.13.8
* [Virtualbox _and Extension Pack_](#req-vbox) v4.1.16

Run the following on the first run, cloning as needed:

```sh
$ curl -L get.rvm.io | bash -s stable    # Install RVM
$ source ~/.rvm/scripts/rvm
$ chmod +x ~/.rvm/hooks/after_cd_bundler # Activate Bundler RVM hook
$ exec $SHELL                            # Reload your shell
$ git clone https://github.com/myplanetdigital/ariadne.git
$ cd ariadne                             # rvmrc script will run
$ rvmsudo vagrant dns --install          # Install DNS server (OSX only)
$ vagrant up                             # Spin up VM
$ rake send_keys                         # Transfer RSA keypair to VM
$ vagrant ssh-config >> ~/.ssh/config    # OPTIONAL: Adds entry to ssh config
```

### TODO

* Doc DNS and where site will be accessible:


    http://PROJECTNAME.dev

* Doc how `project=PROJECTNAME vagrant up` will boot a specific
  project (and will write to `config/config.ini` so only need once).
* Doc format that Ariadne expects for this project repo.
* Doc rake tasks.

Goals
-----

 * Use your preferred tools from the local host machine
   (Drush, IDE, etc.)
 * Changes should be immediately observable in browser
 * Implement as little code as possible that is specific to the
   Vagrant environment. It will strive to be as "production-like" as
   possible.
 * Configure VM with advanced performance tools (Varnish,
   Memcache, etc.)
 * Configure VM with debugging tools (xhprof, xdebug, webgrind)
 * Allow apt packages to persist between VM builds (shared folder)
 * Allow downloaded modules to be cached in such a way as to persist
   between VM builds (eg. shared folder)
 * Can deploy working site easily from:
    1) install profile, or
    2) site-as-repo
 * Install profiles:
    * are simple to run, even for uncommitted changes
    * are able to append arbitrary settings.php snippets
 * Both install profiles & site-as-repos:
    * should be able to import DB dumps (remote or local)
 * Should ALWAYS be able to push to remote repo, even after install
   profile run from uncommitted changes

Requirements
------------

<a name="req-vbox" />
### Virtualbox

[Downloads page][vbox-downloads]

Be sure to install your version's matching "Extension Pack" from the
download page, as it contains the correct version of the
[Virtualbox Guest Additions][vbox-guest] package. This provides utlities
intended to be installed on any VM running on VBox. Thankfully, we'll be
using a [Vagrant plugin called vbguest][vagrant-vbguest], which will
handle copying this package into any VM that is out of date.

### [OSX GCC Installer][about-osx-gcc-installer]

Xcode should also work, although it will not always be fully tested.

<a name="req-rvm" />
### [RVM][about-rvm]

[Full installation instructions][install-rvm]

#### Quick Install

```
$ curl -L get.rvm.io | bash -s stable
$ source ~/.rvm/scripts/rvm
```

Recommended
-----------

### Persistent apt cache

Every time Vagrant provisions a machine, the VM must redownload all the
software packages using the apt package manager. While the VM caches
all the downloaded files in a special directory, this directory is lost,
whenever a VM is destroyed and rebuilt. To persist this cache directory
as a shared directory, run this from the root dir of this git repo:

```sh
$ mkdir -p data/apt-cache/partial
```

### [vagrant-dns server][vagrant-dns]

Built-in DNS server for resolving vagrant domains on OSX. Server stops
and starts with VM itself, and it can be easily uninstalled (see
vagrant-dns README).

If you find yourself in a broken system state related to URL's that
aren't resolving, restart vagrant-dns fresh with the following:

```sh
$ rvmsudo vagrant dns --uninstall
$ rm -r ~/.vagrant.d/tmp/dns
$ rvmsudo vagrant dns --install
$ vagrant reload
```

Misc Notes
----------

* For example.rb (which might be temporary), the default password is set
to "admin" during site-install. Also, while the local site can send mail
to actual email addresses, the default email for admin is set to
vagrant@localhost, so that any sent mail will be readable at /var/mail/vagrant
in the VM. This default is mainly to prevent site-install errorsm, and
can be edited on the Drupal's user page for the admin.

Development Tools
=================

## [Xdebug][about-xdebug]

Known Issues
============

* Having dnsmasq installed on the host computer can lead to unexpected
  behavior related to `resolv.conf` in the VM. This will manifest as a
  failure to upgrade chef (via rubygems) during boot, right off the bat.
* Sometimes if you lose internet connection on your host, the network
  inside the VM must be reset. [[Reference][network-fix-ref]] If you
  experience a lack of connectivity in your VM, run this from the host:


    $ rake fix_network

   [condel]:                  https://github.com/myplanetdigital/condel
   [CD-summary]:              http://continuousdelivery.com/2010/02/continuous-delivery/
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
