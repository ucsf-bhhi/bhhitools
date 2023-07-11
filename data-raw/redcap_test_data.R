library(charlatan)
library(dplyr)

name_generator <- PersonProvider$new()

street_names <- c(
  "Main Street", "2nd Street", "3rd Street", "4th Street", "5th Street",
  "6th Street", "7th Street", "1st Street", "8th Street", "9th Street"
)

address <- function() {
  paste(paste(ch_integer(), sample(street_names, 1)), "San Francisco", "CA", ch_integer(min = 94111, max = 94119), sep = ", ")
}

dob <- function() {
  paste(
    sample(1940:2010, 1),
    sprintf("%02.0f", sample(1:12, 1)),
    sprintf("%02.0f", sample(1:28, 1)),
    sep = "-"
  )
}

fake_data <- tibble(
  first_name = replicate(100, name_generator$first_name()),
  last_name = replicate(100, name_generator$last_name()),
  address = replicate(100, address()),
  dob = replicate(100, dob()),
  ethnicity = sample(0:2, 100, replace = TRUE),
  race = sample(0:6, 100, replace = TRUE),
  sex = sample(0:1, 100, replace = TRUE),
  height = sample(130:215, 100, replace = TRUE),
  weight = sample(35:200, 100, replace = TRUE),
  comments = ch_company(100),
  venue_2 = sample(1:26, 100, replace = TRUE)
)
