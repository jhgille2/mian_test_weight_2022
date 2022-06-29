#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param test_weight_data_2020
#' @param test_weight_data_2021
merge_test_weight <- function(test_weight_data_2020, test_weight_data_2021, util_tables) {

  # Convert the rep column to a character and add a year column to the 2020 data
  test_weight_data_2020 %<>%
    mutate(rep = as.character(rep)) %>% 
    select(-code) %>% 
    mutate(year = 2020)
  
  # Bind the rows of the 2020 and 2021 test weight data 
  twt_merged <- bind_rows(test_weight_data_2020, test_weight_data_2021) %>% 
    select(test, loc, year, genotype, rep, twt_weight, twt_date_time)
  
  # Standardize test names across years and return the final dataframe
  twt_merged <- convert_from_table(twt_merged, "test", util_tables$test_conversion_table)

  return(twt_merged)
}
