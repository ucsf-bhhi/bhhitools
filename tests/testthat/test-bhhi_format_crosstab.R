test_that("bhhi_format_crosstab with se works", {
  create_test_svy_tbl() |>
    srvyr::group_by(race, gender) |>
    bhhi_cascade(srvyr::survey_prop(proportion = TRUE)) |>
    bhhi_reshape_crosstab(race, gender) |>
    bhhi_format_crosstab() |>
    expect_gt_output("bhhi_format_crosstab_se")
})

test_that("bhhi_format_crosstab with ci works", {
  create_test_svy_tbl() |>
    srvyr::group_by(race, gender) |>
    bhhi_cascade(srvyr::survey_prop(vartype = "ci", proportion = TRUE)) |>
    bhhi_reshape_crosstab(race, gender) |>
    bhhi_format_crosstab() |>
    expect_gt_output("bhhi_format_crosstab_ci")
})

test_that("bhhi_format_crosstab with no vartype works", {
  create_test_svy_tbl() |>
    srvyr::group_by(race, gender) |>
    bhhi_cascade(srvyr::survey_prop(vartype = NULL, proportion = TRUE)) |>
    bhhi_reshape_crosstab(race, gender) |>
    bhhi_format_crosstab() |>
    expect_gt_output("bhhi_format_crosstab_no_vartype")
})
