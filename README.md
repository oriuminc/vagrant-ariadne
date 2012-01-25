Ariadne
=======

> Remember, Ariadne, you are the dreamer, you build this world. I am the
> subject, my mind populates it.
>
> *-- Cobb, Inception*

 * Source: https://github.com/myplanetdigital/ariadne

Requirements
------------

### RVM

### Bundler

### Librarian

### Vagrant

### Capistrano

Quick Start
-----------

    $ git clone https://github.com/myplanetdigital/ariadne.git
    $ cd ariadne
    $ git checkout `git describe --tags` # Checkout most recent tag (stable)
    $ bundle install                     # Install gems from Gemfile.lock
    $ bundle package                     # Store gems locally
    $ librarian-chef install             # Install cookbooks from Cheffile.lock
    $ vagrant up                         # Spin up VM
    $ cap deploy                         # Deploy application to VM

Files
-----

### `.rvmrc`

### `Gemfile`

### `Cheffile`

### `Vagrantfile`

### `Capfile`
