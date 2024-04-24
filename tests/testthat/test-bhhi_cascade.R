test_that("two-way proportion works", {
  nhanes <- create_test_svy_tbl()

  bhhi_version <- nhanes |>
    srvyr::group_by(gender, race) |>
    bhhi_cascade(srvyr::survey_prop())

  srvyr_version <- dplyr::bind_rows(
    nhanes |>
      srvyr::group_by(gender, race) |>
      srvyr::summarise(srvyr::survey_prop()),
    nhanes |>
      srvyr::group_by(race) |>
      srvyr::summarise(srvyr::survey_prop())
  ) |>
    dplyr::mutate(gender = factor(dplyr::if_else(is.na(gender), "Overall", gender)))

  expect_equal(bhhi_version, srvyr_version, ignore_attr = TRUE)
})

test_that("two-way proportion with n works", {
  nhanes <- create_test_svy_tbl()

  bhhi_version <- nhanes |>
    srvyr::group_by(gender, race) |>
    bhhi_cascade(n = dplyr::n(), srvyr::survey_prop())

  srvyr_version <- dplyr::bind_rows(
    nhanes |>
      srvyr::group_by(gender, race) |>
      srvyr::summarise(n = dplyr::n(), srvyr::survey_prop()),
    nhanes |>
      srvyr::group_by(race) |>
      srvyr::summarise(n = dplyr::n(), srvyr::survey_prop())
  ) |>
    dplyr::mutate(gender = factor(dplyr::if_else(is.na(gender), "Overall", gender)))

  expect_equal(bhhi_version, srvyr_version, ignore_attr = TRUE)
})

test_that("two-way proportion with n & mean works", {
  nhanes <- create_test_svy_tbl()

  bhhi_version <- nhanes |>
    srvyr::group_by(gender, race) |>
    bhhi_cascade(
      n = dplyr::n(), mean = srvyr::survey_mean(SDMVPSU), srvyr::survey_prop()
    )

  srvyr_version <- dplyr::bind_rows(
    nhanes |>
      srvyr::group_by(gender, race) |>
      srvyr::summarise(
        n = dplyr::n(), mean = srvyr::survey_mean(SDMVPSU), srvyr::survey_prop()
      ),
    nhanes |>
      srvyr::group_by(race) |>
      srvyr::summarise(
        n = dplyr::n(), mean = srvyr::survey_mean(SDMVPSU), srvyr::survey_prop()
      )
  ) |>
    dplyr::mutate(gender = factor(dplyr::if_else(is.na(gender), "Overall", gender)))

  expect_equal(bhhi_version, srvyr_version, ignore_attr = TRUE)
})


test_that("one-way proportion works", {
  nhanes <- create_test_svy_tbl()

  bhhi_version <- withCallingHandlers(
    warning = function(cnd) {
      if (stringr::str_detect(cnd$message, "glm.fit: algorithm did not converge")) {
        rlang::cnd_muffle(cnd)
      } else {
        cnd
      }
    },
    {
      nhanes |>
        srvyr::group_by(gender) |>
        bhhi_cascade(srvyr::survey_prop())
    }
  )

  srvyr_version <- withCallingHandlers(
    warning = function(cnd) {
      if (stringr::str_detect(cnd$message, "glm.fit: algorithm did not converge")) {
        rlang::cnd_muffle(cnd)
      } else {
        cnd
      }
    },
    {
      nhanes |>
        srvyr::group_by(gender) |>
        srvyr::cascade(srvyr::survey_prop(), .fill = "Overall")
    }
  )

  expect_equal(bhhi_version, srvyr_version, ignore_attr = TRUE)
})

test_that("zero-way proportion works", {
  nhanes <- create_test_svy_tbl()

  bhhi_version <- withCallingHandlers(
    warning = function(cnd) {
      if (stringr::str_detect(cnd$message, "glm.fit: algorithm did not converge")) {
        rlang::cnd_muffle(cnd)
      } else {
        cnd
      }
    },
    {
      nhanes |>
        srvyr::group_by() |>
        bhhi_cascade(srvyr::survey_prop())
    }
  )

  srvyr_version <- withCallingHandlers(
    warning = function(cnd) {
      if (stringr::str_detect(cnd$message, "glm.fit: algorithm did not converge")) {
        rlang::cnd_muffle(cnd)
      } else {
        cnd
      }
    },
    {
      nhanes |>
        srvyr::group_by() |>
        srvyr::cascade(srvyr::survey_prop(), .fill = "Overall")
    }
  )

  expect_equal(bhhi_version, srvyr_version, ignore_attr = TRUE)
})

test_that("ungrouped mean works", {
  nhanes <- create_test_svy_tbl()

  bhhi_version <- nhanes |>
    bhhi_cascade(srvyr::survey_mean(SDMVPSU))

  srvyr_version <- nhanes |>
    srvyr::cascade(srvyr::survey_mean(SDMVPSU), .fill = "Overall")

  expect_equal(bhhi_version, srvyr_version, ignore_attr = TRUE)
})

test_that("ungrouped mean works", {
  nhanes <- create_test_svy_tbl()

  bhhi_version <- nhanes |>
    bhhi_cascade(srvyr::survey_mean(SDMVPSU))

  srvyr_version <- nhanes |>
    srvyr::cascade(srvyr::survey_mean(SDMVPSU), .fill = "Overall")

  expect_equal(bhhi_version, srvyr_version, ignore_attr = TRUE)
})
