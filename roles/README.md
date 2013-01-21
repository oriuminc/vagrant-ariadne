Role Layout
===========

To help with re-use, we're making efforts to keep roles granular. This
will help us use the same roles in production and development
environments, and will allow us to use the same roles to provision
either a single machine, or a cluster. So ideally, we can just as
easily apply all roles to one machine, or alternatively apply a
webserver role to one machine and a database role to another, and a
varnish role to the load-balancer.

The downside is that all this separation of roles can make them tougher
to grok. To help everyone understand how these roles fit together, here
is how they're nested within one another (with higher-level roles
calling deeper-level ones):

    roles                       # TYPE OF CONFIG
    └── ariadne                 # Role added by Vagrant
        └── acquia              # Configs to emulate Acquia
        │   ├── apache2_php_cgi # Alt: apache2_mod_php
        │   ├── memcache
        │   ├── mysql           # Percona drop-in MySQL replacement
        │   ├── varnish
        │   └── drupal          # Drupal-specific configs
        └── dev_tools           # Local development tools
