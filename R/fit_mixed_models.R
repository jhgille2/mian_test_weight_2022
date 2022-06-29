#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param df
fit_mixed_models <- function(df = split_data$data_2021) {
  
  # Use the gamem_met function from metan to fit a mixed effect model on a tests data
  blup_model <- function(test_data){
    
    model_fit <- gamem_met(test_data,
                           env     = env, 
                           gen     = genotype, 
                           rep     = rep, 
                           resp    = everything(), 
                           random  = "env",
                           verbose = FALSE)
    
    return(model_fit)
  }
  
  # Apply the function to each list element of the df argument (each test)
  model_list <- map(df, blup_model)
  
  # And return the list of fit models
  return(model_list)
}
