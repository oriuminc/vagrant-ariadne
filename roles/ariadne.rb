name "ariadne"
description "Master role for Ariadne development environment."
run_list([
  "role[base]",
  "role[apache2_mod_php]",
  "role[memcache]",
  "role[mysql]",
  "role[varnish]",
  "role[drupal]",
  "role[dev_tools]",
  "recipe[ariadne::default]",
])
