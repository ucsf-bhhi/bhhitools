test_that("auto types, factor conversion works", {
  withr::local_envvar(BHHITOOLS_TESTING_TOKEN = test_token)

  bhhi_rc_read(
    "BHHITOOLS_TESTING_TOKEN",
    convert_factors = TRUE,
    col_types = "auto"
  ) |>
  expect_identical(test_data("rc_read_auto_convert.rds"))
})

test_that("auto types, no factor conversion works", {
  withr::local_envvar(BHHITOOLS_TESTING_TOKEN = test_token)

  bhhi_rc_read(
    "BHHITOOLS_TESTING_TOKEN",
    convert_factors = FALSE,
    col_types = "auto"
  ) |>
    expect_identical(test_data("rc_read_auto_no_convert.rds"))
})

test_that("guess types, factor conversion works", {
  withr::local_envvar(BHHITOOLS_TESTING_TOKEN = test_token)

  bhhi_rc_read(
    "BHHITOOLS_TESTING_TOKEN",
    convert_factors = TRUE,
    col_types = "guess"
  ) |>
    expect_identical(test_data("rc_read_guess_convert.rds"))
})

test_that("guess types, no factor conversion works", {
  withr::local_envvar(BHHITOOLS_TESTING_TOKEN = test_token)

  bhhi_rc_read(
    "BHHITOOLS_TESTING_TOKEN",
    convert_factors = FALSE,
    col_types = "guess"
  ) |>
    expect_identical(test_data("rc_read_guess_no_convert.rds"))
})

test_that("string types, factor conversion works", {
  withr::local_envvar(BHHITOOLS_TESTING_TOKEN = test_token)

  bhhi_rc_read(
    "BHHITOOLS_TESTING_TOKEN",
    convert_factors = TRUE,
    col_types = "string"
  ) |>
    expect_identical(test_data("rc_read_string_convert.rds"))
})

test_that("string types, no factor conversion works", {
  withr::local_envvar(BHHITOOLS_TESTING_TOKEN = test_token)

  bhhi_rc_read(
    "BHHITOOLS_TESTING_TOKEN",
    convert_factors = FALSE,
    col_types = "string"
  ) |>
    expect_identical(test_data("rc_read_string_no_convert.rds"))
})
