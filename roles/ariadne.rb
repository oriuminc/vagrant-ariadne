name "ariadne"
description "Master role for Ariadne development environment."
run_list(
  "role[base]",
  "role[acquia]",
  "role[dev_tools]",
  "recipe[ariadne::default]",
)
