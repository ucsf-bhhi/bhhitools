test_that("bhhi_reshape_crosstab works with vartype", {
  nhanes = create_test_svy_tbl()

  test_result = nhanes |>
    srvyr::group_by(race, gender) |>
    bhhi_cascade(
      srvyr::survey_prop(
        vartype = c("se", "ci", "var", "cv"),
        proportion = FALSE,
        deff = TRUE
      )
    ) |>
    bhhi_reshape_crosstab(race, gender)

  expect_equal(nrow(test_result), dplyr::n_distinct(nhanes$variables$race) + 1)
  expect_equal(ncol(test_result), dplyr::n_distinct(nhanes$variables$gender) * 7 + 1)
  expect_false(any(stringr::str_detect(names(test_result), "__")))
})

test_that("bhhi_reshape_crosstab works with no vartype", {
  nhanes = create_test_svy_tbl()

  test_result = nhanes |>
    srvyr::group_by(race, gender) |>
    bhhi_cascade(
      srvyr::survey_prop(vartype = NULL, proportion = FALSE)
    ) |>
    bhhi_reshape_crosstab(race, gender)

  expect_equal(nrow(test_result), dplyr::n_distinct(nhanes$variables$race) + 1)
  expect_equal(ncol(test_result), dplyr::n_distinct(nhanes$variables$gender) * 2 + 1)
})
