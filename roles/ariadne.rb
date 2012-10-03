current_dir = File.dirname(__FILE__)
conf = YAML.load_file "#{current_dir}/config.yml"

name "ariadne"
description "Master role for Ariadne development environment."

# Build run_list from config file
dynamic_run_list = conf['roles'].split(',').collect { |i| "role[#{i}]" }
ariadne_run_list = ["role[base]"] + dynamic_run_list + ["recipe[ariadne::default]"]
run_list(ariadne_run_list)

default_attributes({
  :ariadne => conf,
})
