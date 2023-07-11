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
  keyring::key_set(token_name, prompt = "Enter token:")
}
