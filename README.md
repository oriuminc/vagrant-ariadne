Ariadne
=======

> Remember, Ariadne, you are the dreamer, you build this world. I am the
> subject, my mind populates it.
>
> *-- Cobb, Inception*

 * Source: https://github.com/myplanetdigital/ariadne

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
   between VM builds (Squid web cache with shared folder)
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

### Xcode

### [RVM][about-rvm]

[Installation instructions][install-rvm]

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

### [SquidMan proxy cache][about-squidman]

SquidMan is the OS X port of the Squid3 caching proxy, which has been
optimized as a web cache. It can be used to cache and reuse frequently
accessed files.

If installed on the host, Ariadne will also send the VM's curl and wget
requests through SquidMan on the host.

  1. Install and run SquidMan 3.1 [[DOWNLOAD][download-squid]].
  2. Set "Cache size" and set the HTTP port to `3128`.
  3. In the "Clients" tab, add a new entry for `33.33.33.10`.
  4. Stop and start SquidMan.
  5. Run these shell commands:

    ```
    $ # Curl is available by default on OS X.
    $ # Drush uses this if Wget is not installed.
    $ echo 'proxy localhost:3128' >> ~/.curlrc
    $
    $ # Wget not installed on OS X by default,
    $ # but Drush will automatically favor it if available.
    $ echo 'http_proxy=localhost:3128' >> ~/.wgetrc
    ```

  6. Reprovision your VM if already running: `vagrant provision`

### Persistent apt cache

Every time Vagrant provisions a machine, the VM must redownload all the
software packages using the apt package manager. While the VM caches
all the downloaded files in a special directory, this directory is lost,
whenever a VM is destroyed and rebuilt. To persist this cache directory
as a shared directory, run this from the root dir of this git repo:

    $ mkdir -p data/apt-cache/partial

Quick Start
-----------

    $ chmod +x ~/.rvm/hooks/after_cd_bundler                           # Activate Bundler RVM hook
    $ exec $SHELL                                                      # Reload your shell
    $ git clone https://github.com/myplanetdigital/ariadne.git
    $ # TODO: sh -c "cd ariadne && git checkout `git describe --tags`" # Checkout most recent tag (stable)
    $ cd ariadne
    $ librarian-chef install              # Install cookbooks from Cheffile.lock
    $ vagrant up                          # Spin up VM
    $ vagrant ssh_config >> ~/.ssh/config # Adds a project entry to ssh config
    $ # TODO: cap deploy                          # Deploy application to VM

Development Tools
=================

## [Xdebug][about-xdebug]
???MANY LINES MISSING
   [about-vagrant]:         http://vagrantup.com/                                              
   [about-cap]:             https://github.com/capistrano/capistrano/wiki                      
   [about-vagrant-kick]:    https://github.com/arioch/vagrant-kick#readme                      
   [install-rvm]:           http://beginrescueend.com/rvm/install/                             
   [download-squid]:        http://web.me.com/adg/downloads/SquidMan2.5.dmg                    
   [about-squidman]:        http://web.me.com/adg/squidman/                                    
   [about-xdebug]:          http://xdebug.org/                                                 
   [install-xdebug-emacs1]: http://code.google.com/p/geben-on-emacs/source/browse/trunk/README 
   [install-xdebug-emacs2]: http://puregin.org/debugging-php-with-xdebug-and-emacs-on-mac-os-x 
