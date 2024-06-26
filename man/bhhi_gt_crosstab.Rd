% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bhhi_gt_crosstab.R
\name{bhhi_gt_crosstab}
\alias{bhhi_gt_crosstab}
\title{Create Formatted Weighted Crosstab}
\usage{
bhhi_gt_crosstab(
  .data,
  row_var,
  col_var,
  pct_direction = "col",
  add_n = FALSE,
  vartype = c("se", "ci", "var", "cv"),
  level = 0.95,
  proportion = TRUE,
  decimals = 1,
  convert_labelled = TRUE,
  na.rm = FALSE
)
}
\arguments{
\item{.data}{tbl A \code{tbl_svy} object}

\item{row_var}{Variable to show in the rows in output.}

\item{col_var}{Variable to show in the columns in output.}

\item{pct_direction}{\code{'col'} to calculate column percentages or \code{'row'} to
calculate row percentages. Defaults to \code{'col'}.}

\item{add_n}{Add cell N to output. Defaults to FALSE.}

\item{vartype}{Report variability as zero or more of: standard error ("se",
default), confidence interval ("ci"), variance ("var") or coefficient of
variation ("cv"). Defaults to hiding variability.}

\item{level}{(For vartype = "ci" only) A single number or vector of numbers indicating
the confidence level}

\item{proportion}{Use methods to calculate the proportion that may have more accurate
confidence intervals near 0 and 1. Based on
\code{\link[survey]{svyciprop}}.}

\item{decimals}{An integer specifing the number of decimal places in the
results. Defaults to 1.}

\item{convert_labelled}{If either \code{row_var} or \code{col_var} is
\code{\link[haven:labelled]{haven::labelled}}, automatically convert to factor. Defaults to TRUE.}

\item{na.rm}{Drop missing values. Defaults to FALSE.}
}
\description{
Uses \code{\link[=bhhi_cascade]{bhhi_cascade()}} with \code{\link[srvyr:survey_mean]{srvyr::survey_prop()}} to calculate weighted
crosstabs and then uses \code{\link[=bhhi_format_crosstab]{bhhi_format_crosstab()}} to create nicely formatted
output via the \code{\link{gt}} table package.
}
\section{Examples}{


\if{html}{\out{<div class="sourceCode r">}}\preformatted{data("nhanes", package = "survey")

survey_object <- nhanes |>
  dplyr::rename(gender = RIAGENDR) |>
  dplyr::mutate(
    gender = factor(gender, 1:2, c("Male", "Female")),
    race = factor(race, 1:4, c("Hispanic", "White", "Black", "Other"))
  ) |>
  srvyr::as_survey(weights = WTMEC2YR)

survey_object |>
  bhhi_gt_crosstab(race, gender)

 survey_object_labelled <- nhanes |>
  dplyr::rename(gender = RIAGENDR) |>
  dplyr::mutate(
    gender = factor(gender, 1:2, c("Male", "Female")),
    race = factor(race, 1:4, c("Hispanic", "White", "Black", "Other")),
    dplyr::across(c(gender, race), labelled::to_labelled)
  ) |>
  srvyr::as_survey(weights = WTMEC2YR)

  survey_object_labelled |>
  bhhi_gt_crosstab(race, gender)
}\if{html}{\out{</div>}}

\if{html}{\out{
<img src='man_bhhi_gt_crosstab_1.png' class='gt-example-img'>
}}

\if{html}{\out{<div class="sourceCode r">}}\preformatted{survey_object |>
  bhhi_gt_crosstab(
    race, gender, pct_direction = "row", vartype = "ci", decimals = 2
  )
}\if{html}{\out{</div>}}

\if{html}{\out{
<img src='man_bhhi_gt_crosstab_2.png' class='gt-example-img'>
}}
}

