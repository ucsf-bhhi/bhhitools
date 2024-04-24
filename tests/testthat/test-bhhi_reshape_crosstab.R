test_that("bhhi_reshape_crosstab works with vartype", {
  test_result <- create_test_svy_tbl() |>
    srvyr::group_by(race, gender) |>
    bhhi_cascade(
      srvyr::survey_prop(
        vartype = c("se", "ci", "var", "cv"),
        proportion = FALSE,
        deff = TRUE
      )
    ) |>
    bhhi_reshape_crosstab(race, gender)

  expect_df_equal(test_result, "bhhi_reshape_crosstab_vartype")
  expect_false(any(stringr::str_detect(names(test_result), "__")))
})

test_that("bhhi_reshape_crosstab works with no vartype", {
  test_result <- create_test_svy_tbl() |>
    srvyr::group_by(race, gender) |>
    bhhi_cascade(
      srvyr::survey_prop(vartype = NULL, proportion = FALSE)
    ) |>
    bhhi_reshape_crosstab(race, gender)

  expect_df_equal(test_result, "bhhi_reshape_crosstab_no_vartype")
  expect_false(any(stringr::str_detect(names(test_result), "__")))
})
