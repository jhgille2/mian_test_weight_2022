#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param full_data
split_full_data <- function(full_data) {

  # Split the full data by test
  split_by_test <- split_factors(full_data, test)
  
  # This list has just the tests that have test weight data for multiple years
  multiple_years           <- split_by_test[which(map_dbl(split_by_test, function(x) length(unique(x$year))) > 1)]
  
  # These tests have test weight data in a single year
  single_year              <- split_by_test[setdiff(names(split_by_test), names(multiple_years))]
  
  # From among the tests that have test weight data for only a single year, 
  # these tests have test weight data in multiple locations
  single_year_multiple_env <- single_year[which(map_dbl(single_year, function(x) length(unique(x$env))) > 1)]
  
  # And these tests have test weight data for only a single location, 
  # within a single year
  single_year_single_env   <- single_year[setdiff(names(single_year), names(single_year_multiple_env))]
  
  
  # A function that removes the genotypes that were not included
  # in each year in a test
  remove_discarded_genos <- function(test_data){
    
    # Get a table of just what genotypes were included in each year and
    # then split this table by year
    split_year <- test_data %>% 
      select(year, genotype) %>% 
      distinct() %>% 
      split_factors(year)
    
    # Find the genotypes from 2020 that were not in 2021
    discarded_genos <- setdiff(split_year$`2020`$genotype, split_year$`2021`$genotype)
    
    test_data_non_discarded <- test_data %>% 
      dplyr::filter(!genotype %in% discarded_genos)
    
    return(test_data_non_discarded)
  }
  
  # Remove the genotypes from the multi-year tests that were not grown in 
  # both years
  multiple_years <- map(multiple_years, remove_discarded_genos)
  
  # And return the three dataframes in a list
  res <- list("multiple_years"           = multiple_years,
              "single_year_multiple_env" = single_year_multiple_env, 
              "single_year_single_env"   = single_year_single_env)
  
  return(res)
}
