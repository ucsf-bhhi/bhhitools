skip_if_offline("github.com")

test_that("bhhi_add_quarto() works", {
  tempdir = withr::local_tempdir()
  withr::local_dir(tempdir)

  mock_add_quarto_format()

  expect_true(dir.exists("_extensions/ucsf-bhhi/bhhi-quarto/"))
  expect_false(file.exists("template.qmd"))
})
