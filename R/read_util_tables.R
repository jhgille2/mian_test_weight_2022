#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param yield_check_genotypes
#' @param genotype_conversion
#' @param trait_conversion
#' @param trait_shortname_conversion
#' @param column_shortname_conversion
read_util_tables <- function(yield_check_genotypes, genotype_conversion,
                             trait_conversion, trait_shortname_conversion,
                             column_shortname_conversion, test_conversion) {

  # Read in each file and return the dataframes in a list
  parent_yield_checks <- read_excel(yield_check_genotypes, sheet = "checks_and_parents")
  yield_checks        <- read_excel(yield_check_genotypes, sheet = "yield_checks")
  genotype_conversion <- read_excel(genotype_conversion)
  trait_lookup        <- read_excel(trait_conversion)
  trait_shortnames    <- read_excel(trait_shortname_conversion)
  column_shortnames   <- read_excel(column_shortname_conversion)
  test_conversion     <- read_excel(test_conversion)
  
  res <- list("check_table"               = parent_yield_checks, 
              "yield_checks"              = yield_checks,
              "genotype_conversion_table" = genotype_conversion, 
              "trait_lookup"              = trait_lookup, 
              "trait_shortnames"          = trait_shortnames, 
              "column_shortnames"         = column_shortnames, 
              "test_conversion_table"     = test_conversion)
  
  return(res)

}
