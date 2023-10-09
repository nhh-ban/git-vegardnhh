library(tidyverse)

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


