#' Run a Weighted Crosstab
#'
#' Simplifies running a weighted crosstab with [`bhhi_cascade()`] and
#' [`srvyr::survey_prop()`]. Returns a tibble that can be directly customized or
#' formatted with [`bhhi_reshape_crosstab()`] and [`bhhi_format_crosstab()`].
#'
#' @inheritParams bhhi_gt_crosstab
#'
#' @return A tibble with the crosstab results.
#' @export
#'
#' @examples
#' data("nhanes", package = "survey")
#'
#' survey_object <- nhanes |>
#'   dplyr::rename(gender = RIAGENDR) |>
#'   dplyr::mutate(
#'     gender = factor(gender, 1:2, c("Male", "Female")),
#'     race = factor(race, 1:4, c("Hispanic", "White", "Black", "Other"))
#'   ) |>
#'   srvyr::as_survey(weights = WTMEC2YR)
#'
#' survey_object |>
#'   bhhi_crosstab(race, gender)
#'
#' survey_object |>
#'   bhhi_crosstab(race, gender, pct_direction = "row", vartype = "ci")
bhhi_crosstab <- function(.data,
                          row_var,
                          col_var,
                          pct_direction = "col",
                          add_n = FALSE,
                          vartype = c("se", "ci", "var", "cv"),
                          level = 0.95,
                          proportion = TRUE,
                          na.rm = FALSE) {
  groups <- switch(pct_direction,
    "row" = rlang::ensyms(row_var, col_var),
    "col" = rlang::ensyms(col_var, row_var),
    cli::cli_abort(
      "{.arg pct_direction} must be either 'row' or 'col'.",
      call = rlang::caller_env()
    )
  )

  if (add_n) {
    n <- rlang::exprs(n = srvyr::n())
  } else {
    n <- NULL
  }

  if (missing(vartype)) vartype <- NULL

  .data |>
    srvyr::group_by(!!!groups) |>
    bhhi_cascade(
      !!!n,
      srvyr::survey_prop(
        vartype = vartype,
        level = level,
        proportion = TRUE,
        na.rm = na.rm
      )
    )
}
