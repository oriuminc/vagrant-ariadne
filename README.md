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

### [Bundler][about-bundler]

Bundler will be install automatically by RVM.

### [Librarian][about-lib]

### [Vagrant][about-vagrant]

### [Capistrano][about-cap]

Recommended
-----------

### [SquidMan proxy cache][about-squidman]

SquidMan is the OS X port of the Squid3 caching proxy, which has been
optimized as a web cache. It can be used to cache and reuse frequently
accessed web pages and files.

If installed on the host, ariadne will share the cache directory with
the VM, which will allow both to share the same files.

While newer versions are available, SquidMan 2.5 is most likely to
match the current version of squid3 isntalled on the VM, reducing the
likelihood of unexpected behavior.

  1. Install and run SquidMan 2.5 [[DOWNLOAD][download-squid]]
  2. Set a Cache size and set the HTTP port to "3128"
  3. Restart SquidMan
  4. Run these shell commands:

     $ # Wget not installed on OS X by default,
     $ # but Drush will use it automatically if available
     $ echo 'http_proxy=localhost:3128' >> ~/.wgetrc
     $
     $ # Curl is available by default on OS X
     $ echo 'proxy localhost:3128' >> ~/.curlrc

  5. Reload your VM if already running: `vagrant reload`

Quick Start
-----------

    $ git clone https://github.com/myplanetdigital/ariadne.git
    $ # TODO: sh -c "cd ariadne && git checkout `git describe --tags`" # Checkout most recent tag (stable)
    $ cd ariadne
    $ librarian-chef install              # Install cookbooks from Cheffile.lock
    $ vagrant up                          # Spin up VM
    $ # TODO: vagrant ssh_config >> ~/.ssh/config # Adds a project entry to ssh config
    $ # TODO: cap deploy                          # Deploy application to VM

Files
-----

### `.rvmrc`

### `Gemfile`

### `Cheffile`

### `Vagrantfile`

### `Capfile`

   [about-rvm]:     <http://beginrescueend.com/>
   [about-bundler]: <http://gembundler.com/>
   [about-lib]:     <https://github.com/applicationsonline/librarian>
   [about-vagrant]: <http://vagrantup.com/>
   [about-cap]:     <https://github.com/capistrano/capistrano/wiki>
   [install-rvm]:   <http://beginrescueend.com/rvm/install/>
   [download-squid]: <http://web.me.com/adg/downloads/SquidMan2.5.dmg>
