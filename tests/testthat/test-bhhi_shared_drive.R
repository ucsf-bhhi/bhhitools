test_that("shared drive paths work", {
  shared_drive_path <- "Y:/Research/BHHI"
  alt_shared_drive_path <- "//sfgh02.som.ucsf.edu/shared$/vol02/CVP/Research/BHHI"

  withr::local_envvar(BHHI_SHARED_DRIVE = shared_drive_path)
  withr::local_envvar(ALT_BHHI_SHARED_DRIVE = alt_shared_drive_path)

  # drive roots
  expect_equal(
    bhhi_shared_drive(),
    shared_drive_path
  )
  expect_equal(
    bhhi_shared_drive(envvar_name = "ALT_BHHI_SHARED_DRIVE"),
    alt_shared_drive_path
  )

  # paths to files
  expect_equal(
    bhhi_shared_drive("test/test.rds"),
    file.path(shared_drive_path, "test/test.rds")
  )
  expect_equal(
    bhhi_shared_drive("test/test.rds", "ALT_BHHI_SHARED_DRIVE"),
    file.path(alt_shared_drive_path, "test/test.rds")
  )
})
