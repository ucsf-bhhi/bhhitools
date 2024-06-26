% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bhhi_reshape_crosstab.R
\name{bhhi_reshape_crosstab}
\alias{bhhi_reshape_crosstab}
\title{Pivot a Crosstab to Wide Form}
\usage{
bhhi_reshape_crosstab(.data, row_var, col_var)
}
\arguments{
\item{.data}{A tibble from \code{\link[=bhhi_crosstab]{bhhi_crosstab()}}}

\item{row_var}{Variable to show in the rows in output.}

\item{col_var}{Variable to show in the columns in output.}
}
\description{
Pivots a crosstab from \code{\link[=bhhi_crosstab]{bhhi_crosstab()}} from long form to wide form.
}
\examples{
data("nhanes", package = "survey")

survey_object <- nhanes |>
  dplyr::rename(gender = RIAGENDR) |>
  dplyr::mutate(
    gender = factor(gender, 1:2, c("Male", "Female")),
    race = factor(race, 1:4, c("Hispanic", "White", "Black", "Other"))
  ) |>
  srvyr::as_survey(weights = WTMEC2YR)

survey_object |>
  bhhi_crosstab(race, gender) |>
  bhhi_reshape_crosstab(race, gender)
}
