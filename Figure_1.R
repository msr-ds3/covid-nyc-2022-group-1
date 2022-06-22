library(tidycensus)
library(tigris)
library(sf)
library(tidyverse)

# install.packages("sf")

options(tigris_use_cache = TRUE)

# Getting the ACS data 

census_api_key("9f57d911433df5106be7bad43607b75e36794f44", install = TRUE)

readRenviron("~/.Renviron")

# 18-64 year olds uninsured

# load_variables(2016, "acs5") %>% filter(grepl("B27010", name)) %>% View()

insurance <- get_acs(geography = "tract",
                     variables = c("B27010_018", "B27010_033", "B27010_034", "B27010_050"),
                     state = "NY",
                     year = 2016,
                     geometry = TRUE) %>%
  filter(grepl("Bronx", NAME) | grepl("Kings", NAME) | grepl("Queens", NAME) | grepl("New York County", NAME) | grepl("Richmond", NAME))
  
uninsured_18to64 <- insurance %>% 
  transmute(GEOID, NAME, variable, estimate) %>%
  pivot_wider(names_from = variable, values_from = estimate) %>%
  transmute(GEOID, NAME, geometry, total = B27010_018 + B27010_034, uninsured = B27010_033 + B27010_050) %>% 
  mutate(prop = uninsured / total) %>%
  transmute(GEOID, NAME, total, uninsured, prop, geometry)

median(uninsured_18to64$prop, na.rm = TRUE)

ggplot(uninsured_18to64, aes(fill = prop)) + 
  geom_sf(aes(geometry = geometry)) + 
  labs(title = "Proportion of 18 to 64 year olds who are uninsured") +
  scale_fill_distiller(palette = "YlOrRd", 
                       direction = 1) +
  theme_void()

?geom_sf

# Another way of doing it 

insurance2 <- get_acs(geography = "tract",
                table = "B27010",
                state = "NY",
                year = 2016,
                geometry = TRUE) %>%
  filter(grepl("Bronx", NAME) | grepl("Kings", NAME) | grepl("Queens", NAME) | grepl("New York County", NAME) | grepl("Richmond", NAME))

total <- insurance2 %>%
  filter(variable %in% c("B27010_018", "B27010_034")) %>%
  group_by(GEOID, NAME) %>%
  summarize(total_estimate = sum(estimate))

uninsured <- insurance2 %>%
  filter(variable %in% c("B27010_033", "B27010_050")) %>%
  group_by(GEOID, NAME) %>%
  summarize(uninsured_estimate = sum(estimate))

proportion <- st_join(total, uninsured) %>%
  summarize(prop = uninsured_estimate / total_estimate)

plot(proportion["prop"]) 

# plot is not working

# Median Household Income

# load_variables(2016, "acs5") %>% filter(grepl("B19013", name)) %>% View()

income <- get_acs(geography = "tract",
                  variables = "B19013_001",
                  state = "NY",
                  year = 2016, 
                  geometry = TRUE) %>%
  filter(grepl("Bronx", NAME) | grepl("Kings", NAME) | grepl("Queens", NAME) | grepl("New York County", NAME) | grepl("Richmond", NAME))

mean(income$estimate, na.rm = TRUE)

plot(income["estimate"])

ggplot(income, aes(fill = estimate)) + 
  geom_sf(aes(geometry = geometry)) + 
  labs(title = "Median income") +
  scale_fill_distiller(palette = "YlGn", 
                       direction = 1) +
  theme_void()

# Identifying white

# load_variables(2016, "acs5") %>% filter(grepl("B02001", name)) %>% View()

white <- get_acs(geography = "tract",
                 variables = c("B02001_001", "B02001_002"),
                 state = "NY",
                 year = 2016,
                 geometry = TRUE) %>%
  filter(grepl("Bronx", NAME) | grepl("Kings", NAME) | grepl("Queens", NAME) | grepl("New York County", NAME) | grepl("Richmond", NAME))

white <- white %>% 
  transmute(GEOID, NAME, variable, estimate) %>%
  pivot_wider(names_from = variable, values_from = estimate) %>% 
  rename(total = B02001_001, white = B02001_002) %>%
  mutate(prop = white / total) 

mean(white$prop, na.rm = TRUE)

ggplot(white, aes(fill = prop)) + 
  geom_sf(aes(geometry = geometry)) + 
  labs(title = "Proportion of people who self-identify as white") +
  scale_fill_distiller(palette = "Purples", 
                       direction = 1) +
  theme_void()

# Proportion of households 4 or more

# load_variables(2016, "acs5") %>% filter(grepl("B11016", name)) %>% View()

household <- get_acs(geography = "tract",
                     variables = c("B11016_001", 
                                   "B11016_005", "B11016_006", "B11016_007", "B11016_008", 
                                   "B11016_013", "B11016_014", "B11016_015", "B11016_016"),
                     state = "NY",
                     year = 2016,
                     geometry = TRUE) %>%
  filter(grepl("Bronx", NAME) | grepl("Kings", NAME) | grepl("Queens", NAME) | grepl("New York County", NAME) | grepl("Richmond", NAME))

household <- household %>%
  transmute(GEOID, NAME, variable, estimate) %>%
  pivot_wider(names_from = variable, values_from = estimate) %>% 
  rename(total = B11016_001) %>%
  transmute(GEOID, NAME, geometry, total, four_plus = B11016_005 + B11016_006 + B11016_007 + B11016_008 +
            B11016_013 + B11016_014 + B11016_015 + B11016_016) %>%
  mutate(prop = four_plus / total)

mean(household$prop, na.rm = TRUE)

ggplot(household, aes(fill = prop)) + 
  geom_sf(aes(geometry = geometry)) + 
  labs(title = "Proportion in household of 4 or more") +
  scale_fill_distiller(palette = "YlOrRd", 
                       direction = 1) +
  theme_void()

# Proportion that commutes by bus

# load_variables(2016, "acs5") %>% filter(grepl("B08301", name)) %>% View()

bus <- get_acs(geography = "tract",
                     variables = c("B08301_010", "B08301_011"),
                     state = "NY",
                     year = 2016,
                     geometry = TRUE) %>%
  filter(grepl("Bronx", NAME) | grepl("Kings", NAME) | grepl("Queens", NAME) | grepl("New York County", NAME) | grepl("Richmond", NAME))

bus <- bus %>% 
  transmute(GEOID, NAME, variable, estimate) %>%
  pivot_wider(names_from = variable, values_from = estimate) %>% 
  rename(total = B08301_010, bus = B08301_011) %>%
  mutate(prop = bus / total) 

mean(bus$prop, na.rm = TRUE) # very low estimate compared to the article

ggplot(bus, aes(fill = prop)) + 
  geom_sf(aes(geometry = geometry)) + 
  labs(title = "Proportion of population that commuted by bus") +
  scale_fill_distiller(palette = "YlOrRd", 
                       direction = 1) +
  theme_void()

# Proportion 65 and older

# load_variables(2016, "acs5") %>% filter(grepl("B01001", name)) %>% View()

elderly <- get_acs(geography = "tract",
                     variables = c("B01001_001", 
                                   "B01001_020", "B01001_021", "B01001_022", "B01001_023", "B01001_024", "B01001_025",
                                   "B01001_044", "B01001_045", "B01001_046", "B01001_047", "B01001_048", "B01001_049"),
                     state = "NY",
                     year = 2016,
                     geometry = TRUE) %>%
  filter(grepl("Bronx", NAME) | grepl("Kings", NAME) | grepl("Queens", NAME) | grepl("New York County", NAME) | grepl("Richmond", NAME))

elderly <- elderly %>%
  transmute(GEOID, NAME, variable, estimate) %>%
  pivot_wider(names_from = variable, values_from = estimate) %>% 
  rename(total = B01001_001) %>%
  transmute(GEOID, NAME, geometry, total, sixtyfive_plus = B01001_020 + B01001_021 + B01001_022 + B01001_023 +
              B01001_024 + B01001_025 + B01001_044 + B01001_045 + B01001_046 + B01001_047 + B01001_048 + B01001_049) %>%
  mutate(prop = sixtyfive_plus / total)

mean(elderly$prop, na.rm = TRUE)

ggplot(elderly, aes(fill = prop)) + 
  geom_sf(aes(geometry = geometry)) + 
  labs(title = "Proportion of population 65+ years in age") +
  scale_fill_distiller(palette = "YlOrRd", 
                       direction = 1) +
  theme_void()

# While most of the estimations are close to those recorded in the article, they are not exactly the same
# and the mapping is not exactly the same (ggplot) bc we used "tract" instead of "zcta".
# We could not figure out how to use "zcta".
