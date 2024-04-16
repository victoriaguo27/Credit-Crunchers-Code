# Load the dplyr package
library(dplyr)

set.seed(4996)

# Read the CSV file into a data frame
final_data <- read.csv("final_data.csv")

# Select the desired columns
final_data <- final_data %>%
  select(
    state_abbr, as_of_year, agency_abbr, loan_type_name, property_type_name,
    loan_purpose_name, owner_occupancy_name, loan_amount_000s,
    preapproval_name, action_taken_name, applicant_ethnicity_name,
    co_applicant_ethnicity_name, applicant_race_name_1,
    co_applicant_race_name_1, applicant_sex_name, co_applicant_sex_name,
    applicant_income_000s, purchaser_type_name, hud_median_family_income,
    hoepa_status_name, census_tract_number
  )

# Remove rows with NA values
final_data <- na.omit(final_data)

# exploring the variable types 
variable_types <- sapply(final_data, class)
print(variable_types)

# converting all the character variables to factor variables
# Specify the character variables to be converted to factors
char_vars_to_convert <- c(
  "property_type_name", "applicant_ethnicity_name", 
  "co_applicant_race_name_1", "hoepa_status_name", 
  "agency_abbr", "loan_purpose_name", "preapproval_name", 
  "co_applicant_ethnicity_name", "applicant_sex_name", 
  "purchaser_type_name", "loan_type_name", "owner_occupancy_name", 
  "action_taken_name", "applicant_race_name_1", "co_applicant_sex_name"
)

# Convert specified character variables to factors
final_data <- final_data %>%
  mutate_at(vars(char_vars_to_convert), as.factor)

# exploring levels for the response variable (action_taken_name)
levels(final_data$action_taken_name) # It has 6 levels - I am reducing it to 2 for simplicity

# Right now, it has the following 6 levels - "Application approved but not accepted", "Application denied by financial institution",
# "Application withdrawn by applicant", "File closed for incompleteness", "Loan originated", 
# "Loan purchased by the institution"

# Firstly, I am removing all the rows where action_taken_name is "Application withdrawn by applicant", 
# "File closed for incompleteness",  and "Loan purchased by the institution" since these aren't relevant to
# our research question

# Define the levels to exclude
levels_to_exclude <- c(
  "Application withdrawn by applicant",
  "File closed for incompleteness",
  "Loan purchased by the institution"
)

# Remove rows with specified levels in action_taken_name
final_data <- final_data %>%
  filter(!(action_taken_name %in% levels_to_exclude))

# Now, wherever "action_taken_name" is "Application approved but not accepted" and "Loan originated", I want to
# convert it to "Loan originated", and wherever "action_taken_name" is "Application denied by financial institution",
# I want to make it "Loan denied"

final_data <- final_data %>%
  mutate(
    action_taken_name = case_when(
      action_taken_name %in% c("Application approved but not accepted", "Loan originated") ~ "Loan originated",
      action_taken_name %in% c("Application denied by financial institution", "Preapproval request denied by financial institution") ~ "Loan denied",
      TRUE ~ action_taken_name
    ) )
   # Now, action_taken_name is a binary response variable

# Converting  action_taken_name to a factor variable
final_data$action_taken_name <- as.factor(final_data$action_taken_name)

# Ensuring that final_data is a binary response variable
levels(final_data$action_taken_name)

# Stratified sampling to ensure balance with 25,000 observations for "Loan denied" and 170 observations for "Loan originated"
final_data_approved <- final_data %>%
  filter(action_taken_name == "Loan originated") %>%
  sample_n(size = 25000, replace = TRUE)

# Sample 25,000 observations for "Loan denied"
final_data_denied <- final_data %>%
  filter(action_taken_name == "Loan denied") %>%
  sample_n(size = 25000, replace = TRUE)

# Combine the two samples
final_data <- bind_rows(final_data_approved, final_data_denied)
summary(final_data)

# Arranging as_of_year column in ascending order
final_data <- final_data %>%
  arrange(as_of_year)

final_data <- final_data %>%
  mutate(period = case_when(
    as_of_year >= 2007 & as_of_year <= 2009 ~ "Recession",
    as_of_year >= 2009 & as_of_year <= 2012 ~ "Recovery"
  ))

# Saving the csv file
write.csv(final_data, "C:/Users/harte/Desktop/STAT 4996/Data/final_data_HMDA.csv", row.names = FALSE)
