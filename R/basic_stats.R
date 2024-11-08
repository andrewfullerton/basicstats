basic_stats <- function(data, x, by, na.rm = TRUE, ...) {
  # Check if input 'data' is a non-empty data frame or tibble
  if (!is.data.frame(data) || nrow(data) == 0 || ncol(data) == 0) {
    stop("Input data must be a non-empty dataframe or tibble.")
  }

  # Convert to tibble for consistency
  data <- as_tibble(data)

  # Store variable names for use later in function
  x_name <- deparse(substitute(x))
  by_name <- deparse(substitute(by))

  # Check if 'x' exists and is numeric
  if (!x_name %in% names(data)) {
    stop(x_name, " not found in the data.")
  } else if (length(na.omit(data |> pull({{ x }}))) == 0) {
    stop(x_name, " doesn't contain any non-missing values.")
  } else if (!is.numeric(data |> pull({{ x }}))) {
    stop("Variable ", x_name, " must be numeric.")
  }

  # Check if 'by' exists and is usable
  if (!by_name %in% names(data)) {
    stop("Grouping variable ", by_name, " not found in the data.")
  } else if (length(na.omit(data |> pull({{ by }}))) == 0) {
    stop("Grouping variable ", by_name, "doesn't contain any non-missing values.")
  }

  by_var <- data |> pull({{ by }}) # extract column from data frame as vector

  if (!is.factor(by_var)) {
    unique_count <- length(unique(by_var)) # count unique values in grouping var

    if (is.character(by_var) && unique_count < 20) {
      data <- data |> mutate({{ by }} := as.factor({{ by }})) # convert to factor
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
    group_by({{ by }}) |>
    summarise(
      mean = mean({{ x }}, na.rm = na.rm, ...),
      median = median({{ x }}, na.rm = na.rm, ...),
      range = paste0(min({{ x }}, na.rm = na.rm, ...), " - ",
                     max({{ x }}, na.rm = na.rm, ...)),
      n = n()
    )

  return(result)
}
