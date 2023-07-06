prepare_for_stata = function(data) {
  dplyr::rename_with(data, stata_safe_variable_names, everything())
}

stata_safe_variable_names = function(name) {
  name |>
    strip_stata_illegal_char() |>
    strip_leading_digit() |>
    stata_name_truncate()
}

strip_stata_illegal_char = function(name) {
  # names can only contain letters, digits, and underscores
  # replace anything else with an underscore
  gsub("[^a-zA-Z0-9_]", "_", name)
}

strip_leading_digit = function(name) {
  # stata names can't start with a digit, prepend with underscore
  dplyr::if_else(grepl("^[0-9]", name), paste0("_", name), name)
}

stata_name_truncate = function(name) {
  # names can only be 32 characters max, truncate if longer
  substr(name, 1, 32)
}

