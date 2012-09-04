name "solr"
description "Install requirements for running Apache Solr."
run_list(
  "recipe[tomcat::ark]",
  "recipe[solr]"
)
default_attributes(
)
