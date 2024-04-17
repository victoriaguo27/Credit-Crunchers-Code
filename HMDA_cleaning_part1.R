library(tidyverse)

set.seed(4996)

## reading the HMDA data files for 2007-2012 for VA
data_2007_VA <- read.csv("hmda_2007_va_all-records_labels.csv", header = TRUE)
data_2008_VA <- read.csv("hmda_2008_va_all-records_labels.csv", header = TRUE)
data_2009_VA <- read.csv("hmda_2009_va_all-records_labels.csv", header = TRUE)
data_2010_VA <- read.csv("hmda_2010_va_all-records_labels.csv", header = TRUE)
data_2011_VA <- read.csv("hmda_2011_va_all-records_labels.csv", header = TRUE)
data_2012_VA <- read.csv("hmda_2012_va_all-records_labels.csv", header = TRUE)

data_2007_CA <- read.csv("hmda_2007_ca_all-records_labels.csv", header = TRUE)
data_2008_CA <- read.csv("hmda_2008_ca_all-records_labels.csv", header = TRUE)
data_2009_CA <- read.csv("hmda_2009_ca_all-records_labels.csv", header = TRUE)
data_2010_CA <- read.csv("hmda_2010_ca_all-records_labels.csv", header = TRUE)
data_2011_CA <- read.csv("hmda_2011_ca_all-records_labels.csv", header = TRUE)
data_2012_CA <- read.csv("hmda_2012_ca_all-records_labels.csv", header = TRUE)

# List of data frames
data_frames <- list(data_2007_VA, data_2008_VA, data_2009_VA, data_2010_VA, data_2011_VA, data_2012_VA,
                    data_2007_CA, data_2008_CA, data_2009_CA, data_2010_CA, data_2011_CA, data_2012_CA)

# I want to merge these data sets using the common column in all the data sets: as_of_year
merged_data <- bind_rows(data_frames, .id = "source")

# Then, I want to take a random sample of 500000 observations from this data set
sampled_data <- merged_data %>% 
  sample_n(500000, replace = FALSE)

# Write the merged data frame to a new CSV file
# You guys can change this line below depending on where you want to save it
write.csv(sampled_data, "C:/Users/harte/Desktop/STAT 4996/Data/final_data.csv", row.names = FALSE)

