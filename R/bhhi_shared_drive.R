#' Build BHHI Shared Drive File Paths
#'
#' Helper making it easy to create OS-independent file paths referencing the
#' BHHI shared drive. It requires the path to the root of the shared drive on
#' your system stored in an environment variable. Then it builds the path
#' relative to the shared drive root (ie. `Y:/Research/BHHI` or
#' `//sfgh02.som.ucsf.edu/shared$/vol02/CVP/Research/BHHI`).
#'
#' @param path File path relative to the shared drive root. Can be omitted to
#'   get the path to the shared drive root.
#' @param envvar_name Name of the environment variable holding the path to the
#'   shared drive root on your system. Defaults to "BHHI_SHARED_DRIVE".
#'
#' @return Absolute path to the file or directory on the shared drive that is
#'   correct for your system.
#' @export
#'
#' @examples
#' bhhi_shared_drive("statewide_survey_processed_data/latest/statewide_survey_processed.rds")
#' bhhi_shared_drive()
bhhi_shared_drive <- function(path = "", envvar_name = "BHHI_SHARED_DRIVE") {
  file.path(Sys.getenv(envvar_name), path)
}
