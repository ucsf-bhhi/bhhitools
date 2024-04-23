#' Format Tables for Output
#'
#' Applies common formatting to tables output in Quarto, R Markdown, etc.
#'
#' Currently sets table to full width and left aligns text in the table stub.
#'
#' @param table A `gt:gt` table object
#' @param full_width Table will fill the entire width of its container. Default is true.
#' @param left_align_stub Text in table stub is left-aligned. Default is true.
#'
#' @return The formatted table object.
#' @export
#'
#' @examplesIf interactive()
#' mtcars |>
#'   dplyr::as_tibble(rownames = "car") |>
#'   gt::gt(rowname_col = "car") |>
#'   bhhi_format_table()
bhhi_format_table <- function(table, full_width = TRUE, left_align_stub = TRUE) {
  if (!inherits(table, "gt_tbl")) {
    cli::cli_abort(
      message = c(
        "!" = "table must be a {.fn gt::gt} table."
      ),
      call = rlang::caller_env()
    )
  }

  if (full_width) {
    table <- gt::tab_options(table, table.width = "100%")
  }

  if (left_align_stub) {
    table <- gt::tab_style(table, gt::cell_text(align = "left"), gt::cells_stub())
  }

  table
}
