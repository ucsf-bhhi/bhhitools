#' Pivot a Crosstab to Wide Form
#'
#' Pivots a crosstab from [`bhhi_crosstab()`] from long form to wide form.
#'
#' @param .data A tibble from [`bhhi_crosstab()`]
#' @inheritParams bhhi_gt_crosstab
#'
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
#'   bhhi_crosstab(race, gender) |>
#'   bhhi_reshape_crosstab(race, gender)
bhhi_reshape_crosstab <- function(.data, row_var, col_var) {
  col_var_string <- rlang::as_string(rlang::ensym(col_var))

  .data |>
    tidyr::pivot_wider(
      id_cols = {{ row_var }},
      names_from = {{ col_var }},
      names_vary = "slowest",
      names_glue = glue::glue(
        "{[col_var_string]}_{.value}",
        .open = "[", .close = "]"
      ),
      values_from = -c({{ row_var }}, {{ col_var }})
    ) |>
    # srvyr uses "_" as a prefix on vartypes (_se, _low, _upp, .etc) which leads
    # to a "__" at the end of variable names (ie. "Female__se").
    # this gets rid of the extra underscore in those situations
    # (ie. "Female__se" becomes "Female_se")
    dplyr::rename_with(
      \(x) stringr::str_replace(x, "(.*)__(low|upp|se|var|cv|deff)$", "\\1_\\2")
    )
}
