bhhi_format_crosstab = function(.data, decimals = 1, rowname_col = NULL) {
  if (is.null(rowname_col)) rowname_col = names(.data[1])

  if (!detect_vartype(.data) & !detect_ci(.data)) {
    .data = dplyr::rename_with(.data, \(x) str_remove(x, "_coef"))
  }

  gt_table = .data |>
    dplyr::ungroup() |>
    gt::gt(rowname_col = rowname_col) |>
    gt::fmt_percent(decimals = decimals) |>
    gt::fmt_integer(columns = gt::ends_with("_n")) |>
    gt::fmt_number(columns = gt::ends_with("_deff"), decimals = decimals) |>
    gt::cols_label(gt::ends_with("_n") ~ "N")

  if (detect_vartype(.data)) {
    for (span in get_column_name_stems(.data)) {
      gt_table = gt_table |>
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
    gt_table = gt_table |>
      gt::cols_merge_range(
        col_begin =  gt::ends_with("_low"),
        col_end = gt::ends_with("_upp")
      ) |>
      gt::cols_label(
        gt::ends_with("_coef") ~ "Percent",
        gt::ends_with("_low") ~ "Conf. Interval")
  }

  bhhi_format_table(gt_table)
}

detect_vartype = function(.data) {
  purrr::map_lgl(
    names(.data),
    \(x) any(stringr::str_ends(x, c("_se", "_upp", "_low", "_var", "_cv")))
  ) |>
    any()
}

detect_ci = function(.data) {
  any(stringr::str_ends(names(.data), "_upp")) &
    any(stringr::str_ends(names(.data), "_low"))
}

get_column_name_stems = function(.data) {
  x = stringr::str_extract(names(.data), "(.*)_.{2,4}$", group = 1)

  unique(x[!is.na(x)])
}
