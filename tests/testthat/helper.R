test_token = Sys.getenv("BHHITOOLS_TEST_REDCAP_TOKEN")

test_data = function(filename) {
  readRDS(testthat::test_path(file.path("test-data", filename)))
}
