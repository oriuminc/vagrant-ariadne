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

This environent is being built in conjunction with the [ConDel base
install profile][condel]. This is necessary, since many server
configurations can only be fully utilized with specific site
configuration. The long-term goal is to create an install profile that
is amenable to using Drupal in a development workflow, that utlizes
[Continuous Delivery][CD-summary] practices.

Quick Start
-----------

If you have any issues, please ensure you've installed the following
recommended software versions, which have been tested to work:

* [RVM](#req-rvm) v1.10.2
* [Virtualbox _and Extension Pack_](#req-vbox) v4.1.12

Run the following on the first run, cloning as needed:

    $ chmod +x ~/.rvm/hooks/after_cd_bundler                    # Activate Bundler RVM hook
    $ exec $SHELL                                               # Reload your shell
    $ git clone https://github.com/myplanetdigital/ariadne.git
    $ cd ariadne
    $ librarian-chef install              # Install cookbooks from Cheffile.lock
    $ vagrant up                          # Spin up VM
    $ vagrant ssh_config >> ~/.ssh/config # Adds a project entry to ssh config

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
### [RVM][about-rvm] (

[Installation instructions][install-rvm]

To ensure you get the right version of RVM, run this variation of the
install script:

    curl -L https://github.com/wayneeseguin/rvm/blob/1.13.0/binscripts/rvm-installer | bash -s stable

(You may trivially remove RVM at any time, without lasting effect, by
running `rvm implode` and reversing any of the manual changes made in
following paragraphs.)

Please note that RVM will add its load commands to `.bash_profile` by
default. Depending on your shell, this may not be appropriate. (For
example, Zsh usually needs the command in `.zshrc`).

After installation, if you open up a new shell and the `rvm` command
doesn't exist, type the following (replacing `.bash_profile` as
appropriate for your shell):

    $ echo '# Load RVM function' >> ~/.bash_profile
    $ echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"' >> ~/.bash_profile
    $ source ~/.bash_profile

Recommended
-----------

### Persistent apt cache

Every time Vagrant provisions a machine, the VM must redownload all the
software packages using the apt package manager. While the VM caches
all the downloaded files in a special directory, this directory is lost,
whenever a VM is destroyed and rebuilt. To persist this cache directory
as a shared directory, run this from the root dir of this git repo:

    $ mkdir -p data/apt-cache/partial

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
???MANY LINES MISSING

Known Issues
============

* Having dnsmasq installed on the host computer can lead to unexpected
  behavior related to `resolv.conf` in the VM. This will manifest as a
  failure to upgrade chef (via rubygems) during boot, right off the bat.

   [condel]:                 https://github.com/myplanetdigital/condel
   [CD-summary]:             http://continuousdelivery.com/2010/02/continuous-delivery/
   [about-vagrant]:          http://vagrantup.com/                                              
   [about-cap]:              https://github.com/capistrano/capistrano/wiki                      
   [about-vagrant-kick]:     https://github.com/arioch/vagrant-kick#readme                      
   [install-rvm]:            http://beginrescueend.com/rvm/install/                             
   [about-osx-gcc-installer]: https://github.com/kennethreitz/osx-gcc-installer#readme
   [about-xdebug]:           http://xdebug.org/                                                 
   [install-xdebug-emacs1]:  http://code.google.com/p/geben-on-emacs/source/browse/trunk/README 
   [install-xdebug-emacs2]:  http://puregin.org/debugging-php-with-xdebug-and-emacs-on-mac-os-x 
   [vbox-downloads]:         http://www.virtualbox.org/wiki/Downloads
   [vbox-guest]:             http://www.virtualbox.org/manual/ch04.html#idp5980192
   [vagrant-vbguest]:       https://github.com/dotless-de/vagrant-vbguest#readme
