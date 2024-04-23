test_token <- Sys.getenv("BHHITOOLS_DEMO")

test_data <- function(filename) {
  readRDS(testthat::test_path(file.path("test-data", filename)))
}

mock_add_quarto_format <- function() {
  with_mocked_bindings(
    bhhi_add_quarto(),
    add_quarto_format = function() {
      quarto::quarto_add_extension("ucsf-bhhi/bhhi-quarto", no_prompt = TRUE)
    }
  )
}

create_test_svy_tbl <- function() {
  # specify the current (ie. inside the function environment) so the dataset
  # isn't loaded into the global environment and doesn't persits after the
  # function exits
  data("nhanes", package = "survey", envir = rlang::current_env())
  nhanes |>
    dplyr::rename(gender = RIAGENDR, hi_chol = HI_CHOL) |>
    dplyr::mutate(
      gender = factor(gender, 1:2, c("Male", "Female")),
      race = factor(race, 1:4, c("Hispanic", "White", "Black", "Other")),
      hi_chol = dplyr::if_else(is.na(hi_chol), 0, hi_chol),
      hi_chol = factor(hi_chol, 0:1, c("No", "Yes"))
    ) |>
    srvyr::as_survey(weights = WTMEC2YR)
}

expect_gt_output <- function(x, filename) {
  skip_on_ci()

  output_file <- withr::local_tempfile(fileext = ".png")

  gt::gtsave(x, output_file)
  expect_snapshot_file(path = output_file, name = fs::path(filename, ext = "png"))
}

expect_equal_bhhi_srvyr <- function(bhhi, srvyr) {
  expect_equal(
    bhhi |>
      dplyr::ungroup() |>
      dplyr::mutate(dplyr::across(dplyr::where(is.factor), as.character)),
    srvyr |>
      dplyr::ungroup() |>
      dplyr::mutate(dplyr::across(dplyr::where(is.factor), as.character)),
    ignore_attr = TRUE
  )
}
