
# basicstats

The goal of **basicstats** is to make it easier for you to get the basic
summary statistics you want (mean, median, range, and sample size, of
course) based on the groupings you’re most interested in.

## Installation

You can install the development version of `basicstats` from
[GitHub](https://github.com/andrewfullerton/basicstats) with:

``` r
devtools::install_github("andrewfullerton/basicstats")
```

## Using the `basic_stats` function

**basicstats** contains one ground-breaking, revolutionary,
first-of-its-kind function called `basic_stats`. Like magic, you simply
provide some data, a numeric variable you want basic summary statistics
for, a grouping variable by which you want to compute those summary
statistics, and voila!

### Here’s how it works:

``` r
library(basicstats)
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.5
#> ✔ forcats   1.0.0     ✔ stringr   1.5.1
#> ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
#> ✔ purrr     1.0.2     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

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

In addition to this basic functionality, `basic_stats` dynamically and
intelligently handles character to factor conversions.

``` r
iris |> 
  mutate(Species = as.character(Species)) |> # convert species to character
  basic_stats(Sepal.Width, Species)
#> Warning in basic_stats(mutate(iris, Species = as.character(Species)),
#> Sepal.Width, : Species has been converted to a factor with 3 levels.
#> # A tibble: 3 × 5
#>   Species     mean median range         n
#>   <fct>      <dbl>  <dbl> <chr>     <int>
#> 1 setosa      3.43    3.4 2.3 - 4.4    50
#> 2 versicolor  2.77    2.8 2 - 3.4      50
#> 3 virginica   2.97    3   2.2 - 3.8    50
```

It also lets to modify your summary stats to your liking by passing
additional arguments into the function via the `...` argument.

``` r
iris |>
  basic_stats(Sepal.Width, Species, trim = 0.2)
#> # A tibble: 3 × 5
#>   Species     mean median range         n
#>   <fct>      <dbl>  <dbl> <chr>     <int>
#> 1 setosa      3.41    3.4 0.2 - 4.4    50
#> 2 versicolor  2.80    2.8 0.2 - 3.4    50
#> 3 virginica   2.96    3   0.2 - 3.8    50
```

So much power with so little code. Welcome to **basicstats**.
