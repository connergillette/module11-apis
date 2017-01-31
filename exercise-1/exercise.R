### Exercise 1 ###

# Load the httr and jsonlite libraries for accessing data
#install.packages('httr')
#install.packages('jsonlite')

library(httr)
library(jsonlite)
library(dplyr)

## For these questions, look at the API documentation to identify the appropriate endpoint and information.
## Then send GET() request to fetch the data, then extract the answer to the question
res <- GET('http://data.unhcr.org/api/countries/list.json')

body <- content(res, 'text')

json <- fromJSON(body)

print(json)

# For what years does the API have statistical data?
res.years <- GET('http://data.unhcr.org/api/stats/time_series_years.json')
body.years <- content(res.years, 'text')
json.years <- fromJSON(body.years)
print(json.years)

# What is the "country code" for the "Syrian Arab Republic"?
SAR.res <- GET('http://data.unhcr.org/api/countries/list.json')
SAR.body <- content(SAR.res, 'text')
SAR.json <- fromJSON(SAR.body)
SAR.code <- SAR.json %>% filter(name_en == 'Syrian Arab Republic') %>% select(country_code)
print(SAR.code)

# How many persons of concern from Syria applied for residence in the USA in 2013?
# Hint: you'll need to use a query parameter
# Use the `str()` function to print the data of interest
# See http://www.unhcr.org/en-us/who-we-help.html for details on these terms
SAR.count.res <- GET('http://data.unhcr.org/api/stats/persons_of_concern.json?year=2013&country_of_origin=SYR&country_of_residence#=USA')
SAR.count.body <- content(SAR.count.res, 'text')
SAR.count.json <- fromJSON(SAR.count.body) %>% select(total_population)
print(SAR.count.json)

## And this was only 2013...


# How many *refugees* from Syria settled the USA in all years in the data set (2000 through 2013)?
# Hint: check out the "time series" end points
SYR.res <- GET('http://data.unhcr.org/api/stats/time_series_all_years.json?population_type_code=RF&country_of_origin=SYR&country_of_residence=USA')
SYR.body <- content(SYR.res, 'text')
SYR.json <- fromJSON(SYR.body)
SYR.summary <- summarize(SYR.json, sum = sum(strtoi(value))) 
#print(SYR.json)
#print(SYR.summary)


# Use the `plot()` function to plot the year vs. the value.
# Add `type="o"` as a parameter to draw a line
SYR.json <- SYR.json %>% select(year, value)
plot(SYR.json, type="o")


# Pick one other country in the world (e.g., Turkey).
# How many *refugees* from Syria settled in that country in all years in the data set (2000 through 2013)?
# Is it more or less than the USA? (Hint: join the tables and add a new column!)
# Hint: To compare the values, you'll need to convert the data (which is a string) to a number; try using `as.numeric()`
eng.res <- GET('http://data.unhcr.org/api/stats/time_series_all_years.json?population_type_code=RF&country_of_origin=SYR&country_of_residence=GBR')
eng.body <- content(eng.res, 'text')
eng.json <- fromJSON(eng.body)
#print(eng.json)

## Bonus (not in solution):
# How many of the refugees in 2013 were children (between 0 and 4 years old)?


## Extra practice (but less interesting results)
# How many total people applied for asylum in the USA in 2013?
# - You'll need to filter out NA values; try using `is.na()`
# - To calculate a sum, you'll need to convert the data (which is a string) to a number; try using `as.numeric()`


## Also note that asylum seekers are not refugees
