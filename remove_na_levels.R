# List of files to process
files_to_process <- c(
  "bsw_co.csv",
  "bsw_no.csv",
  "bsw_no2.csv",
  "bsw_o3.csv",
  "bsw_so2.csv"
)

# Loop through each file
for (file_path in files_to_process) {
  # Read the CSV file
  data <- read.csv(file_path, stringsAsFactors = FALSE)
  
  # Remove rows where the 'level' column is 'NA'
  filtered_data <- subset(data, level != "NA")
  
  # Overwrite the original CSV file
  write.csv(filtered_data, file_path, row.names = FALSE)
  
  cat("Processed", file_path, "
")
}

print("Finished processing all files.")
