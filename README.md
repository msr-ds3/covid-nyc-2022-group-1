# covid-nyc-2022-group-1

### Getting the ACS Data

- Data for each zipcode was taken from the American Community Survey (ACS) API. You will need to set up an API Census key (signup [here](https://api.census.gov/data/key_signup.html)). 
- Use `01_download_nyc_zip_codes.sh` to download the NYC zipcodes csv to a Data subfolder. 
- Use `02_download_april_1_cases.sh` to download the data for the April 1, 2020 COVID cases by zipcode. 
- Use `03_get_acs_data.R` to get the ACS census data from the ACS API. You will need to replace the existing API key with your own API Census key in the commented out `api_census_key`. You may need to `install.packages("sf")` if you get an error for geometry. 
- `03_get_acs_data.R` will generate a `.RData` file for easy loading of the data for further analysis. 

### Generating the Final Report

- Use `04_Group_1_Final_Report.Rmd` to generate the final report with the maps and regressions. 

