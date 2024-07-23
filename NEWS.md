# bhhitools 0.6.2

* Fixed bug with `bhhi_cascade()` when grouping by 3+ variables.

# bhhitools 0.6.1

* Fixed bug with `bhhi_gt_crosstab()` and `bhhi_format_crosstab()` when the row variable name ended with "_" and 2-4 other characters.

# bhhitools 0.6.0

* Auto-convert variables with Stata value labels from  [haven::labelled] to factors in `bhhi_crosstab()` and `bhhi_gt_crosstab()`.

* Fix bug in auto-opening .qmd file with `bhhi_new_quarto()`.

# bhhitools 0.5.0

* Adds tools for making survey crosstabs easier: `bhhi_crosstab()`, `bhhi_gt_crosstab()`, `bhhi_cascade()`, `bhhi_reshape_crosstab()`, & `bhhi_format_crosstab()`.

# bhhitools 0.4.0

* Adds tools for working with the [BHHI Quarto format](https://github.com/ucsf-bhhi/bhhi-quarto): `bhhi_new_quarto()` & `bhhi_add_quarto()`. 

# bhhitools 0.3.0

* Adds `bhhi_format_table()` which applies common formatting to tables output in Quarto, R Markdown, etc. 

# bhhitools 0.2.0

* Adds `bhhi_shared_drive()` which builds OS-independent file paths to the BHHI shared drive.

# bhhitools 0.1.0

* Initial version.
