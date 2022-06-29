#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param full_data
split_full_data <- function(full_data) {

  data_2021 <- full_data %>% 
    dplyr::filter(year == 2021) %>% 
    metan::split_factors(test)
  
  data_2020 <- full_data %>%
    dplyr::filter(year == 2020) %>% 
    metan::split_factors(test)
  
  res <- list("data_2020" = data_2020,
              "data_2021" = data_2021, 
              "full_data" = full_data)
  
  return(res)
}
