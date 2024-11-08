
test_that("mean, median, range, and n are computed and output is structured as intended", {
  # Create test dataset with NAs
  set.seed(12) # set starting point for randomization
  iris_with_na <- iris |>
    mutate(Sepal.Length = replace(Sepal.Length, sample(n(), 10), NA)) # insert 10 NA values

  result <- basic_stats(iris_with_na, Sepal.Length, Species)

  # Run the tests
  expect_s3_class(result, "tbl_df") # tibble output
  expect_equal(nrow(result), length(levels(iris$Species))) # 1 row per species
  expect_true(all(c("mean", "median", "range", "n") %in% names(result))) # summary stats as columns
  expect_false(any(is.na(result))) # no null values made it into the output
})


test_that("variable types are handled appropriately", {
  # Create test dataset with type incompatibilities
  iris_chr_test <- iris |>
    mutate(
      Sepal.Length = as.character(Sepal.Length),
      Species = as.character(Species)
    )

  iris_num_test <- iris |>
    mutate(Sepal.Length = as.factor(Sepal.Length))

  # Run the tests
  expect_error(basic_stats(iris_chr_test, Sepal.Width, Sepal.Length),
               "Grouping variable must be a non-empty factor or a character variable with fewer than 20 unique values.")
  expect_warning(basic_stats(iris_chr_test, Sepal.Width, Species),
                 "Species has been converted to a factor with 3 levels.")
  expect_error(basic_stats(iris_num_test, Sepal.Length, Species),
               "Variable Sepal.Length must be numeric.")
})

