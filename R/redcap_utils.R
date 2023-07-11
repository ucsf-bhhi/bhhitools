#' REDCap API URL
#'
#' Returns the URL for the REDCap API: https://redcap.ucsf.edu/api/
#'
#' @return REDCap API URL
redcap_api_url <- function() {
  "https://redcap.ucsf.edu/api/"
}


#' Fetch appropriate REDCap API Token
#'
#' Fetches the project's REDCap API Token
#'
#' To get your API token, ask one of the BHHI REDCap admins to grant you API
#' privileges and then request a token. See
#' https://redcap.ucsf.edu/api/help/?content=tokens for details.
#'
#' @param project_token_name Name used to store the token via [bhhi_store_token()] or the name of the environment variable with the token.
#'
#' @return The API token.
redcap_token <- function(project_token_name) {
  # check that project_token_name is a string
  if (!is.character(project_token_name)) {
    cli::cli_abort(
      message = c(
        "!" = "project_token_name must be a string.",
        "i" = "You provided a {typeof(project_token_name)}: {project_token_name}."
      ),
      call = rlang::caller_env()
    )
  }

  token <- tryCatch(
    # if the next line down errors, run this instead
    error = function(cnd) Sys.getenv(project_token_name),
    # run this first
    keyring::key_get(project_token_name)
  )

  if (token == "") {
    cli::cli_abort(
      message = c(
        "!" = "Can't find a secret or environment variable named: '{project_token_name}'.",
        "i" = "REDCap API tokens must be stored in a secret (preferred) with {.fn bhhitools::bhhi_store_token} or in an environment variable."
      ),
      call = rlang::caller_env()
    )
  }

  token
}
