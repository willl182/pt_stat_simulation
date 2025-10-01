# options(repos = c(CRAN = "https://cloud.r-project.org"))

# Install and load the 'boot' package if not already installed
# if (!requireNamespace("boot", quietly = TRUE)) {  install.packages("boot")}

library(boot)

# Get a list of all CSV files in the 'subsets' directory
file_list <- list.files(path = "subsets", pattern = "\\.csv$", full.names = TRUE)

# Filter the file list to include only o3 and co simulations
# file_list <- file_list[grepl("data_o3_|data_co_", basename(file_list))]

# Define the statistic to bootstrap (the mean of the 'conc' or 'c' column)
mean_statistic <- function(data, indices) {
  d <- data[indices, ]
  # Check if 'conc' column exists, otherwise use 'c'
  if ("conc" %in% names(d)) {
    return(mean(d$conc, na.rm = TRUE))
  } else {
    return(mean(d$c, na.rm = TRUE))
  }
}

# Create a directory for the bootstrap results if it doesn't exist
if (!dir.exists("bootstrap_results")) {
  dir.create("bootstrap_results")
}

# Create an empty data frame to store the confidence intervals
# Initialize a list to store results efficiently
results_list <- list()

# Loop through each file
for (file_path in file_list) {
  
  # Get the base name of the file without extension
  df_name <- tools::file_path_sans_ext(basename(file_path))
  
  # 1. Import the data
  data <- read.csv(file_path)
  
  # Clean the 'conc' or 'c' column
  if ("conc" %in% names(data)) {
    data$conc <- as.numeric(as.character(data$conc))
  } else {
    data$c <- as.numeric(as.character(data$c))
  }
  
  # Check if data is empty
  if (nrow(data) == 0) {
    print(paste("Skipping empty file:", file_path))
    next
  }
  
  print(paste("Processing file:", file_path))
  
  # Loop 10 times for each file
  for (i in 1:30) {
    # 3. Set the seed for reproducibility for each run
    set.seed(420 + i)
    
    # 4. Perform the bootstrap simulation with 10,000 iterations
    bootstrap_results <- boot(data = data, statistic = mean_statistic, R = 10000)
    
    # 5. Get the bootstrapped means
    bootstrapped_means <- bootstrap_results$t
    
    # Calculate the mean of the bootstrapped samples (the logic from mean.R)
    boot_mean_value <- mean(bootstrapped_means, na.rm = TRUE)
    
    # 6. Write the bootstrapped means to a CSV file
    file_name <- paste0("bootstrap_results/bootstrap_", df_name, "_run_", i, ".csv")
    write.csv(bootstrapped_means, file_name, row.names = FALSE)
    
    print(paste("  Run", i, "completed. Results saved to", file_name))
    
    # 7. Calculate and store the confidence interval
    ci <- tryCatch({
      boot.ci(bootstrap_results, type = "bca")
    }, error = function(e) {
      print(paste("    Could not calculate CI for", df_name, "run", i, ":", e$message))
      return(NULL)
    })
    
    if (!is.null(ci)) {
        # Add the results to the list
        results_list[[length(results_list) + 1]] <- data.frame(
          file_name = df_name,
          run = i,
          original_mean = bootstrap_results$t0, # Mean of the original data
          boot_mean = boot_mean_value,         # Mean of the 10,000 bootstrapped means
          ci_level = ci$bca[1],
          ci_lower = ci$bca[4],
          ci_upper = ci$bca[5]
        )
    } else {
        results_list[[length(results_list) + 1]] <- data.frame(
          file_name = df_name,
          run = i,
          original_mean = bootstrap_results$t0,
          boot_mean = boot_mean_value,
          ci_level = 0.95, # Assuming 95%
          ci_lower = NA,
          ci_upper = NA
        )
    } # End of if/else for CI calculation
  } # End of inner loop (for i in 1:30)
} # End of outer loop (for file_path in file_list)

# Combine the list of results into a single data frame
ci_results <- do.call(rbind, results_list)

# Write the summary results to a CSV file
write.csv(ci_results, "bootstrap_summary.csv", row.names = FALSE)

print("Bootstrap simulation complete. Results saved to bootstrap_summary.csv")
