# covid-nyc-2022-group-1

### Getting the ACS Data

- Data for each zipcode was taken from the American Community Survey (ACS) API. You will need to set up an API Census key (signup [here](https://api.census.gov/data/key_signup.html)). 
- Use the `01_Figure_1.Rmd` file to generate your data tables. Provide your personal ACS key in the commented out `census_api_key` parenthesis (in place of the key that is there). 
- `01_Figure_1.Rmd` will generate two `.RData` files which can then be used for faster loading of the data for further analysis. 