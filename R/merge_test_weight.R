#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param test_weight_data_2020
#' @param test_weight_data_2021
merge_test_weight <- function(test_weight_data_2020, test_weight_data_2021) {

  test_weight_data_2020 %<>%
    mutate(rep = as.character(rep)) %>% 
    select(-code) %>% 
    mutate(year = 2020)
  
  twt_merged <- bind_rows(test_weight_data_2020, test_weight_data_2021) %>% 
    select(test, loc, year, genotype, rep, twt_weight, twt_date_time)

  
  return(twt_merged)
}
