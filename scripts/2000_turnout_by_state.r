library(data.table)
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

# 2000 is not in a Google spreadsheet, so saved it to data
# and modified the headers
# http://www.electproject.org/2000g

turnout_00 <- fread('../data/electproject-org/2000_electproject_participation.csv')

# Use dpylr and pipes %>% to eliminate rows that
# are not states and set region and values columns
# in preparation for choroplethr library
results <- turnout_00 %>%
           filter(State != '' & State != 'United States') %>%
           mutate(value=VAP_Highest_Office) %>%
           select(region=State, value)

# choroplethr state names are all lower case
results$region <- tolower(results$region)
# Remove % sign and coerce string to numeric type
results$value <- as.numeric(sub('%','', results$value))

# Plot percentage of votes by state from VEP (elegible voters)
# that had a vote counted for the highest office
m0 <- state_choropleth(results,
                 title = '2000 Eligible Voters Turnout\nHighest Office',
                 legend = '% VEP',
                 num_colors = 1 )
            
# Save the plot to the output folder
ggsave(m0,
       width = 11,
       height = 8.5,
       dpi = 300,
       file = "../plots/2000_voter_turnout.png",
       type = "cairo-png")

