test_that("bhhi_new_quarto() errors with existing file", {
  withr::local_dir(withr::local_tempdir())

  file.create("bhhi-quarto.qmd")

  expect_error(bhhi_new_quarto())
})

skip_if_offline("github.com")

test_that("bhhi_new_quarto() works with nothing present", {
  withr::local_dir(withr::local_tempdir())

  mock_add_quarto_format()

  bhhi_new_quarto()

  expect_true(file.exists("bhhi-quarto.qmd"))
  expect_true(dir.exists(bhhi_quarto_path()))
})

test_that("bhhi_new_quarto('test') works with nothing present", {
  withr::local_dir(withr::local_tempdir())

  mock_add_quarto_format()

  bhhi_new_quarto("test")

  expect_true(file.exists("test.qmd"))
  expect_true(dir.exists(bhhi_quarto_path()))
})

test_that("bhhi_new_quarto('test.qmd') works with nothing present", {
  withr::local_dir(withr::local_tempdir())

  mock_add_quarto_format()

  bhhi_new_quarto("test.qmd")

  expect_true(file.exists("test.qmd"))
  expect_true(dir.exists(bhhi_quarto_path()))
})

test_that("bhhi_new_quarto() works with format present", {
  withr::local_dir(withr::local_tempdir())

  add_quarto_format(no_prompt = TRUE, quiet = TRUE)

  bhhi_new_quarto()

  expect_true(file.exists("bhhi-quarto.qmd"))
  expect_true(dir.exists(bhhi_quarto_path()))
})

test_that("bhhi_new_quarto() works with no template present", {
  withr::local_dir(withr::local_tempdir())

  add_quarto_format(no_prompt = TRUE, quiet = TRUE)

  unlink(file.path(bhhi_quarto_path(), "template.qmd"))

  bhhi_new_quarto()

  expect_true(file.exists("bhhi-quarto.qmd"))
  expect_true(dir.exists(bhhi_quarto_path()))
})
