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
