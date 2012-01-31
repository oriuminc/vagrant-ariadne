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

### RVM

### Bundler

### Librarian

### Vagrant

### Capistrano

Quick Start
-----------

    $ git clone https://github.com/myplanetdigital/ariadne.git
    $ sh -c "cd ariadne && git checkout `git describe --tags`" # Checkout most recent tag (stable)
    $ cd ariadne
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
