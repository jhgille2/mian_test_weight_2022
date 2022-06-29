#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param df
fit_mixed_models_one_env <- function(df = split_data$single_year_single_env) {
  
  # Use the gamem_met function from metan to fit a mixed effect model on a tests data
  blup_model <- function(test_data){
    
    # Remove the year column from the data first so that the 
    # everything() function can be used to select 
    # just the phenotypes. Also remove any phenotype columns that do not
    # have observations in one of the environments
    measure_vars <- c("twt_weight",
                      "md", 
                      "lod", 
                      "ht", 
                      "yield", 
                      "sdwt", 
                      "sq", 
                      "oil_dry_basis", 
                      "protein_dry_basis")
    
    missing_vars <- test_data %>% 
      pivot_longer(cols = measure_vars) %>% 
      group_by(env, name) %>% 
      summarise(miss_prop = sum(is.na(value))/n()) %>% 
      ungroup() %>% 
      dplyr::filter(miss_prop == 1)
    
    missing_var_names <- c(unique(missing_vars$name), "year")
    
    test_data %<>%
      select(-any_of(missing_var_names))
    
    model_fit <- gamem(test_data,
                       gen     = genotype, 
                       rep     = rep, 
                       resp    = everything(), 
                       verbose = FALSE)
    
    return(model_fit)
  }
  
  # Apply the function to each list element of the df argument (each test)
  df %<>%
    mutate(fit_model = map(data, blup_model), 
           blue_g    = map(fit_model, function(x) get_model_data(x, "blupg")))
  
  # And return the list of fit models
  return(df)
}
