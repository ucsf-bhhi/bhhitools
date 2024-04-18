test_token = Sys.getenv("BHHITOOLS_DEMO")

test_data = function(filename) {
  readRDS(testthat::test_path(file.path("test-data", filename)))
}

mock_add_quarto_format = function() {
  with_mocked_bindings(
    bhhi_add_quarto(),
    add_quarto_format = function() {
      quarto::quarto_add_extension("ucsf-bhhi/bhhi-quarto", no_prompt = TRUE)
    }
  )
}
