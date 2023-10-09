library(tidyverse)
library(ggplot2)

# Step 1: Read in the file as lines
lines <- read_lines("suites_dw_Table1.txt")

# Step 2: Find the line number of the separator
separator_line <- which(str_detect(lines, "----+\\+----"))[1]

# Step 3: Extract and save the variable descriptions
var_descriptions <- lines[1:(separator_line - 2)]
write_lines(var_descriptions, "variable_descriptions.txt")


col_names_line <- separator_line - 1
col_names <- str_split(lines[col_names_line], "\\|")[[1]]
col_names <- str_trim(col_names)  # Trim white spaces

# Step 4: Find the start of the actual data
data_start <- which(str_trim(lines[(separator_line + 1):length(lines)]) != "")[1] + separator_line

# Extract the data lines and write to a temporary file
data_lines <- lines[data_start:length(lines)]
write_lines(data_lines, "temp_data.txt")

# Read in the data from the temporary file
galaxies <- read_delim("temp_data.txt", delim = "|", col_names = col_names, trim_ws = TRUE)

# Remove the temporary file
file.remove("temp_data.txt")

head(galaxies)


# Problem 3

# Reshape data to long format
long_data <- galaxies %>%
  select(a_26, log_lk, log_m26, log_mhi) %>%  # Select relevant columns
  gather(key = "variable", value = "value")   # Convert to long format

# Remove NA values
long_data <- long_data %>% filter(!is.na(value))

# Ensure 'value' column is treated as numeric
long_data$value <- as.numeric(as.character(long_data$value))

# Now you can try to plot again
ggplot(long_data, aes(x = value)) +
  geom_histogram(binwidth = 0.5, fill = "skyblue", color = "white", alpha = 0.7) +
  facet_wrap(~variable, scales = 'free_x') +
  labs(title = "Histograms of Galaxy Characteristics",
       x = "Value",
       y = "Frequency") +
  theme_minimal()


# Possible Expplanation:
# It might be due to the limitations in the observational techniques 
# and instruments used to collect the data 
# (smaller galaxies might be harder to detect, especially if they are farther away). 
# Alternatively, it might reflect a real characteristic of the volume of space being sampled 
# (perhaps it contains fewer small galaxies for some reason)



