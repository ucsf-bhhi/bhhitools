#' Downloads REDCap Data
#'
#' Downloads data from REDCap by wrapping [REDCapR::redcap_read()]. The API URL
#' is filled automatically, but can be overridden.
#'
#' @param project_token_name Name of the project's REDCap API Token. API tokens
#'   must be stored in an environmental variable. Provide the name of that
#'   environmental variable here.
#' @param for_stata Should the data be prepared for use in Stata? This makes
#'   sure variable names are legal Stata variable names.
#' @param col_types Override default col_types for Stata by providing a
#'   [readr::cols()] specification.
#' @param export_survey_fields A boolean that specifies whether to export the
#'   survey identifier field (e.g., 'redcap_survey_identifier') or survey
#'   timestamp fields (e.g., instrument+'_timestamp'). The timestamp outputs
#'   reflect the survey's completion time (according to the time and timezone of
#'   the REDCap server.)
#' @param verbose Should messages be printed to the R console during the
#'   operation. The verbose output might contain sensitive information (e.g.
#'   PHI), so turn this off if the output might be visible somewhere public.
#' @param ... Options passed to [REDCapR::redcap_read()].
#'
#' @return A tibble with the requested data.
#' @export
#' @seealso [redcap_token()]
bhhi_redcap_read = function(
  project_token_name,
  for_stata = FALSE,
  col_types = NULL,
  export_survey_fields = TRUE,
  verbose = FALSE,
  ...
) {

  data = REDCapR::redcap_read_oneshot(
    ...,
    export_survey_fields = export_survey_fields,
    col_types = col_types,
    redcap_uri = redcap_api_url(),
    token = redcap_token(project_token_name),
    verbose = verbose
  )$data |>
    dplyr::as_tibble()

  if (for_stata) data = prepare_for_stata(data)

  data
}
