#' Create Formatted Table  From a Reshaped Crosstab
#'
#' Creates a formatted table via the [`gt`] package from a survey crosstab that has been reshaped via [`bhhi_reshape_crosstab()`].
#'
#' @param .data A tibble from [`bhhi_reshape_crosstab()`]
#' @inheritParams bhhi_gt_crosstab
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
#'   bhhi_crosstab(race, gender) |>
#'   bhhi_reshape_crosstab(race, gender) |>
#'   bhhi_format_crosstab()
#' ```
#' \if{html}{\out{
#' <img src='man_bhhi_format_crosstab_1.png' class='gt-example-img'>
#' }}
bhhi_format_crosstab <- function(.data, decimals = 1) {
  if (!detect_vartype(.data) & !detect_ci(.data)) {
    .data <- dplyr::rename_with(.data, \(x) stringr::str_remove(x, "_coef"))
  }

  gt_table <- .data |>
    dplyr::ungroup() |>
    gt::gt(rowname_col = names(.data[1])) |>
    gt::fmt_percent(decimals = decimals) |>
    gt::fmt_integer(columns = gt::ends_with("_n")) |>
    gt::fmt_number(columns = gt::ends_with("_deff"), decimals = decimals) |>
    gt::cols_label(gt::ends_with("_n") ~ "N")

  column_name_stems <- get_column_name_stems(.data)

  if (detect_vartype(.data)) {
    for (span in column_name_stems) {
      gt_table <- gt_table |>
        gt::tab_spanner(label = span, columns = gt::starts_with(span)) |>
        gt::cols_label(
          gt::ends_with("_coef") ~ "Percent",
          gt::ends_with("_se") ~ "Std. Error",
          gt::ends_with("_var") ~ "Variance",
          gt::ends_with("_cv") ~ "Coef. of Variation",
          gt::ends_with("_deff") ~ "Design Effect"
        )
    }
  }

  if (detect_ci(.data)) {
    for (stem in column_name_stems) {
      gt_table <- gt_table |>
        gt::cols_merge_range(
          col_begin = glue::glue("{stem}_low"),
          col_end = glue::glue("{stem}_upp")
        )
    }
    gt_table <- gt_table |>
      gt::cols_label(
        gt::ends_with("_coef") ~ "Percent",
        gt::ends_with("_low") ~ "Conf. Interval"
      )
  }

  bhhi_format_table(gt_table)
}

detect_vartype <- function(.data) {
  purrr::map_lgl(
    names(.data),
    \(x) any(stringr::str_ends(x, c("_se", "_upp", "_low", "_var", "_cv")))
  ) |>
    any()
}

detect_ci <- function(.data) {
  any(stringr::str_ends(names(.data), "_upp")) &
    any(stringr::str_ends(names(.data), "_low"))
}

get_column_name_stems <- function(.data) {
  column_names = names(.data)
  # first column is the row var so remove it
  column_names = column_names[2:length(column_names)]

  x <- stringr::str_extract(column_names, "(.*)_.{2,4}$", group = 1)

  unique(x[!is.na(x)])
}
