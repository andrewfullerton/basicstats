#' @title Basic summary stats by group
#' @description Presents mean, median, range, and sample size by group in an easy-to-read tibble.
#'
#' @param data a data frame or tibble containing `x` and `by`.
#' @param x a numeric variable in the dataset to compute summary statistics for.
#' @param by a factor or character variable in the dataset by which to compute summary statistics.
#' @param na.rm a logical evaluation to `TRUE` or `FALSE` indicating whether `NA` values should be stripped.
#' @param ... for further arguments to modify the calculation and formatting of the summary statistics.
#'
#' @return a tibble with mean, median, range, and sample size calculations by levels of your chosen grouping variable.
#' @import dplyr tibble
#' @importFrom stats median na.omit
#' @export
#'
#' @examples
#' # Basic usage:
#' basic_stats(iris, Sepal.Width, Species)
#' # Produces summary stats for Sepal.Width by levels
#' # of Species from the iris dataset.
#'
#' # Advanced usage:
#' basic_stats(iris, Sepal.Width, Species, na.rm = FALSE, trim = 0.1)
#' # Modifies the previous example by retaining
#' # null values and trimming the 10% most extreme values.
basic_stats <- function(data, x, by, na.rm = TRUE, ...) {
  # Check if input 'data' is a non-empty data frame or tibble
  if (!is.data.frame(data) || nrow(data) == 0 || ncol(data) == 0) {
    stop("Input data must be a non-empty dataframe or tibble.")
  }

  # Convert to tibble for consistency
  data <- tibble::as_tibble(data)

  # Store variable names for use later in function
  x_name <- deparse(substitute(x))
  by_name <- deparse(substitute(by))

  # Check if 'x' exists and is numeric
  if (!x_name %in% names(data)) {
    stop(x_name, " not found in the data.")
  } else if (length(stats::na.omit(data |> dplyr::pull({{ x }}))) == 0) {
    stop(x_name, " doesn't contain any non-missing values.")
  } else if (!is.numeric(data |> dplyr::pull({{ x }}))) {
    stop("Variable ", x_name, " must be numeric.")
  }

  # Check if 'by' exists and is usable
  if (!by_name %in% names(data)) {
    stop("Grouping variable ", by_name, " not found in the data.")
  } else if (length(stats::na.omit(data |> dplyr::pull({{ by }}))) == 0) {
    stop("Grouping variable ", by_name, "doesn't contain any non-missing values.")
  }

  by_var <- data |> dplyr::pull({{ by }}) # extract column from data frame as vector

  if (!is.factor(by_var)) {
    unique_count <- length(unique(by_var)) # count unique values in grouping var

    if (is.character(by_var) && unique_count < 20) {
      data <- data |> dplyr::mutate({{ by }} := as.factor({{ by }})) # convert to factor
      warning(by_name, " has been converted to a factor with ", unique_count, " levels.")
    } else {
      stop("Grouping variable must be a non-empty factor or a character variable with fewer than 20 unique values.")
    }
  }

  # Final check for for sufficient 'by' factor levels
  if (length(unique(by_var)) < 2) {
    warning("Grouping variable ", by_name, " only has 1 level.")
  }

  # Run the summary
  result <- data |>
    dplyr::group_by({{ by }}) |>
    dplyr::summarise(
      mean = mean({{ x }}, na.rm = na.rm, ...),
      median = stats::median({{ x }}, na.rm = na.rm, ...),
      range = paste0(min({{ x }}, na.rm = na.rm, ...), " - ",
                     max({{ x }}, na.rm = na.rm, ...)),
      n = dplyr::n()
    )

  return(result)
}
