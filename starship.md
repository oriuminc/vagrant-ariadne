Setting up Starship
===================

There are several manual steps until we stabilize.

```sh
# From the Ariadne project root directory
$ vagrant ssh -c "sudo rm -r /mnt/www/html/condel"
$ git clone git@github.com:myplanetdigital/starship-drupal.git data/html/condel
$ vagrant ssh -c "cd /mnt/www/html/condel; ./starship.sh -e dev"
```
