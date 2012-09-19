name "solr"
description "Install requirements for running Apache Solr."
run_list(
  "recipe[solr::package]",
)
default_attributes(
  "tomcat" => {
    "port" => "8983",
  }
)
