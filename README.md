# covid-nyc-2022-group-1

### Preview

Based on the article, _Differential COVID-19 case positivity in New York City 
neighborhoods: Socioeconomic factors and mobility_ by Matthew Lamb, Sasikiran Kandula, and Jeffrey Shaman (2020). 

In the Figure 1 section, we created six maps to replicate the Figure 1 maps in the article. We used the ACS data to plot the proportion of 18-64 year olds who are uninsured (14%), the median income ($59,355), the proportion of the population self-identifying as white (48%), the proportion of the population in households of 4 or more (25%), the proportion of commuters who traveled by bus (10%), and the proportion of the population 65 and older (13%). 

In the Figure 2 section, we plotted the change in mobility in March and April, using February as a baseline. 

We then performed the individual regressions that were mentioned in the articles and we replicated the muli-variate regression for April 1, 2020 cases from table 1 and 2. Included in our report is a comparison on how our R^2 values compare to the values from the original article. 

### Getting the ACS Data

- Data for each zipcode was taken from the American Community Survey (ACS) API. You will need to set up an API Census key (signup [here](https://api.census.gov/data/key_signup.html)). 
- Use `01_download_nyc_zip_codes.sh` to download the NYC zipcodes csv to a Data subfolder. 
- Use `02_download_april_1_cases.sh` to download the data for the April 1, 2020 COVID cases by zipcode. 
- Use `03_get_acs_data.R` to get the ACS census data from the ACS API. You will need to insert your own API Census key in the commented out `api_census_key`. You may need to `install.packages("sf")` if you get an error for geometry. 
- `03_get_acs_data.R` will generate a `.RData` file for easy loading of the data for further analysis. 

### Generating the Final Report

- Use `04_Group_1_Final_Report.Rmd` to generate the final report with the maps and regressions. 
- [Link to Knitted HTML](http://htmlpreview.github.io/?https://github.com/msr-ds3/covid-nyc-2022-group-1/blob/main/Group_1_Final_Report.html)

