terraform {
  required_version = ">= 0.15.0"
  # Optional attributes and the defaults function are
  # both experimental, so I must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}