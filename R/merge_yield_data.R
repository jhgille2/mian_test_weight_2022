#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param yield_file_2020
#' @param yield_file_2021
merge_yield_data <- function(jay_yield_file_2020, yield_file_2020, yield_file_2021) {

  # Read in the yield files for 2020 and 2021 and select just the identification 
  # columns and the phenotype columns we'll use in the analysis
  yld_2020 <- read_csv(yield_file_2020) %>% 
    select(test, loc, year, genotype, rep,
           md, lod, ht, yield, sdwt, sq, oil_dry_basis, protein_dry_basis)
  
  jay_yld_2020 <- read_csv(jay_yield_file_2020) %>% 
    select(test, loc, year, genotype, rep,
           md, lod, ht, yield, sdwt, sq, oil_dry_basis, protein_dry_basis)
  
  yld_2021 <- read_csv(yield_file_2021) %>% 
    select(test, loc, year, genotype, rep,
           md, lod, ht, yield, sdwt, sq, oil_dry_basis, protein_dry_basis)
  
  # Combine the two data sets and set the column types so that they match
  # the types used in the test weight data so that the two dataframes can be
  # joined in another step
  yld_all <- bind_rows(yld_2020, yld_2021) %>% 
    bind_rows(jay_yld_2020) %>%
    mutate(rep = as.character(rep))
  
  # Return this combined dataframe
  return(yld_all)
}
