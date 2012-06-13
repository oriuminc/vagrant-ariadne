Ariadne
=======

> Remember, Ariadne, you are the dreamer, you build this world. I am the
> subject, my mind populates it.
>
> *-- Cobb, Inception*

* Source: https://github.com/myplanetdigital/ariadne

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

Tested on Mac OSX Snow Leopard & Lion (should work on Linux).

How It Works
------------

Vagrant uses Virtualbox to boot a stripped-down VM image, and then uses
the Chef configuration management tool (one of the few components
installed on the VM initially) to bring that blank slate into a fully
configured state.

The VM will be configured identically whether installed on Mac or Linux.
(Theoretically, Vagrant supports Windows as well, although Ariadne
is untested in this respect.)

Usage
-----

### Requirements

*Tested versions in parentheses.*

* [Virtualbox and Extension Pack][vbox-downloads] [[[Note]](#note-vbox) (v4.1.16)
* [OSX GCC Installer][about-osx-gcc-installer] [[Note]](#note-gcc-installer)
* [RVM][about-rvm] (v1.14.1) - Dealt with in "Quick Start" below

### Quick Start

    $ curl -L get.rvm.io | bash -s 1.14.1                # Install/Update RVM
    $ source ~/.rvm/scripts/rvm
    $ git clone https://github.com/myplanetdigital/ariadne.git
    $ cd ariadne                                         # rvmrc script will run
    $ rake setup                                         # Runs first-time setup commands

You're now set up and ready to boot a machine. If you'd like to spin up
an example project (currently a simple Drupal install), run this
command:

    $ bundle exec vagrant up

Since Ariadne can also be used to spin up specific Ariadne projects, you
can also run this with reference to an Ariadne github project:

    $ bundle exec rake "init_project[USERNAME/REPO]"
    $ project=PROJECTNAME bundle exec vagrant up

Please see the project repo README for more specific instructions.


**Note:** Unfortunately, there are currently no public examples of the format
expected for an Ariadne project repo, but we will try to make one
available soon. It is basically just a chef cookbook to take the VM
through the last mile of project-specific configuration.

After you VM has spun up, here are several commands that might be
useful:

    $ bundle exec rake send_gitconfig                    # Send your personal gitconfig to VM 
    $ bundle exec vagrant ssh-config >> ~/.ssh/config    # OPTIONAL: Adds entry to ssh config

*Note: The `vagrant up` command will take quite some time regardless, but it
will take longer on the first run, as it must download a basebox VM
image, which can be several hundred MB.*

Congratulations! You now have a configured server image on your local
machine, available at http://example.dev!

### What's with this `bundle exec` business?

We use bundler to sandbox a set of ruby gems of known versions, and
bundler needs to act as a middleman to ensure that the designated
commands are run with these sandboxed gems instead of the system gems.
That's where `bundle exec` comes in. The commands may appear to run
successfully without, but you are likely to encounter instabilities if
you neglect to include it, so we highly encourage its use.

If you'd rather not type `bundle exec` every time, you can install and
configure these great command-line tools:

* [Install Zsh][install-zsh], an alternative to your native shell.
* After that, [install Oh My Zsh][install-oh-my-zsh], a community-driven
  set of plugins and tweaks for Zsh.
* Now, we want to enable the Zsh plugin for bundler, which will append
  `bundle exec` to a given set of `bundled_commands` whenever they're
run within a project folder like Ariadne's. Open up your `~/.zshrc` and
ensure that `bundler` appears in the `plugins` array. (ie.
`plugins=(plugin1 plugin2 plugin3 bundler)`).

    ```
    $ sed -i "" -E 's/^plugins=\((.*)\)$/plugins=(\1 bundler)/g' ~/.zshrc
    ```

* Lastly, add `vagrant` to the list of `bundled_commands` in
  `~/.oh-my-zsh/plugins/bundler/bundler.plugin.zsh`. Although it's not
explicitly necessary, we'll add the `librarian-chef` command as well.

    ```
    $ sed -i "" 's/unicorn_rails)/unicorn_rails vagrant)/g' ~/.oh-my-zsh/plugins/bundler/bundler.plugin.zsh
    $ sed -i "" 's/guard middleman/guard librarian-chef middleman/g' ~/.oh-my-zsh/plugins/bundler/bundler.plugin.zsh
    ```

* Restart a new terminal session and you're good to go! (You will still
  need to use `bundle exec` for the rare `rvmsudo` command.)

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

Features
--------

### Persistent apt cache

Every time Vagrant provisions a machine, the VM must redownload all the
software packages using the apt package manager. Normally the VM caches
all the downloaded files in a special directory, but this directory is lost
whenever a VM is destroyed and rebuilt. For this reason, we share the
directory in `tmp/apt/cache`, so it will persist between VM builds.

### [vagrant-dns server][vagrant-dns]

Built-in DNS server for resolving vagrant domains on OSX. Server stops
and starts with VM itself, and it can be easily uninstalled (see
vagrant-dns README).

If you find yourself in a broken system state related to URL's that
aren't resolving, there's a rake task to restart vagrant-dns. (You can
list all rake tasks using `rake -T` or `rake -D`.)

Misc Notes
----------

<a name="note-vbox" />
* Be sure to install your version's matching "Extension Pack" from the
download page, as it contains the correct version of the
[Virtualbox Guest Additions][vbox-guest] package. This provides utlities
intended to be installed on any VM running on VBox. Thankfully, we'll be
using a [Vagrant plugin called vbguest][vagrant-vbguest], which will
handle copying this package into any VM that is out of date.

<a name="note-gcc-installer" />
* Xcode should also work, although it will not always be fully tested.

* For example.rb (which might be temporary), the default password is set
to "admin" during site-install. Also, while the local site can send mail
to actual email addresses, the default email for admin is set to
vagrant@localhost, so that any sent mail will be readable at /var/mail/vagrant
in the VM. This default is mainly to prevent site-install errorsm, and
can be edited on the Drupal's user page for the admin.

Known & Potential Issues
------------------------

* Having dnsmasq installed on the host computer can lead to unexpected
  behavior related to `resolv.conf` in the VM. This will manifest as a
  failure to upgrade chef (via rubygems) during boot, right off the bat.
* Various issues like DNS, network connectivity, easy gitconfig, etc.
  can be dealt with using the various rake tasks. To see all the
available tasks and their descriptions, run `rake -T` (for short
descriptions) or `rake -D` (for full descriptions).
* When `cd`ing into non-root of project directory, for example
  `ariadne/data`, `.rvmrc` will create new directories relative to that
dir. See notes in the `.rvmrc` for info on why normal bash script
approach is avoided.
* Oh god. The lucid64 basebox is 64 bit, so you must have a system
  running in 64-bit mode in order to boot it. Some models of 64-bit
Macbooks will boot to 32-bit mode by default. Please run `uname -m` and
ensure the system architecture is `x86_64`. (Alternatively, `i386`
indicates 32-bit mode.) [This Apple knowledgebase
article][apple-sys-arch] should help you configure your machine
correctly if it's not already.
* Ariadne has been tested with a lucid64 basebox that was built on
  **2012-05-07T21:00:04Z**. Please consider downloading a newer build if
your is out of date. To see when your basebox was built, run this
command:

    ```
    $ sed -n 's/.*lastStateChange="\(.*\)".*/\1/p' ~/.vagrant.d/boxes/lucid64/box.ovf
    ```

To Do
-----

* Create sister project to provide a base install profile that is
  pre-configured to use the advanced components (Memcache, Varnish,
  etc.)
* Doc DNS and where site will be accessible:

    ```
    http://PROJECTNAME.dev
    ```

* Doc how `project=PROJECTNAME vagrant up` will boot a specific
  project (and will write to `config/config.ini` so only need once).
* Doc format that Ariadne expects for this project repo (incl.
  subVagrantfile)
* Doc that host SSH keys are forwarded in
* Create rake tasks for configuring zsh bundler plugin for `vagrant` and
  `librarian-chef` commands (currently README instructions).
* Create a "Development Tools" section to explain components and setup.

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
