# This script reads the long-format subsample CSV files,
# transforms them into a wide format, and saves them as new CSV files.
# In the wide format, each row corresponds to a source file, and each
# subsample is in its own column.

# Load necessary libraries
# install.packages("tidyverse")
library(tidyverse)

# --- Configuration ---

# Define input and output file names
files_to_transform <- list(
  srp = list(
    long = "srp_subsamples.csv",
    wide = "srp_subsamples_wide.csv"
  ),
  bootstrap = list(
    long = "bootstrap_subsamples.csv",
    wide = "bootstrap_subsamples_wide.csv"
  )
)

# --- Transformation Function ---

transform_to_wide <- function(input_file, output_file) {
  # Read the long-format CSV file
  wide_data <- read_csv(input_file, show_col_types = FALSE) %>%
    # Use case_when to handle different filename structures
    mutate(
      group = case_when(
        str_detect(source_file, "_SRP_") ~ "SRP",
        str_detect(source_file, "_59756_324_") ~ "59756_324",
        TRUE ~ str_extract(source_file, "(?<=bootstrap_data_)[^_]+(?=_)")
      ),
      level = case_when(
        str_detect(source_file, "_SRP_|_59756_324_") ~ str_extract(source_file, "(?<=_324_|_SRP_)[^_]+(?=_run)"),
        TRUE ~ str_extract(source_file, "(?<=vg_).*(?=_conex)")
      )
    ) %>%
    # Group by the source file, create a unique ID for each subsample,
    # and then pivot the data to a wide format.
    group_by(source_file, group, level) %>%
    mutate(sample_id = paste0("sample_", row_number())) %>%
    ungroup() %>%
    pivot_wider(names_from = sample_id, values_from = subsample) %>% 
    relocate(group, level, .after = source_file) # Move new columns to the front
  
  # --- Split data by group and write to separate files ---
  
  # Get the base name for the output files (e.g., "srp_subsamples_wide")
  output_base_name <- tools::file_path_sans_ext(output_file)
  
  # Split the data frame by the 'group' column and write each part to a CSV
  wide_data %>%
    group_by(group) %>%
    group_walk(~ write_csv(.x, paste0(output_base_name, "_", .y$group, ".csv")))
  
  print(paste("Transformed", input_file, "and saved into separate files by group."))
}

# --- Execute Transformation ---

# Apply the function to both sets of files
walk(files_to_transform, ~transform_to_wide(.x$long, .x$wide))

print("All transformations complete.")