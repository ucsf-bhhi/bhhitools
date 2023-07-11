#' Downloads REDCap Data
#'
#' Downloads data from REDCap by wrapping [REDCapR::redcap_read()]. It handles
#' variable type conversion and creating factors from categorical variables. It
#' can optionally rename variables to adhere to Stata's variable naming rules.
#'
#' @param project_token_name Name of the project's REDCap API Token as stored by
#'   [bhhi_store_token()] in the operating system credential vault or an
#'   environment variable.
#' @param convert_factors Automatically convert categorical variables to factors
#'   using the variable labels from the REDCap project. Default is TRUE.
#' @param for_stata Should the data be prepared for use in Stata? This makes
#'   sure variable names are legal Stata variable names. Default is FALSE.
#' @param col_types Controls the variable types when parsing the REDCap data.
#'   One of "auto", which uses the project metadata to assign variable types;
#'   "guess", which uses the [readr::col_guess()] to determine the column
#'   types; "string" which parses all variables as character strings; or a
#'   custom [readr::cols()] specification. Default is "auto".
#' @param export_survey_fields A boolean that specifies whether to export the
#'   survey identifier field (e.g., 'redcap_survey_identifier') or survey
#'   timestamp fields (e.g., instrument+'_timestamp'). The timestamp outputs
#'   reflect the survey's completion time (according to the time and timezone of
#'   the REDCap server.)
#' @param verbose Should messages be printed to the R console during the
#'   operation. The verbose output might contain sensitive information (e.g.
#'   PHI), so turn this off if the output might be visible somewhere public.
#' @param ... Options passed to [REDCapR::redcap_read_oneshot()].
#'
#' @return A tibble with the requested data.
#' @export
bhhi_rc_read <- function(
    project_token_name,
    convert_factors = TRUE,
    for_stata = FALSE,
    col_types = "auto",
    export_survey_fields = TRUE,
    verbose = FALSE,
    ...) {
  data <- REDCapR::redcap_read_oneshot(
    ...,
    export_survey_fields = export_survey_fields,
    col_types = set_col_types(col_types, project_token_name),
    redcap_uri = redcap_api_url(),
    token = redcap_token(project_token_name),
    verbose = verbose
  )$data

  if (convert_factors) {
    variable_labels <- bhhi_rc_variable_labels(project_token_name)
    data <- bhhi_rc_convert_factors(data, variable_labels)
  }

  if (for_stata) data <- prepare_for_stata(data)

  data
}


bhhi_rc_convert_factors <- function(data, variable_labels) {
  dplyr::mutate(
    data,
    dplyr::across(
      dplyr::any_of(unique(variable_labels$variable)),
      function(x) {
        current_variable_labels <-
          dplyr::filter(variable_labels, variable == dplyr::cur_column())

        factor(x, current_variable_labels$value, current_variable_labels$label)
      }
    )
  )
}

bhhi_rc_convert_binary <- function(data, metadata) {
  yes_no_variables <- metadata$field_name[metadata$field_type == "yesno"]
  true_false_variables <- metadata$field_name[metadata$field_type == "truefalse"]

  data |>
    dplyr::mutate(
      dplyr::across(
        dplyr::any_of(yes_no_variables),
        \(x) factor(x, levels = c(1, 0), labels = c("Yes", "No"))
      ),
      dplyr::across(dplyr::any_of(true_false_variables), as.logical)
    )
}

set_col_types = function(mode, project_token_name) {
  if (!(class(mode) == "col_spec" || mode %in% c("string", "guess", "auto"))) {
    cli::cli_abort(
      message = c(
        "!" = 'col_types must either be one of "string", "guess", or "auto" or a {.fn readr::cols} object.'
      ),
      call = rlang::caller_env()
    )
  }

  if (class(mode) == "col_spec") {
    col_types = mode
  } else if (mode == "string") {
    col_types = readr::cols(readr::col_character())
  } else if (mode == "guess") {
    col_types = readr::cols(readr::col_guess())
  } else if (mode == "auto") {
    col_types = REDCapR::redcap_metadata_coltypes(
      redcap_uri = redcap_api_url(),
      token = redcap_token(project_token_name),
      print_col_types_to_console = FALSE
    )
  }

  col_types
}
