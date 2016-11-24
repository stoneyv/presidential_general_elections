library(data.table)
library(choroplethr)
library(choroplethrMaps)
library(ggplot2)
library(dplyr)

# Setting the working directory and then confirming it.
setwd('/home/stoney/Desktop/presidential_elections/scripts')
getwd()

results_16 <- fread('../output/2016_pres_election_by_county.csv')

# Using dpylr to create required region and value attributes that 
# the function library choroplethr needs.
#
# Tutorial for dpylr
# https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
#
# The pipe symbol is %>% and sends ouput to the next dpylr command.
#
# filter keeps rows that are not for Alaska. (temporary while resolving AK votes)
#
# mutate adds a new attribute named value
#
# select will only keep a new attribute named region and the
# recently created attribute value
#
results <- results_16 %>%
           filter(STATE_ABBR != 'AK') %>%
           mutate(value=PERCENT_REP) %>%
           select(region=FIPS, value)

us_county_map <- CountyChoropleth$new(results)

# Setting a brewer color scale for fill values
us_county_map$ggplot_scale <- scale_fill_brewer(name = '% Republican\n Votes',
                                                palette = 'Reds',
                                                drop=FALSE)

us_county_map$title = 'US 2016 Presidential General Election\n Republican Vote Percentages by County'
us_county_map$render()
