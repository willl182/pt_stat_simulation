# Load the tidyverse library for data manipulation and string operations.
# install.packages("tidyverse") # Run this line if you don't have tidyverse installed
library(tidyverse)

# Define the input file path
input_file <- "srp_bootstrap_summary.csv"

# 1. Read the summary CSV file into a tibble
srp_summary <- read_csv(input_file, show_col_types = FALSE)

# 2. Process the data to create the new columns
srp_summary_processed <- srp_summary %>%
  mutate(
    # Create the 'instrument' column based on the content of the 'level' column
    instrument = case_when(
      str_detect(level, "SRP") ~ "SRP",
      str_detect(level, "59756_324") ~ "59756_324",
      TRUE ~ NA_character_ # Default to NA if no match is found
    ),
    
    # Extract the part of the string after the last underscore for the 'nominal' value
    # and convert the new column to a factor
    nominal = factor(str_extract(level, "(?<=_)[^_]+$"))
  )

# 3. Print the first few rows of the processed data to verify the changes
print("Head of the processed data frame:")
print(head(srp_summary_processed))

# 4. Save the processed data to a new CSV file
write_csv(srp_summary_processed, "srp_bootstrap_summary_processed.csv")
print("Processed data successfully saved to 'srp_bootstrap_summary_processed.csv'")

# 5. Create and save a plot

# Create a boxplot to visualize the distribution of boot_mean for each instrument,
# faceted by the nominal value. `scales = "free_y"` allows each facet to have
# its own y-axis range, which is crucial since the nominal values are very different.
srp_plot <- ggplot(srp_summary_processed, aes(x = instrument, y = boot_mean, fill = instrument)) +
  geom_boxplot() +
  # Add lineranges to show the 95% confidence interval for each of the 30 runs.
  # Use a low alpha for transparency to see the density of the intervals.
  #geom_linerange(aes(ymin = ci_lower, ymax = ci_upper), color = "darkgrey", alpha = 0.3, position = position_dodge(width = 0.75)) +
  # Re-plotting the boxplot on top to ensure it's not obscured by the lines.
  geom_boxplot(aes(fill = instrument), outlier.shape = NA) + # Hiding outliers from this layer to avoid duplication
  facet_wrap(~ nominal, scales = "free_y") +
  labs(
    title = "Distribution of Simulated Means by Instrument and Nominal Value",
    subtitle = "Boxplots show the distribution of 30 boot_means. Grey lines show the 95% CI for each run.",
    x = "Instrument",
    y = "Mean of Bootstrapped Samples"
  ) +
  theme_minimal()

# Save the plot to a file
ggsave("srp_summary_plot.png", plot = srp_plot, width = 10, height = 8)
print("Plot successfully saved to 'srp_summary_plot.png'")

# 6. Create an alternative plot to directly check for CI intersection

# First, create a summary data frame. For each instrument and nominal level,
# calculate the average of the boot_mean and the average CI limits from the 30 runs.
srp_ci_summary <- srp_summary_processed %>%
  group_by(instrument, nominal) %>%
  summarise(
    avg_boot_mean = mean(boot_mean, na.rm = TRUE),
    avg_ci_lower = mean(ci_lower, na.rm = TRUE),
    avg_ci_upper = mean(ci_upper, na.rm = TRUE),
    .groups = "drop"
  )

# Create a point-range plot to directly compare the average CIs
ci_intersection_plot <- ggplot(srp_ci_summary, aes(x = instrument, color = instrument)) +
  geom_pointrange(
    aes(y = avg_boot_mean, ymin = avg_ci_lower, ymax = avg_ci_upper),
    position = position_dodge(width = 0.3) # Dodge points to avoid overlap
  ) +
  facet_wrap(~ nominal, scales = "free_y") +
  labs(
    title = "Comparison of Average 95% Confidence Intervals by Instrument",
    subtitle = "Points are the average of 30 boot_means. Bars show the average CI range.",
    x = "Instrument",
    y = "Mean Value"
  ) +
  theme_minimal() +
  theme(legend.position = "none") # Color is redundant with x-axis

# Save the new plot
ggsave("srp_summary_ci_intersection_plot.png", plot = ci_intersection_plot, width = 10, height = 8)
print("CI intersection plot successfully saved to 'srp_summary_ci_intersection_plot.png'")