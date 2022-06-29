## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(

  ## Section: Input files
  ##################################################
  
  # Leadsheet files for 2020 and 2021
  tar_target(leadsheet_files_2020,
             list.files(here("data", "leadsheets", "2020"), full.names = TRUE),
             format = "file"),

  tar_target(leadsheet_files_2021,
             list.files(here("data", "leadsheets", "2021"), full.names = TRUE),
             format = "file"),
  
  # Test weight data for 2020 and 2021
  tar_target(test_weight_files_2020, 
             here("data", "test_weight_data", "2020", "test_weight_2020.csv"), 
             format = "file"), 
  
  tar_target(test_weight_files_2021, 
             list.files(here("data", "test_weight_data", "2021"), full.names = TRUE), 
             format = "file"),
  
  # Yield data for 2020 and 2021
  tar_target(yield_file_2020, 
             here("data", "yield_data", "2020", "yield_2020.csv"), 
             format = "file"), 
  
  tar_target(yield_file_2021, 
             here("data", "yield_data", "2021", "yield_2021.csv"), 
             format = "file"),
  
  # The file for the "Jay" yield tests in 2020
  tar_target(jay_yield_file_2020, 
             here("data", "yield_data", "2020", "jay_yield_2020.csv"), 
             format = "file"), 
  
  # Check genotypes
  tar_target(yield_check_genotypes, 
             here("data", "utils", "check_genotypes.xlsx"), 
             format = "file"),
  
  # A table to convert between genotype names that are coded 
  # differently between years
  tar_target(genotype_conversion, 
             here("data", "utils", "genotype_name_conversion.xlsx"), 
             format = "file"), 
  
  # A table to convert short phenotype names to publication-ready names
  tar_target(trait_conversion, 
             here("data", "utils", "trait_name_lookup.xlsx"), 
             format = "file"),
  
  # A table to convert short phenotype names to longer names that don't 
  # have units included
  tar_target(trait_shortname_conversion, 
             here("data", "utils", "trait_shortname_lookup.xlsx"), 
             format = "file"),
  
  # A table to convert short column names in summary tables to longer, 
  # more descriptive names
  tar_target(column_shortname_conversion, 
             here("data", "utils", "summary_column_names.xlsx"), 
             format = "file"),
  
  ## Section: Data cleaning
  ##################################################
  
  # Read in the utility tables
  tar_target(util_tables, 
             read_util_tables(yield_check_genotypes, 
                              genotype_conversion, 
                              trait_conversion, 
                              trait_shortname_conversion, 
                              column_shortname_conversion)),
  
  # clean up the lead sheet files
  tar_target(leadsheet_data_2020,
             snfR::clean_lead_sheets(leadsheet_files_2020)),

  tar_target(leadsheet_data_2021,
             snfR::clean_lead_sheets(leadsheet_files_2021)),
  
  # Clean up the test weight data
  tar_target(test_weight_data_2020, 
             clean_test_weight_2020(files = test_weight_files_2020)), 
  
  tar_target(test_weight_data_2021, 
             clean_test_weight_2021(files = test_weight_files_2021)), 
  
  # Merge the test weight data from 2020 and 2021
  tar_target(merged_test_weight, 
             merge_test_weight(test_weight_data_2020, test_weight_data_2021)),
  
  # Merge the yield data from 2020 and 2021
  tar_target(merged_yield_data, 
             merge_yield_data(jay_yield_file_2020, yield_file_2020, yield_file_2021)),
  
  # Merge the yield data and the test weight data
  tar_target(full_data, 
             merge_yield_and_testweight(merged_test_weight, merged_yield_data, util_tables)),
  
  # Split the full data into two sets: 
  # 1. Breeding lines that have test weight data for both 2020 and 2021 
  # 2. Breeding lines that only have test weight data for one year
  tar_target(split_data, 
             split_full_data(full_data)),
  
  ## Section: Analysis
  ##################################################
  
  # EDA (histograms, boxplots, summary stat tables, more?)
  
  # 1. Phenotype correlations (table + plot?)
  
  # 2. Histograms for each phenotype
  
  # 3. Test weight by location plots (maybe a heatmap or barplots with avg values)
  
  
  
  
  # Model fitting
  
  # The blups for 2021
  tar_target(blups_2021, 
             fit_mixed_models(df = split_data$data_2021)),
  
  # The blups for 2020
  tar_target(blups_2020, 
             fit_mixed_models(df = split_data$data_2021)),
  
  # Heritablility
  
  # Model summary stats
  
  # ANOVA data for table
  
  # Publication-ready ANOVA summary tables
  
  # Contrasts (breeding lines vs check cultivars)
  
  ## Section: Exports
  ##################################################
  
  # The merged test weight data
  tar_target(test_weight_export, 
             export_test_weight(merged_test_weight, export = here("exports", "data", "merged_test_weight.csv")),
             format = "file")
  

)
