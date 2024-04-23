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
