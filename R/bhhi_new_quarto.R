#' Create a New BHHI Quarto File
#'
#' Prepares a .qmd file with the BHHI template and ensures the [BHHI Quarto format](https://github.com/ucsf-bhhi/bhhi-quarto) is installed.
#'
#' @param filename Name of the new .qmd file.
#' @param open Open the new file in editor.
#' @export
bhhi_new_quarto <- function(filename = "bhhi-quarto.qmd", open = TRUE) {
  filename = check_file_extension(filename)
  stop_if_file_exists(filename)

  # if the format is not already installed, use quarto use to install it & the template
  if (!fs::dir_exists(bhhi_quarto_path())) {
    cli::cli_alert_info("BHHI Quarto not installed.", wrap = TRUE)
    bhhi_add_quarto()
    copy_template(filename, open)
    # if the template exists copy it to the current directory
  } else if (fs::file_exists(fs::path(bhhi_quarto_path(), "template.qmd"))) {
    copy_template(filename, open)
    # if the user approves overwrite the format with a new version with the template
  } else {
    cli::cli_alert_warning("BHHI Quarto template not found.")
    cli::cli_alert_info(
      "Downloading {.href [BHHI Quarto template](https://github.com/ucsf-bhhi/bhhi-quarto)} from GitHub..."
    )
    fetch_quarto_template()
    copy_template(filename, open)
  }
}

bhhi_quarto_path = function() "_extensions/ucsf-bhhi/bhhi-quarto"

check_file_extension = function(filename) {
  # make sure supplied file name has .qmd extension
  fs::path_ext_set(filename, ".qmd")
}

stop_if_file_exists = function(filename) {
  if (!is.null(filename) & fs::file_exists(filename)) {
    cli::cli_abort(
      "File {.file {filename}} exists.",
      call = rlang::caller_env()
    )
  }
}

copy_template = function(filename, open) {
  fs::file_copy(fs::path(bhhi_quarto_path(), "template.qmd"), filename)

  notify_file_created(filename)

  open_file(open, filename)
}

notify_file_created = function(filename) {
  cli::cli_inform("{.path {filename}} created.")
}

open_file = function(open, filename) {
  if (open & interactive()) {
    file.edit(filename)
  }
}

fetch_quarto_template = function() {
  cwd = getwd()
  withr::local_dir(withr::local_tempdir())

  add_quarto_format(no_prompt = TRUE, quiet = TRUE)
  fs::file_copy(
    fs::path(bhhi_quarto_path(), "template.qmd"),
    fs::path(cwd, bhhi_quarto_path())
  )
}
