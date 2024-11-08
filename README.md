
<!-- README.md is generated from README.Rmd. Please edit that file -->

# basicstats

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

**basicstats** makes it easier for you to produce basic summary
statistics (mean, median, range, and sample size) by levels of a
categorical variable in a tidy, easy-to-read summary.

## Installation

You can install the development version of `basicstats` from
[GitHub](https://github.com/andrewfullerton/basicstats) with:

``` r
# install.packages("devtools")
devtools::install_github("andrewfullerton/basicstats")
```

## Using basicstats

**basicstats** contains a single functional called `basic_stats`. Simply
provide some data, a numeric variable you want basic summary statistics
for, and a grouping variable by which to compute those summary
statistics, and voila!

### Here’s how it works:

Load the package.

``` r
library(basicstats)
```

`basic_stats` generates a tidy, easy-to-read tibble that contains the
mean, median, range, and sample size by levels of your chosen grouping
variable. Here’s an example using `Sepal.Width` and `Species` from the
`iris` dataset.

``` r
iris |> 
  basic_stats(Sepal.Width, Species)
#> # A tibble: 3 × 5
#>   Species     mean median range         n
#>   <fct>      <dbl>  <dbl> <chr>     <int>
#> 1 setosa      3.43    3.4 2.3 - 4.4    50
#> 2 versicolor  2.77    2.8 2 - 3.4      50
#> 3 virginica   2.97    3   2.2 - 3.8    50
```

In addition to this basic functionality, `basic_stats` also dynamically
and intelligently handles character to factor and data frame to tibble
conversions. Here’s an example passing in a data frame, `iris`, with a
character variable, `Species`, as our grouping variable. The data frame
is seamlessly converted to a tibble and `Species` is converted to a
factor.

``` r
iris |>
  transform(Species = as.character(Species)) |>
  basic_stats(Sepal.Width, Species)
#> Warning in basic_stats(transform(iris, Species = as.character(Species)), :
#> Species has been converted to a factor with 3 levels.
#> # A tibble: 3 × 5
#>   Species     mean median range         n
#>   <fct>      <dbl>  <dbl> <chr>     <int>
#> 1 setosa      3.43    3.4 2.3 - 4.4    50
#> 2 versicolor  2.77    2.8 2 - 3.4      50
#> 3 virginica   2.97    3   2.2 - 3.8    50
```

To get the most out of `basic_stats`, you can further modify the
calculation and presentation of your summary statistics by passing
additional parameters into the function via `...`. Here’s an example
using `trim` to remove some extreme values from the data before
calculating our summary statistics.

``` r
iris |>
  basic_stats(Sepal.Width, Species, trim = 0.3)
#> # A tibble: 3 × 5
#>   Species     mean median range         n
#>   <fct>      <dbl>  <dbl> <chr>     <int>
#> 1 setosa      3.41    3.4 0.3 - 4.4    50
#> 2 versicolor  2.81    2.8 0.3 - 3.4    50
#> 3 virginica   2.96    3   0.3 - 3.8    50
```

## Thanks for checking out basicstats!
