library(choroplethr)
library(choroplethrMaps)
library(ggplot2)
library(gsheet)
library(dplyr)

# Setting the working directory and then confirming it.
working_dir <- '/home/stoney/Desktop/presidential_elections/scripts/'
setwd(working_dir)
getwd()

#
# United States Election Project
# http://www.electproject.org/
# Dr. Michael P. McDonald
# Associate Professor University of Florida
# Department of Political Science
#

# Use gsheet to retrieve Google spreadsheet
elect_project_16 <- 'https://docs.google.com/spreadsheets/d/1VAcF0eJ06y_8T4o2gvIL4YcyQy8pxb1zYkgXF76Uu1s/edit#gid=2030096602'
turnout_16 <- gsheet2tbl(url=elect_project_16 )

# Use dpylr and pipes %>% to eliminate rows that
# are not states and set region and values columns
# in preparation for choroplethr library
results <- turnout_16 %>%
           filter(State != '' & State != 'United States') %>%
           mutate(value=X.3) %>%
           select(region=State, value)

# choroplethr state names are all lower case
results$region <- tolower(results$region)
# Remove % sign and coerce string to numeric type
results$value <- as.numeric(sub('%','', results$value))

# Plot percentage of votes by state from VEP (elegible voters)
# that had a vote counted for the highest office
m0 <- state_choropleth(results,
                 title = '2016 Eligible Voters Turnout\nHighest Office',
                 legend = '% VEP',
                 num_colors = 1 )
            
# Save the plot to the output folder
ggsave(m0,
       file = "../plots/2016_voter_turnout.png",
       type = "cairo-png")

