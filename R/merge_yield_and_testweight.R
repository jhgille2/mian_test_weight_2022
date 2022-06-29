#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param merged_test_weight
#' @param merged_yield
merge_yield_and_testweight <- function(merged_test_weight, merged_yield, util_tables) {

  # Use the test, loc, year, genotype, and rep columns to join the test weight
  # and yield dataframes and then add a column called "env" that is a combination
  # of year and location to make a seperate environment for each year by location
  # combination
  twt_yield_merged <- left_join(merged_test_weight, merged_yield, 
                          by = c("test", "loc", "year", "genotype", "rep")) %>% 
    mutate(env = paste(loc, year, sep = " - "), 
           genotype = str_squish(genotype)) %>% 
    relocate(env, .after = year) %>% 
    select(-twt_date_time)
  
  # Recode the genotype column to standardize genotype names in case different
  # names were used for the same genotype in different seasons
  twt_yield_merged <- convert_from_table(twt_yield_merged, "genotype", util_tables$genotype_conversion_table)
    
  
  # And return this joined dataframe
  return(twt_yield_merged)
}
