#' Install BHHI Quarto Format
#'
#' Installs the [BHHI Quarto format](https://github.com/ucsf-bhhi/bhhi-quarto)
#' from GitHub.
#'
#' @export
bhhi_add_quarto <- function() {
  cli::cli_alert_info(
    "Installing the {.href [BHHI Quarto format](https://github.com/ucsf-bhhi/bhhi-quarto)} from GitHub..."
  )

  add_quarto_format()
}

add_quarto_format <- function(no_prompt = TRUE, ...) {
  quarto::quarto_add_extension(
    extension = "ucsf-bhhi/bhhi-quarto", no_prompt = no_prompt, ...
  )
}
