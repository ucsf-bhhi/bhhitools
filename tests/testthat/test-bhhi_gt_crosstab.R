test_that("bhhi_gt_crosstab with se works", {
  create_test_svy_tbl() |>
    bhhi_gt_crosstab(race, gender, vartype = "se") |>
    expect_gt_output("bhhi_gt_crosstab_se")
})

test_that("bhhi_gt_crosstab with ci works", {
  create_test_svy_tbl() |>
    bhhi_gt_crosstab(race, gender, vartype = "ci") |>
    expect_gt_output("bhhi_gt_crosstab_ci")
})

test_that("bhhi_gt_crosstab with no vartype works", {
  create_test_svy_tbl() |>
    bhhi_gt_crosstab(race, gender, vartype = NULL) |>
    expect_gt_output("bhhi_gt_crosstab_no_vartype")
})

test_that("bhhi_gt_crosstab with 0 decimal works", {
  create_test_svy_tbl() |>
    bhhi_gt_crosstab(race, gender, decimals = 0, vartype = "ci") |>
    expect_gt_output("bhhi_gt_crosstab_0_decimal")
})
