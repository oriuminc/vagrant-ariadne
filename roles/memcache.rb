name "memcache"
description "Role for memcache setup."
run_list([
  "recipe[memcached]",
  "recipe[php::module_memcache]",
  "recipe[php::module_memcached]",
])
default_attributes(
)
