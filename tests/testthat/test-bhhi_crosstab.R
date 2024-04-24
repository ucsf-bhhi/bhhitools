test_that("bhhi_crosstab col percentage works", {
  bhhi_result <- create_test_svy_tbl() |>
    bhhi_crosstab(
      row_var = race,
      col_var = gender,
      pct_direction = "col",
      vartype = "se"
    )

  srvyr_result <- dplyr::bind_rows(
    create_test_svy_tbl() |>
      srvyr::group_by(gender, race) |>
      srvyr::summarise(srvyr::survey_prop(proportion = TRUE)),
    create_test_svy_tbl() |>
      srvyr::group_by(race) |>
      srvyr::summarise(srvyr::survey_prop(proportion = TRUE)) |>
      dplyr::mutate(gender = "Overall")
  )

  expect_equal_bhhi_srvyr(bhhi_result, srvyr_result)
})

test_that("bhhi_crosstab col percentage add_n works", {
  bhhi_result <- create_test_svy_tbl() |>
    bhhi_crosstab(
      row_var = race,
      col_var = gender,
      pct_direction = "col",
      vartype = "se",
      add_n = TRUE
    )

  srvyr_result <- dplyr::bind_rows(
    create_test_svy_tbl() |>
      srvyr::group_by(gender, race) |>
      srvyr::summarise(n = srvyr::n(), srvyr::survey_prop(proportion = TRUE)),
    create_test_svy_tbl() |>
      srvyr::group_by(race) |>
      srvyr::summarise(n = srvyr::n(), srvyr::survey_prop(proportion = TRUE)) |>
      dplyr::mutate(gender = "Overall")
  )

  expect_equal_bhhi_srvyr(bhhi_result, srvyr_result)
})

test_that("bhhi_crosstab row percentage works", {
  bhhi_result <- create_test_svy_tbl() |>
    bhhi_crosstab(
      row_var = race,
      col_var = gender,
      pct_direction = "row",
      vartype = "se"
    )

  srvyr_result <- dplyr::bind_rows(
    create_test_svy_tbl() |>
      srvyr::group_by(race, gender) |>
      srvyr::summarise(srvyr::survey_prop(proportion = TRUE)),
    create_test_svy_tbl() |>
      srvyr::group_by(gender) |>
      srvyr::summarise(srvyr::survey_prop(proportion = TRUE)) |>
      dplyr::mutate(race = "Overall")
  )

  expect_equal_bhhi_srvyr(bhhi_result, srvyr_result)
})

test_that("bhhi_crosstab row percentage add_n works", {
  bhhi_result <- create_test_svy_tbl() |>
    bhhi_crosstab(
      row_var = race,
      col_var = gender,
      pct_direction = "row",
      add_n = TRUE,
      vartype = "se"
    )

  srvyr_result <- dplyr::bind_rows(
    create_test_svy_tbl() |>
      srvyr::group_by(race, gender) |>
      srvyr::summarise(n = srvyr::n(), srvyr::survey_prop(proportion = TRUE)),
    create_test_svy_tbl() |>
      srvyr::group_by(gender) |>
      srvyr::summarise(n = srvyr::n(), srvyr::survey_prop(proportion = TRUE)) |>
      dplyr::mutate(race = "Overall")
  )

  expect_equal_bhhi_srvyr(bhhi_result, srvyr_result)
})

test_that("bhhi_crosstab ci works", {
  bhhi_result <- create_test_svy_tbl() |>
    bhhi_crosstab(
      row_var = race,
      col_var = gender,
      pct_direction = "col",
      vartype = "ci"
    )

  srvyr_result <- dplyr::bind_rows(
    create_test_svy_tbl() |>
      srvyr::group_by(gender, race) |>
      srvyr::summarise(srvyr::survey_prop(proportion = TRUE, vartype = "ci")),
    create_test_svy_tbl() |>
      srvyr::group_by(race) |>
      srvyr::summarise(srvyr::survey_prop(proportion = TRUE, vartype = "ci")) |>
      dplyr::mutate(gender = "Overall")
  )

  expect_equal_bhhi_srvyr(bhhi_result, srvyr_result)
})

test_that("bhhi_crosstab ci level works", {
  bhhi_result <- create_test_svy_tbl() |>
    bhhi_crosstab(
      row_var = race,
      col_var = gender,
      pct_direction = "col",
      vartype = "ci",
      level = 0.90
    )

  srvyr_result <- dplyr::bind_rows(
    create_test_svy_tbl() |>
      srvyr::group_by(gender, race) |>
      srvyr::summarise(
        srvyr::survey_prop(proportion = TRUE, vartype = "ci", level = 0.90)
      ),
    create_test_svy_tbl() |>
      srvyr::group_by(race) |>
      srvyr::summarise(
        srvyr::survey_prop(proportion = TRUE, vartype = "ci", level = 0.90)
      ) |>
      dplyr::mutate(gender = "Overall")
  )

  expect_equal_bhhi_srvyr(bhhi_result, srvyr_result)
})

test_that("bhhi_crosstab vartype null works", {
  bhhi_result <- create_test_svy_tbl() |>
    bhhi_crosstab(
      row_var = race,
      col_var = gender,
      pct_direction = "col",
      vartype = NULL
    )

  srvyr_result <- dplyr::bind_rows(
    create_test_svy_tbl() |>
      srvyr::group_by(gender, race) |>
      srvyr::summarise(srvyr::survey_prop(proportion = TRUE, vartype = NULL)),
    create_test_svy_tbl() |>
      srvyr::group_by(race) |>
      srvyr::summarise(srvyr::survey_prop(proportion = TRUE, vartype = NULL)) |>
      dplyr::mutate(gender = "Overall")
  )

  expect_equal_bhhi_srvyr(bhhi_result, srvyr_result)
})

test_that("bhhi_crosstab proportion false works", {
  bhhi_result <- create_test_svy_tbl() |>
    bhhi_crosstab(
      row_var = race,
      col_var = gender,
      pct_direction = "col",
      vartype = "se",
      proportion = FALSE
    )

  srvyr_result <- dplyr::bind_rows(
    create_test_svy_tbl() |>
      srvyr::group_by(gender, race) |>
      srvyr::summarise(srvyr::survey_prop(proportion = FALSE)),
    create_test_svy_tbl() |>
      srvyr::group_by(race) |>
      srvyr::summarise(srvyr::survey_prop(proportion = FALSE)) |>
      dplyr::mutate(gender = "Overall")
  )

  expect_equal_bhhi_srvyr(bhhi_result, srvyr_result)
})
