#options(repos = c(CRAN = "https://cloud.r-project.org"))

# Install libraries if not already installed
#install.packages("readr")
#install.packages("dplyr")
#install.packages("tidyverse")

# Load necessary libraries
library(readr)
library(dplyr)
library(tidyverse)

# --- 1. Lectura de Datos ---
# Define la ruta base y los nombres de los contaminantes
data_path <- "test1_data"
#pollutants <- c("o3", "co")
pollutants <- c("co", "no", "no2", "o3", "so2")

# Lee todos los archivos CSV en una lista nombrada de data frames
data_list <- pollutants %>%
  set_names() %>% # Nombra los elementos de la lista con los nombres de los contaminantes
  map(~ read_csv(file.path(data_path, paste0("data_", .x, ".csv")), show_col_types = FALSE))

# --- 2. Procesamiento y Escritura de Datos ---

# Create a directory for the subsets if it doesn't exist
if (!dir.exists("subsets")) {
  dir.create("subsets")
}

# Función que agrupa, divide y escribe los subconjuntos para un data frame
process_and_write <- function(df, pollutant_name) {
  
  # Convierte las columnas a factores
  df <- df %>% mutate(across(c(vg, conex), as.factor))
  
  # group_split() divide el data frame en una lista de tibbles por grupo
  subsets <- df %>%
    group_by(vg, conex, .drop = FALSE) %>%
    group_split()
    
  # Itera sobre cada subconjunto (tibble)
  for (subset_df in subsets) {
    if (nrow(subset_df) == 0) next
    
    # Obtiene los niveles de 'vg' y 'conex' de la primera fila del subconjunto
    vg_level <- subset_df$vg[1]
    conex_level <- subset_df$conex[1]
    
    # Convierte los niveles a texto para el nombre del archivo, manejando NAs
    vg_level_char <- if (is.na(vg_level)) "NA" else as.character(vg_level)
    conex_level_char <- if (is.na(conex_level)) "NA" else as.character(conex_level)
    
    # Limpia los nombres para que sean válidos en nombres de archivo
    vg_level_sanitized <- gsub("[^a-zA-Z0-9_.-]", "-", vg_level_char)
    conex_level_sanitized <- gsub("[^a-zA-Z0-9_.-]", "-", conex_level_char)
    
    file_name <- paste0("subsets/data_", pollutant_name, "_vg_", vg_level_sanitized, "_conex_", conex_level_sanitized, ".csv")
    write.csv(subset_df, file_name, row.names = FALSE)
  }
}

# Aplica la función a cada data frame de la lista de contaminantes
map2(data_list, names(data_list), process_and_write)

print("Proceso completado. Los subconjuntos han sido guardados en la carpeta 'subsets'.")
