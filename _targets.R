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
  
  ## Section: Data cleaning
  ##################################################
  
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
  
  ## Section: Analysis
  ##################################################
  
  # EDA (histograms, boxplots, summary stat tables, more?)
  
  # Model fitting
  
  # Model summary stats
  
  ## Section: Exports
  ##################################################
  
  # The merged test weight data
  tar_target(test_weight_export, 
             export_test_weight(merged_test_weight, export = here("exports", "data", "merged_test_weight.csv")),
             format = "file")
  

)
