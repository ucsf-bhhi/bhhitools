test_that("stata name prep works", {
  expect_identical(
    dplyr::tibble(
      x = 1,
      y.y = 2,
      abcdefghijklmnopqrstuvwxyzabcdefghijkl = 3,
      `0x` = 4
    ) |>
      bhhi_prep_for_stata(),
    dplyr::tibble(
      x = 1,
      y_y = 2,
      abcdefghijklmnopqrstuvwxyzabcdef = 3,
      `_0x` = 4
    )
  )
})
