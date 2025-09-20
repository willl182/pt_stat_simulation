# This script generates boxplots for each pollutant, showing concentration distributions.
# It facets the plots by 'vg' and uses 'conex' for the x-axis.

# Ensure tidyverse is installed and loaded for data manipulation and plotting
# if (!require("tidyverse")) {  install.packages("tidyverse")}
library(tidyverse)

# --- 1. Create Directory for Plots ---
# Create a directory for the output plots if it doesn't already exist
if (!dir.exists("plots")) {
  dir.create("plots")
}

# --- 2. Load Data ---
# Define the path to the data and the list of pollutants to process
data_path <- "test1_data"
pollutants <- c("co", "no", "no2", "o3", "so2")

# Read all the raw CSV files into a named list of data frames
data_list <- pollutants %>%
  set_names() %>%
  map(~ read_csv(file.path(data_path, paste0("data_", .x, ".csv")), show_col_types = FALSE))

# --- 3. Plotting Function ---
# A function to preprocess data and generate a boxplot for a single pollutant
create_boxplot <- function(df, pollutant_name) {
  
  # Standardize the concentration column name to 'concentration'
  # It's named 'c' in some files and 'conc' in others.
  if ("conc" %in% names(df)) {
    df <- df %>% rename(concentration = conc)
  } else if ("c" %in% names(df)) {
    df <- df %>% rename(concentration = c)
  } else {
    warning(paste("Skipping", pollutant_name, "- no 'conc' or 'c' column found."))
    return(NULL) # Skip if no concentration column
  }
  
  # Create the 'sanitized' columns for faceting and x-axis, matching analysis.R logic
  df_processed <- df %>%
    mutate(
      # Coerce to character and handle potential NAs
      vg_level_sanitized = if_else(is.na(vg), "NA", as.character(vg)),
      conex_level_sanitized = if_else(is.na(conex), "NA", as.character(conex)),
      # Sanitize for file-system-safe names (though here it's for plot labels)
      vg_level_sanitized = gsub("[^a-zA-Z0-9_.-]", "-", vg_level_sanitized)
    )
  
  # Generate the plot using ggplot2
  p <- ggplot(df_processed, aes(x = conex_level_sanitized, y = concentration)) +
    geom_boxplot() +
    facet_wrap(~ vg_level_sanitized, scales = "free_y") + # Facet by vg, allow y-axis to vary
    labs(
      title = paste("Concentration Boxplots for", toupper(pollutant_name)),
      subtitle = "Faceted by 'vg' group",
      x = "Conex Level",
      y = "Concentration"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Improve x-axis label readability
  
  # Save the plot to the 'plots' directory
  ggsave(paste0("plots/boxplots_", pollutant_name, ".png"), plot = p, width = 12, height = 8)
  
  print(paste("Generated plot for", pollutant_name))
}

# --- 4. Execution ---
# Apply the plotting function to each pollutant's data frame
map2(data_list, names(data_list), create_boxplot)

print("All plots have been generated and saved in the 'plots' folder.")