#' Securely Store API Tokens
#'
#' Uses [keyring][keyring::key_set()] to securely store API tokens
#' (e.g. REDCap) in your operating system's credential vault.
#'
#' @param token_name Name of the token, a string
#'
#' @export
#'
#' @examplesIf interactive()
#' bhhi_store_token("REDCAP_API_TOKEN")
bhhi_store_token <- function(token_name) {
  token <- askpass::askpass("Enter REDCAP API token:")

  check_redcap_token(token, call = rlang::current_env())

  keyring::key_set_with_value(token_name, password = token)
}

check_redcap_token <- function(token, call) {
  tryCatch(
    error = function(cnd) {
      cli::cli_abort(
        message = c(
          "x" = "The token you provided does not conform to the REDCap API token rules.",
          "i" = "Please double check the token you provided and try again."
        ),
        call = call
      )
    },
    REDCapR::sanitize_token(token)
  )
}
