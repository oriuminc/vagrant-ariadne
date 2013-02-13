name "base"
description "Base role for general system setup."
run_list([
  "recipe[apt]",
  "recipe[git]",
  "recipe[vim]",
  "recipe[openssh]",
  "recipe[postfix]",
])
default_attributes({
  :openssh => {
    :client => {
      :strict_host_key_checking => "no",
    },
    :server => {
      :password_authentication => "no",
      :permit_root_login => "no",
    },
    :postfix => {
      :mydomain => "$myhostname",
    },
  },
})
