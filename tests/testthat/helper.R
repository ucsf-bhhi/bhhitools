test_token = Sys.getenv("BHHITOOLS_DEMO")

test_data = function(filename) {
  readRDS(testthat::test_path(file.path("test-data", filename)))
}
