#' Install BHHI Quarto Format
#'
#' Installs the [BHHI Quarto format](https://github.com/ucsf-bhhi/bhhi-quarto)
#' from GitHub.
#'
#' @export
bhhi_install_quarto_format <- function() {
  cli::cli_alert_info(
    "Installing the {.href [BHHI Quarto format](https://github.com/ucsf-bhhi/bhhi-quarto)} from GitHub..."
  )

  install_quarto_format()
}

install_quarto_format <- function() {
  quarto::quarto_add_extension(extension = "ucsf-bhhi/bhhi-quarto")
}
