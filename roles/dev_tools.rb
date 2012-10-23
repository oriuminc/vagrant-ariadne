name "dev_tools"
description "Development and debugging tools for local environments."
default_attributes({
  :xdebug => {
    :version => "2.2.1",
    :directives => {
      :profiler_enable_trigger => "1",
      :remote_enable => "1",
      :remote_host => "33.33.33.1",
      :remote_log => "/var/log/xdebug.log",
    },
  },
  :phpcs => {
    :coder_git_ref => "c43676c3909038",
  },
  :phpunit => {
    :version => "3.6.10",
  },
})
run_list([
  "recipe[phpcs::drupal_standard]",
  "recipe[build-essential]",
  "recipe[phpunit]",
  "recipe[xdebug]",
  "recipe[webgrind]",
])
override_attributes()
