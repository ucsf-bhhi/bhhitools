test_that("bhhi_install_quarto_format() works", {
  tempdir = withr::local_tempdir()
  withr::local_dir(tempdir)

  with_mocked_bindings(
    bhhi_install_quarto_format(),
    install_quarto_format = function() {
      quarto::quarto_add_extension("ucsf-bhhi/bhhi-quarto", no_prompt = TRUE)
    }
  )

  expect_true(dir.exists("_extensions/ucsf-bhhi/bhhi-quarto/"))
})
