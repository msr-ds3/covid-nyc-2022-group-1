library(tidycensus)
library(tigris, options(tigris_use_cache = TRUE))
library(sf)
library(tidyverse)
library(dplyr)

# Uncomment below and run if get_acs() gives a geometry error
# install.packagaes("sf") 

# Getting the ACS data

# Insert your own census API key below
# census_api_key("9f57d911433df5106be7bad43607b75e36794f44", install = TRUE)

readRenviron("~/.Renviron")

# Figuring out the Variables

# Insurance
# load_variables(2016, "acs5") %>% filter(grepl("B27010", name)) %>% View()

# Median Income
# load_variables(2016, "acs5") %>% filter(grepl("B19013", name)) %>% View()

# Race
# load_variables(2016, "acs5") %>% filter(grepl("B02001", name)) %>% View()

# Households
# load_variables(2016, "acs5") %>% filter(grepl("B11016", name)) %>% View()

# Commuters
# load_variables(2016, "acs5") %>% filter(grepl("B08301", name)) %>% View()

# Age
# load_variables(2016, "acs5") %>% filter(grepl("B01001", name)) %>% View()

zipcodes <- read_csv("Data/nyc-zip-codes.csv") %>%
  mutate(GEOID = as.character(ZipCode))

master <- get_acs(geography = "zcta",
                  variables = c(total_18to34 = "B27010_018",
                                uninsured_18to34 = "B27010_033",
                                total_35to64 = "B27010_034",
                                uninsured_35to64 = "B27010_050",
                                median_income = "B19013_001",
                                total_race = "B02001_001",
                                identify_white = "B02001_002",
                                total_household = "B11016_001",
                                fam_four_household = "B11016_005",
                                fam_five_household = "B11016_006",
                                fam_six_household = "B11016_007",
                                fam_seven_plus_household = "B11016_008",
                                nonfam_four_household = "B11016_013",
                                nonfam_five_household = "B11016_014",
                                nonfam_six_household = "B11016_015",
                                nonfam_seven_plus_household = "B11016_016",
                                total_transport = "B08301_001",
                                total_public = "B08301_010",
                                bus = "B08301_011",
                                total_age = "B01001_001",
                                male_65to66 = "B01001_020",
                                male_67to69 = "B01001_021",
                                male_70to74 = "B01001_022",
                                male_75to79 = "B01001_023",
                                male_80to84 = "B01001_024",
                                male_85plus = "B01001_025",
                                female_65to66 = "B01001_044",
                                female_67to69 = "B01001_045",
                                female_70to74 = "B01001_046",
                                female_75to79 = "B01001_047",
                                female_80to84 = "B01001_048",
                                female_85plus = "B01001_049"),
                  state = "NY",
                  year = 2016,
                  geometry = TRUE) %>%
  inner_join(zipcodes, on = "GEOID") %>%
  transmute(GEOID, Borough, NAME, variable, estimate)

# Save the ACS data into a .RData for easier faster loading later on 

save(master, file = 'Data/master.RData')
