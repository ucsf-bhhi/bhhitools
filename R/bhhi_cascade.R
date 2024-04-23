#' Cascade Survey Objects with Full Contingencies
#'
#' Calculates full contingent statistics in the manner of [srvyr::cascade].
#'
#' When calculating a two-way contingency table (a.k.a. crosstab),
#' [srvyr::cascade] calculates proportions of the column variable for each level
#' of the row variable, but calculates the proportion of the row variable for
#' the overall sample. This makes two-way contingency tables difficult with
#' [srvyr::cascade].
#'
#' `bhhi_cascade()` instead calculates the proportion of the column variable for
#' the overall sample, which produces results that are compatible and comparable
#' to the results for the levels of the row variable
#'
#'
#' @inheritParams srvyr::cascade
#' @param .fill Value to fill in for group summaries. Defaults to 'Overall'.
#'
#' @examples
#' data("nhanes", package = "survey")
#'
#' survey_object <- nhanes |>
#'   dplyr::rename(gender = RIAGENDR) |>
#'   dplyr::mutate(
#'     gender = factor(gender, 1:2, c("Male", "Female")),
#'     race = factor(race, 1:4, c("Hispanic", "White", "Black", "Other"))
#'   ) |>
#'   srvyr::as_survey(weights = WTMEC2YR)
#'
#' survey_object |>
#'   srvyr::group_by(gender, race) |>
#'   bhhi_cascade(srvyr::survey_prop(proportion = TRUE))
#'
#' survey_object |>
#'   srvyr::group_by(gender, race) |>
#'   srvyr::cascade(srvyr::survey_prop(proportion = TRUE), .fill = "Overall")
#'
#' @export
bhhi_cascade <- function(.data, ..., .fill = "Overall") {
  UseMethod("bhhi_cascade")
}

#' @export
bhhi_cascade.grouped_svy <- function(.data, ..., .fill = "Overall") {
  group_vars <- srvyr::groups(.data)

  groupings <- generate_groupings(group_vars)

  srvyr::cascade(.data, ..., .fill = .fill, .groupings = groupings)
}

generate_groupings <- function(group_vars) {
  if (length(group_vars) == 0) {
    return(list(NULL))
  }
  if (length(group_vars) == 1) {
    # if there's just one grouping variable return it alone
    return(list(group_vars, NULL))
  } else if (length(group_vars) == 2) {
    # if there are two, return the pair and the last variable alone
    return(list(group_vars, list(group_vars[[2]])))
  } else {
    # else return all the combinations of # of grouping vars to 2 variables
    # filtering for only the combinations containing the last grouping variable
    combinations <- lapply(seq(length(group_vars) - 1, 2), function(i) {
      utils::combn(group_vars, i, simplify = F)
    })

    filtered_combinations <- lapply(combinations, function(x) {
      Filter(\(y) any(y == group_vars[[length(group_vars)]]), x)
    })

    return(
      list(group_vars, filtered_combinations, list(group_vars[[length(group_vars)]]))
    )
  }
}


#' @export
bhhi_cascade.default <- function(.data, ..., .fill = "Overall") {
  srvyr::cascade(.data, .fill = .fill, ...)
}
