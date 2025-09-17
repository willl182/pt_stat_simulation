# options(repos = c(CRAN = "https://cloud.r-project.org"))

# Install and load the 'boot' package if not already installed
# if (!requireNamespace("boot", quietly = TRUE)) {
  # install.packages("boot")}

library(boot)

# --- User Data ---
data_SRP_0<-c(0, -0.1, -0.3, -0.1, 0, -0.1, -0.1, 0, -0.2, 0, 0.2, -0.1, 0, 0.1, 0, -0.1, -0.2, -0.1, -0.2, 0, 0, 0, -0.1, -0.2, -0.2, -0.1, -0.2, 0, 0, -0.1, 0, -0.1, 0, 0, -0.2, -0.1)
data_SRP_45<-c(45, 46.8, 44.5, 47.4, 47.9, 46.5, 46.6, 46.4, 43.9, 47.3, 44.9, 46.7, 45.9, 46.4, 46.2, 47, 47.3, 45.7, 46.9, 47, 46.6, 46.8, 47.8, 45, 46.6, 47.3, 46.5, 47.7, 48.2, 45.8, 47.3, 46, 47.6, 46.6, 47.5, 45.7)
data_SRP_90<-c(90, 93.1, 90.9, 94.5, 96.3, 93.3, 94.8, 92.8, 90.4, 94.1, 92.7, 93.3, 93.5, 93.3, 93.7, 93.5, 95.4, 92.6, 95.2, 94.4, 93.7, 93.2, 95.5, 91.7, 94.7, 94.6, 93.3, 94.4, 96, 92.5, 95.3, 92.6, 94.4, 94.2, 94.4, 93)
data_SRP_135<-c(135, 137.5, 133.3, 127.8, 138.3, 125.8, 136, 137.1, 131.3, 127.2, 133.8, 125.7, 134.2, 137.1, 136.7, 129.6, 136.7, 128.2, 127.8, 138.8, 125.4, 128.6, 136.8, 126.9, 136.1, 127.7, 124.9, 131.2, 138, 128, 136.7, 124.3, 131.2, 135.4, 130.6, 133.9)
data_SRP_180<-c(180, 181.6, 176.2, 184.7, 185.4, 182.4, 182.7, 180.3, 174.5, 183.9, 180.6, 182.1, 180.5, 180.4, 180.1, 183, 184, 180.7, 185.3, 183, 180.9, 181.6, 183.8, 179.3, 182.9, 184.5, 180.4, 185.4, 185.1, 180.3, 184.2, 179.3, 185, 182, 184.3, 180.6)
data_SRP_02<-c(0, -0.4, -0.1, -0.2, -0.1, 0.1, 0, -0.1, -0.1, 0.1, 0.1, 0, -0.1, -0.1, -0.2, 0, -0.1, 0.1, 0, 0, -0.1, 0, 0, 0, 0.1, -0.2, -0.1, 0, 0.1, 0, 0, -0.1, -0.1, 0.1, 0, 0)

data_59756_324_0<-c(0, 0, -0.1, -0.2, -0.3, -0.3, 0.1, -0.3, -0.3, -0.2, 0, -0.3, -0.1, -0.2, 0, -0.1, -0.2, -0.2, -0.1, 0, -0.3, -0.2, -0.1, 0, -0.1, 0, -0.1, 0, -0.3, -0.2, -0.1, -0.3, -0.2, 0.1, -0.1, -0.2)
data_59756_324_45<-c(45, 46.5, 44.8, 47.5, 47.7, 46.5, 46.6, 46.6, 43.8, 47.1, 44.5, 46.5, 45.7, 46.2, 46.1, 46.7, 47, 45.4, 46.8, 47.1, 46.6, 46.8, 47.7, 44.9, 46.7, 47.6, 46.5, 47.6, 48.2, 45.8, 47.2, 46.4, 47.6, 46.7, 47.4, 45.8)
data_59756_324_90<-c(90, 93, 91.3, 94.2, 96.2, 93.2, 94.8, 93, 90.6, 93.8, 92.5, 93.1, 93.5, 93.5, 94, 93.2, 95.3, 92.4, 95.1, 94.5, 94, 92.8, 95.3, 91.7, 94.9, 95, 93.4, 94.3, 95.9, 92.4, 95.3, 93.3, 94.1, 94.1, 94.2, 93.1)
data_59756_324_135<-c(135, 137.9, 133.6, 127.5, 138.1, 125.7, 136.1, 137.4, 132.1, 126.8, 133.7, 125.5, 134.2, 137.5, 137.1, 129.1, 136.7, 128.1, 127.6, 138.9, 125.7, 128.5, 136.8, 126.9, 136.1, 128, 125.7, 131, 137.8, 127.8, 136.9, 125, 130.7, 135.6, 130.7, 133.9)
data_59756_324_180<-c(180, 182, 177, 184.3, 185, 182.1, 182.8, 181.3, 175.7, 183.4, 180.6, 181.8, 180.6, 181, 181.2, 182.5, 184.1, 180.5, 185.5, 183.1, 181.8, 181.3, 183.7, 179, 183.4, 184.7, 181.6, 185.3, 184.9, 180.4, 184.4, 180.4, 184.8, 181.9, 184.2, 180.7)
data_59756_324_02<-c(0, -0.3, -0.1, 0.1, -0.3, 0, -0.1, -0.2, 0, -0.1, -0.1, -0.1, -0.1, -0.1, -0.2, 0.1, -0.3, -0.3, -0.2, -0.2, -0.3, -0.2, -0.1, -0.2, -0.2, -0.2, -0.2, -0.2, -0.1, 0, -0.1, -0.2, 0, -0.3, -0.2, -0.2)

# List of data levels to process


data_levels <- list(data_SRP_0 = data_SRP_0,
                    data_SRP_45 = data_SRP_45,
                    data_SRP_90 = data_SRP_90,
                    data_SRP_135 = data_SRP_135,
                    data_SRP_180 = data_SRP_180,
                    data_SRP_02 = data_SRP_02,
                    data_59756_324_0 = data_59756_324_0,
                    data_59756_324_45 = data_59756_324_45,
                    data_59756_324_90 = data_59756_324_90,
                    data_59756_324_135 = data_59756_324_135,
                    data_59756_324_180 = data_59756_324_180,
                    data_59756_324_02 = data_59756_324_02
)

# --- Bootstrap Simulation ---

# Define the statistic to bootstrap (the mean)
mean_statistic <- function(data, indices) {
  # Access the column by name after resampling to avoid issues with R dropping
  # dimensions and converting a single-column data frame to a vector.
  return(mean(data[indices, "value"], na.rm = TRUE))
}

# Create a directory for the bootstrap results if it doesn't exist
if (!dir.exists("srp_bootstrap_results")) {
  dir.create("srp_bootstrap_results")
}

# Create an empty data frame to store the confidence intervals
ci_results <- data.frame()

# Set the seed for reproducibility
set.seed(945)

# Loop through each data level
for (level_name in names(data_levels)) {
  
  # Get the numeric vector for the current level
  values <- data_levels[[level_name]]
  
  # Create a data frame
  data <- data.frame(value = as.numeric(values))
  
  # Check if data is empty
  if (nrow(data) == 0 || all(is.na(data$value))) {
    print(paste("Skipping empty or invalid data for:", level_name))
    next
  }
  
  print(paste("Processing data for:", level_name))
  
  # Loop 30 times for each data level
  for (i in 1:30) {
    print(paste("  Run", i, "of 30"))
    
    # Perform the bootstrap simulation with 10000 iterations
    bootstrap_results <- boot(data = data, statistic = mean_statistic, R = 10000)
    
    # Get the bootstrapped means
    bootstrapped_means <- bootstrap_results$t
    
    # Calculate the mean of the bootstrapped samples
    boot_mean_value <- mean(bootstrapped_means, na.rm = TRUE)
    
    # Write the bootstrapped means to a CSV file for each run
    file_name <- paste0("srp_bootstrap_results/bootstrap_means_", level_name, "_run_", i, ".csv")
    write.csv(bootstrapped_means, file_name, row.names = FALSE)
    
    print(paste("    Bootstrapped means saved to", file_name))
    
    # Calculate and store the confidence interval
    ci <- tryCatch({
      boot.ci(bootstrap_results, type = "bca")
    }, error = function(e) {
      print(paste("      Could not calculate CI for", level_name, "run", i, ":", e$message))
      return(NULL)
    })
    
    if (!is.null(ci)) {
        # Add the results to the data frame
        ci_results <- rbind(ci_results, data.frame(
          level = level_name,
          run = i,
          original_mean = bootstrap_results$t0,
          boot_mean = boot_mean_value,
          ci_level = ci$bca[1],
          ci_lower = ci$bca[4],
          ci_upper = ci$bca[5]
        ))
    } else {
        ci_results <- rbind(ci_results, data.frame(
          level = level_name,
          run = i,
          original_mean = bootstrap_results$t0,
          boot_mean = boot_mean_value,
          ci_level = 0.95, # Assuming 95%
          ci_lower = NA,
          ci_upper = NA
        ))
    }
  }
}

# Write the confidence interval results to a CSV file
write.csv(ci_results, "srp_bootstrap_summary.csv", row.names = FALSE)

print("Bootstrap simulation complete. Results saved to 'srp_bootstrap_results' directory and 'srp_bootstrap_summary.csv'.")
