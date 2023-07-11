#' Parse REDCap Variable Labels
#'
#' Use the REDCap project metadata to parse the variable labels. Creates a
#' tibble with the values and labels for each categorical variable.
#'
#' When provided with the name of an API token, it will download the project XML
#' from REDCap and then parse it.
#'
#' When provided directly with the project XML, it will parse it.
#'
#' @param x Either a string with the name of the stored REDCap project API
#'   token, or an [xml2 object][xml2::xml_document-class] representing the
#'   REDCap project XML.
#'
#' @returns A tibble with three columns:
#'
#' * variable: the name of the variable as stored in REDCap
#'
#' * value: the integer value of the variable
#'
#' * label: the corresponding text label
#'
#' @export
bhhi_rc_variable_labels <- function(x) {
  UseMethod("bhhi_rc_variable_labels")
}

#' @export
bhhi_rc_variable_labels.xml_document <- function(project_xml) {
  code_list <- xml2::xml_find_all(project_xml, ".//CodeList")

  variables <- xml2::xml_attr(code_list, "Variable")
  n_values <- xml2::xml_length(code_list)

  code_list_items <- xml2::xml_find_all(code_list, ".//CodeListItem")
  values <- xml2::xml_attr(code_list_items, "CodedValue")
  labels <- xml2::xml_text(code_list_items)

  dplyr::tibble(
    variable = rep(variables, n_values),
    value = values,
    label = labels
  )
}

#' @export
bhhi_rc_variable_labels.character <- function(x) {
  rc_project_xml(x) |>
    bhhi_rc_variable_labels()
}
