save_test_data <- function(data, filename = NULL) {
  if (is.null(filename)) {
    filename <- rlang::as_string(rlang::ensym(data))
  }

  saveRDS(data, testthat::test_path("test-data", paste0(filename, ".rds")))
}
