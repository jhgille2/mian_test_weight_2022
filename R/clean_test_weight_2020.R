#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param test_weight_files_2020
clean_test_weight_2020 <- function(files = test_weight_files_2020) {

  twt_data <- read_csv(files) %>% 
    rename(twt_moisture = moisture, 
           twt_weight = weight, 
           twt_date_time = date_time)
  
  rename(twt_data)

}
