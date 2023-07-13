test_token = "E498C23B78DD50CE906A9A37765E9B09"

test_data = function(filename) {
  readRDS(testthat::test_path(file.path("test-data", filename)))
}
