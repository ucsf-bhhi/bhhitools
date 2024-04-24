#' Create Formatted Weighted Crosstab
#'
#' Uses [`bhhi_cascade()`] with [`srvyr::survey_prop()`] to calculate weighted
#' crosstabs and then uses [`bhhi_format_crosstab()`] to create nicely formatted
#' output via the [`gt`] table package.
#'
#' @inheritParams srvyr::cascade
#' @inheritParams srvyr::survey_prop
#' @inheritParams gt::fmt_percent
#' @param row_var Variable to show in the rows in output.
#' @param col_var Variable to show in the columns in output.
#' @param pct_direction `'col'` to calculate column percentages or `'row'` to
#'   calculate row percentages. Defaults to `'col'`.
#' @param vartype Report variability as zero or more of: standard error ("se",
#'   default), confidence interval ("ci"), variance ("var") or coefficient of
#'   variation ("cv"). Defaults to hiding variability.
#' @param add_n Add cell N to output. Defaults to FALSE.
#' @param decimals An integer specifing the number of decimal places in the
#'   results. Defaults to 1.
#' @param na.rm Drop missing values. Defaults to FALSE.
#'
#' @export
#'
#' @section Examples:
#' ```r
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
#'   bhhi_gt_crosstab(race, gender)
#' ```
#' \if{html}{\out{
#' <img src='man_bhhi_gt_crosstab_1.png' class='gt-example-img'>
#' }}
#' ```r
#' survey_object |>
#'   bhhi_gt_crosstab(
#'     race, gender, pct_direction = "row", vartype = "ci", decimals = 2
#'   )
#' ```
#' \if{html}{\out{
#' <img src='man_bhhi_gt_crosstab_2.png' class='gt-example-img'>
#' }}
bhhi_gt_crosstab <- function(.data,
                             row_var,
                             col_var,
                             pct_direction = "col",
                             add_n = FALSE,
                             vartype = c("se", "ci", "var", "cv"),
                             level = 0.95,
                             proportion = TRUE,
                             decimals = 1,
                             na.rm = FALSE) {
  if (missing(vartype)) vartype <- NULL

  bhhi_crosstab(
    .data,
    row_var = !!rlang::ensym(row_var),
    col_var = !!rlang::ensym(col_var),
    pct_direction = pct_direction,
    add_n = add_n,
    vartype = vartype,
    level = level,
    proportion = proportion,
    na.rm = na.rm
  ) |>
    bhhi_reshape_crosstab({{ row_var }}, {{ col_var }}) |>
    bhhi_format_crosstab(decimals = decimals)
}
