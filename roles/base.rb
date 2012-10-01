name "base"
description "Base role for general system setup."
run_list([
  "recipe[apt]",
  "recipe[git]",
  "recipe[vim]",
  "recipe[openssh]",
])
default_attributes(
  :openssh => {
    :client => {
      :strict_host_key_checking => "no",
    },
    :server => {
      :permit_root_login => "no",
    }
  }
)
