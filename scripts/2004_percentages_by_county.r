library(data.table)
library(ggplot2)
library(dplyr)
library(rgeos)
library(rgdal)

# Setting the working directory and then confirming it.
setwd('/home/stoney/Desktop/presidential_elections/scripts')
getwd()

## TODO fix problem w/ 2010 shapefile. using 2013 for now
# Read shapefile from census 
#us_map <- readOGR(dsn= "../data/gz_2010_us_county_500k",
#                  layer = "gz_2010_us_county_500k")

# Read shapefile from census 
us_map <- readOGR(dsn= "../data/cb_2013_us_county_500k",
                  layer = "cb_2013_us_county_500k")

# Remove polygons outside of continental US
# https://www.datascienceriot.com/mapping-us-counties-in-r-with-fips/kris/
#
#  Alaska(2), Hawaii(15), Puerto Rico (72),
#  Guam (66), Virgin Islands (78), American Samoa (60)
#  Mariana Islands (69), Micronesia (64),
#  Marshall Islands (68), Palau (70), Minor Islands (74)
#
us_map <- us_map[!us_map$STATEFP %in% c("02", "15", "72", "66",
                                        "78", "60", "69", "64",
                                        "68", "70", "74"),]
us_map <- us_map[!us_map$STATEFP %in% c("81", "84", "86", "87",
                                        "89", "71", "76", "95",
                                        "79"),]

# Convert geospatial object to dataframe
county_map_df <- fortify(us_map, region="GEOID")

# Combine winner of each county into one vector w/
# a range extended to [-100,100] to render red and blue fill
#
combine <- function(PERCENT_DEM, PERCENT_REP){
    num_rows = length(PERCENT_DEM)
    combined <- rep(0,num_rows)
    for(i in 1:num_rows){
        if( PERCENT_DEM[i] > PERCENT_REP[i]){
          combined[i] <- PERCENT_DEM[i] * 1
        }
        else if( PERCENT_DEM[i] < PERCENT_REP[i]){
          combined[i] <- PERCENT_REP[i] * -1
        }
        else {
          combined[i] <- 0
        }
    }
    return(combined)
}

# Load transformed results for 2004
results_04 <- fread('../output/2004_pres_election_by_county.csv')

# Using dpylr to remove AK rows and create combined percentages column
# https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
# https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
#
county_data <- results_04 %>%
               filter(STATE_ABBR != 'AK') %>%
               mutate(value=combine(PERCENT_DEM, PERCENT_REP)) %>%
               select(id=FIPS, value, PERCENT_DEM)

# Add leading 0 to FIPS with 4 characters
# http://bama.ua.edu/~mdporter2/st597_Sp15/lectures/12-spatial.html

# Create mask for id column rows w/ 4 character FIPS
add_zero <- nchar(county_data$id) == 4  # select rows w/ 4 chars
# Add leading zero to rows using mask
county_data$id[add_zero] <- paste("0",county_data$id[add_zero],sep='') 

# Join map dataframe with voting dataframe using FIPS
#county_map_df <- left_join(county_map_df,county_data,
#                 copy = TRUE,
#                 by="id")

# Minimal theme settings for ggplot2 
# http://docs.ggplot2.org/current/theme.html
#
theme_minimal <- theme(axis.line=element_blank(),
                       axis.text.x=element_blank(),
                       axis.text.y=element_blank(),
                       axis.ticks=element_blank(),
                       axis.title.x=element_blank(),
                       axis.title.y=element_blank(),
                       panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(),
                       panel.border = element_blank(),
                       panel.background = element_blank())


m0 <- ggplot() + geom_map(data=county_map_df, map=county_map_df,
        aes(x=long, y=lat, map_id=id, group=group),
            fill="#ffffff", color="#0e0e0e", size=0.15) +
        geom_map(data=county_data, map=county_map_df,
                 aes_string(map_id="id", fill=county_data$value),
                 color="#0e0e0e", size=0.15, alpha=0.6) +
        scale_fill_gradientn(colors = c("red", "blue"),
                             guide=guide_legend(title="% Votes")) +
        coord_map("polyconic") +
        labs(title = "US 2004 Presidential General Election\nVote Percentages by County") +
        theme_minimal

ggsave(m0,
       file = "../plots/2004_combined_percentages_by_county.png",
       type = "cairo-png")       

