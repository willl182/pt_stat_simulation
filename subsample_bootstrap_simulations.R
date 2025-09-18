# This script reads all the individual bootstrap simulation files from a directory,
# takes a small, random subsample from each, and combines them into a single output file.

# Load necessary libraries
# install.packages("tidyverse")
# install.packages("fs")
library(tidyverse)
library(fs)

# --- Configuration ---

# 1. Define the directory containing the simulation files.
sim_results_dir <- "bootstrap_results"

# 2. Define the name for the final output file.
output_file <- "bootstrap_subsamples.csv"

# 3. Define how many values to sample from each simulation file.
sample_size <- 20

# --- Subsampling Process ---

# Get a list of all simulation CSV files in the specified directory
file_paths <- dir_ls(sim_results_dir, glob = "*.csv")

# Define a function to read one file, take a sample, and return it in a tidy format
subsample_file <- function(file_path) {
  # Read the simulation data. The column is named "V1" in the bootstrap_results files.
  sim_data <- read_csv(file_path, show_col_types = FALSE)
  
  # Take a random sample of size `sample_size`
  subsample_values <- sample(sim_data$V1, size = sample_size, replace = FALSE)
  
  # Return a tibble with the source file name and the subsampled values
  tibble(
    source_file = basename(file_path),
    subsample = subsample_values
  )
}

# Apply the function to all file paths and combine the results into a single data frame
all_subsamples <- map_dfr(file_paths, subsample_file)

# Save the combined subsamples to a new CSV file
write_csv(all_subsamples, output_file)

print(paste("Subsampling complete. All", nrow(all_subsamples), "subsamples saved to", output_file))