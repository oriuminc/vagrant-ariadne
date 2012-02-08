Ariadne
=======

> Remember, Ariadne, you are the dreamer, you build this world. I am the
> subject, my mind populates it.
>
> *-- Cobb, Inception*

 * Source: https://github.com/myplanetdigital/ariadne

Requirements
------------

### Xcode

### [RVM][about-rvm]

[Installation instructions][install-rvm]

Please note that RVM will add its load commands to `.bash_profile` by
default. Depending on your shell, this may not be appropriate. (For
example, Zsh usually needs the command in `.zshrc`).

After installation, if you open up a new shell and the `rvm` command
doesn't exist, type the following (replacing `.bach_profile` as
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

Xdebug is a PHP extension which provides debugging and profiling
capabilities. It can provide debug info with the following:

 * stack and function traces in error messages with full parameter display
 * memory allocation
 * protection for infinite recursions
 * interactive debugging (with IDE)
 * code coverage analysis

To trigger Xdebug to start doing it's thing once you've set up your IDE
for remote debugging, simply enter an address like so:

   http://example.localdomain:1234/path/to/page?XDEBUG_SESSION_START

### Installation

For ease of use, we've included tried and tested setup instructions for
varios common IDE's.

#### Emacs

Download a recent version of Geben and follow instructions in the
included README. Alternatively, copy the lines below into your terminal
[[README][install-xdebug-emacs1]]:

    $ curl http://geben-on-emacs.googlecode.com/files/geben-0.26.tar.gz -o /tmp/geben-0.26.tar.gz
    $ tar -xzf /tmp/geben-0.26.tar.gz && cd /tmp/geben-0.26
    $ make
    $ sudo make install

Complete installation by pasting this into your `~/.emacs` file
[[Blog Post][install-xdebug-emacs2]]:

    (add-to-list 'load-path "/opt/local/share/emacs/site-lisp/geben") ;Geben directory
    (require 'geben)

### Komodo

Files
-----

### `.rvmrc`

Used by RVM (Ruby Version Manager) to create a sandboxed project
environment with specific verion of ruby and rubygems. You'll be
prompted to run this file on entering the project directory, and it
will kick-start the tools that act on the files below.

 * *Some of the files below will have "lock" files. The intention is that
   a user will edit the non-lock file directly, and then the lock file
   will be generated to specify exact versions for all dependencies. You
   can think of it as if the Gemfile is specifying the intended environment
   to the degree of precision we care to define, and the Gemfile.lock locks
   down the absolute environment without a shadow of a doubt.*

### `Gemfile`

Used by [Bundler][about-bundler] to install the required gem versions
into the sandbox.

### `Cheffile`

Used by [Librarian][about-lib] to define and retrieve specific external
cookbook versions which the Chef provisioner inside Vagrant will use to
configure its VM.

### `Vagrantfile`

[Vagrant][about-vagrant]

### `Capfile`

[Capistrano][about-cap]

   [about-rvm]:      http://beginrescueend.com/
   [about-bundler]:  http://gembundler.com/
   [about-lib]:      https://github.com/applicationsonline/librarian
   [about-vagrant]:  http://vagrantup.com/
   [about-cap]:      https://github.com/capistrano/capistrano/wiki
   [install-rvm]:    http://beginrescueend.com/rvm/install/
   [download-squid]: http://web.me.com/adg/downloads/SquidMan2.5.dmg
   [about-squidman]: http://web.me.com/adg/squidman/
   [about-xdebug]:   http://xdebug.org/
   [install-xdebug-emacs1]: http://code.google.com/p/geben-on-emacs/source/browse/trunk/README
   [install-xdebug-emacs2]: http://puregin.org/debugging-php-with-xdebug-and-emacs-on-mac-os-x
