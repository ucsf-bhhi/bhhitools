test_that("variable labels works", {
  skip_on_ci()

  withr::local_envvar(BHHITOOLS_TESTING_TOKEN = test_token)

  bhhi_rc_variable_labels("BHHITOOLS_TESTING_TOKEN") |>
    expect_identical(test_data("rc_variable_labels.rds"))
})
