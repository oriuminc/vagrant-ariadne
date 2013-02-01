1.4.0 (unreleased)
------------------

  - Taking advantage of new GitHub CONTRIBUTING guidelines:
    https://github.com/blog/1184-contributing-guidelines
  - Run list roles now configurable in `config.yml`. [GH-17]
  - Added `restart_service` function to add ability to restart services
    like Varnish even when not necessarily in run list. [GH-17]
  - Moved from vagrant-dns to vagrant-hostmaster.
  - Added `host_name` to `config.yml`.

1.3.0 (Sept. 18, 2012)
----------------------

  - `vagrant ssh` now starts in docroot of current project.
  - Added bash cookbook with bash\_profile resource. 
  - Added share\_folder config to `Vagrantfile for persistent drush
    cache between VM builds.
  - `config/config.yml` now generated during `rake setup`. [GH-36]
  - Resolved issue with pear warning during initial chef run. [GH-12]
  - Moved `clean` functionality into `ariadne::default`. (Now works for
    default example recipe as well.)
  - Installed Webgrind UI. [GH-30]
  - Upgraded to vagrant v1.0.4.
  - Added Travis CI badge and foodcritic/knife tests (Etsy & CustomInk rules)
  - Disabled root login. [GH-37]
  - Moved to using `sshd\_config` & `ssh\_config` templates from openssh
    cookbook.
  - Added link to audio pronunciation of "Ariadne" :)
  - Added sahara gem to easily create and revert Virtualbox snapshots
    with Vagrant.

1.2.0 (Sept. 12, 2012)
----------------------

  - Pull requests for phpunit and php were accepted, so updated
    `Cheffile`.
  - Moved from specifically compiled ariadne ruby to using ariadne
    gemset.
  - Moved to using custom percona cookbook which leverages newly tunable
    mysql cookbook.
  - Cleared out development gems like jenkins.rb, capistrano, etc.
  - Removed unneeded cookbooks, particularly the database cookbook.
  - Upgraded drush version from 5.6 to 5.7.
  - Moved example project cookbook into standard format/location that
    any ariadne project cookbook would use.
  - Documented process for proper upgrade when new changes are pulled.
  - Bumped recommended Virtualbox and RVM versions to latest in README.
  - Upgrade host and guest chef versions from 10.12.0 to 10.14.2.
  - Added `branch` CLI envvar to vagrant command so that ariadne
    cookbook can implement functionality to build specific branches.

1.1.0 (Sept. 10, 2012)
----------------------

  *In progres...*
