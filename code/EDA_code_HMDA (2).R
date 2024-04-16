# Load the dplyr package
library(dplyr)
library(tidyverse)

set.seed(4996)

# Read the CSV file into a data frame
final_data_HMDA <- read.csv("final_data_HMDA.csv")

# Converting the character variables to factor variables
char_vars_to_convert <- c(
  "property_type_name", "applicant_ethnicity_name", 
  "co_applicant_race_name_1", "hoepa_status_name", 
  "agency_abbr", "loan_purpose_name", "preapproval_name", 
  "co_applicant_ethnicity_name", "applicant_sex_name", 
  "purchaser_type_name", "loan_type_name", "owner_occupancy_name", 
  "action_taken_name", "applicant_race_name_1", "co_applicant_sex_name", "period", "state_abbr"
)

# Convert specified character variables to factors
final_data_HMDA <- final_data_HMDA %>%
  mutate_at(vars(char_vars_to_convert), as.factor)

# EDA 1 - summary table
summary(final_data_HMDA) # action_taken_name is unbalanced with 117 (Loan Denied Observations) and 383 (Loan Originated Observations)

# EDA 2 - Exploring Relationship between categorical and numerical variables 

# i) Boxplot between action_taken_name and loan_amount_000s
ggplot(final_data_HMDA, aes(x = action_taken_name, y = loan_amount_000s)) +
  geom_boxplot() +
  labs(title = "Loan Approval Status and Loan Amount Obtained", x = "Loan Approval Status", y = "Loan Amount Obtained") +
  theme_minimal()

# No visible difference

# ii) Boxplot between action_taken_name and applicant_income_000s
ggplot(final_data_HMDA, aes(x = action_taken_name, y = applicant_income_000s)) +
  geom_boxplot() +
  labs(title = "Loan Approval Status and Applicant's income (in $000s)", x = "Loan Approval Status", y = "Applicant's Income (000s)") +
  theme_minimal()

# no visible difference

# *iii) Boxplot between action_taken_name and hud_median_family_income (med. income for the MSA/MD)
ggplot(final_data_HMDA, aes(x = action_taken_name, y = hud_median_family_income)) +
  geom_boxplot() +
  labs(title = "Loan Approval Status and Median Family Income for the MSA/MD", x = "Loan Approval Status", y = "Median Family Income") +
  theme_minimal()

# *for loans approved, median of median family income in a MSA/MD in which the loan was applied for 
# is higher as compared to when the loan was denied (could be significant)

# EDA 3 - Exploring Relationship between 2 categorical variables

# i) Bar plot between action_taken_name and period (i.e., Recession or Recovery period)
ggplot(final_data_HMDA, aes(x = action_taken_name, fill = period)) +
  geom_bar(position = "dodge") +
  labs(title = "Loan Approval Status and Period", x = "", y = "Frequency") +
  theme_minimal()

# * more loans were denied during the recession than recovery (seems significant)

# ii) Bar plot between action_taken_name and applicant_sex_name

final_data_HMDA <- final_data_HMDA %>%
  mutate(applicant_sex_name = recode(applicant_sex_name, "Information not provided by applicant in mail, Internet, or telephone application" = "No Information"))

ggplot(final_data_HMDA, aes(x = action_taken_name, fill = applicant_sex_name)) +
  geom_bar(position = "dodge") +
  labs(title = "Loan Approval Status and Gender", x = "", y = "Frequency") +
  theme_minimal()

# we can see that more loans were approved for men and more denied for women

# iii) Bar plot between action_taken_name and applicant_race_name_1
final_data_HMDA <- final_data_HMDA %>%
  mutate(applicant_race_name_1 = recode(applicant_race_name_1, "Information not provided by applicant in mail, Internet, or telephone application" = "No Information"))

ggplot(final_data_HMDA, aes(x = action_taken_name, fill = applicant_race_name_1)) +
  geom_bar(position = "dodge") +
  labs(title = "Loan Approval Status and Race", x = "", y = "Frequency") +
  theme_minimal()

# can see that no. of loans originated for White is more than than # loans denied;
# whereas, # loans denied for Black or African Americans and American Indian or Alaska Native is higher than
# loans approved

# iv) Bar plot between action_taken_name and preapproval_name

ggplot(final_data_HMDA, aes(x = action_taken_name, fill = preapproval_name)) +
  geom_bar(position = "dodge") +
  labs(title = "Loan Approval Status and Preapproval status", x = "", y = "Frequency") +
  theme_minimal()

# can see that more loans were approved when the preapproval process wasn't requested (why??)

# v) Bar plot between action_taken_name and loan_purpose_name

ggplot(final_data_HMDA, aes(x = action_taken_name, fill = loan_purpose_name)) +
  geom_bar(position = "dodge") +
  labs(title = "Loan Approval Status and Loan Purpose", x = "", y = "Frequency") +
  theme_minimal()

# loans meant for home purchase have more approvals than denials; whereas, those meant
# for home improvement and refinancing have more denials than approvals

# vi) Bar plot between action_taken_name and loan_type_name

ggplot(final_data_HMDA, aes(x = action_taken_name, fill = loan_type_name)) +
  geom_bar(position = "dodge") +
  labs(title = "Loan Approval Status and Loan Type", x = "", y = "Frequency") +
  theme_minimal()

# can't really see any interesting trend - VA-guaranteed loan types have slightly more approvals than denials

# vii) Bar plot between action_taken_name and agency_abbr (regulatory agency)

ggplot(final_data_HMDA, aes(x = action_taken_name, fill = agency_abbr)) +
  geom_bar(position = "dodge") +
  labs(title = "Loan Approval Status and Regulatory Agency", x = "", y = "Frequency") +
  theme_minimal()

# Can't see any interesting trend??

# viii) Bar plot between action_taken_name and state_abbr

ggplot(final_data_HMDA, aes(x = action_taken_name, fill = state_abbr)) +
  geom_bar(position = "dodge") +
  labs(title = "Loan Approval Status and State", x = "", y = "Frequency") +
  theme_minimal()

# Can see that there's more financial activity in CA than VA

