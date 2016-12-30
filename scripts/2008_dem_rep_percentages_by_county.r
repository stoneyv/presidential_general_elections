library(data.table)
library(ggplot2)
library(dplyr)
library(rgeos)
library(rgdal)
library(maptools)
library(RColorBrewer)

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
# requires libraries rgeos and maptools
county_map_df <- fortify(us_map, region="GEOID")

# Load transformed results for 2008
results <- fread('../output/2008_pres_election_by_county.csv')

# Using dpylr to remove AK rows and create combined percentages column
# https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
# https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
#
county_data <- results %>%
               filter(STATE_ABBR != 'AK') %>%
               select(id=FIPS, PERCENT_DEM, PERCENT_REP)

# Add leading 0 to FIPS with 4 characters
# http://bama.ua.edu/~mdporter2/st597_Sp15/lectures/12-spatial.html

# Create mask for id column rows w/ 4 character FIPS
add_zero <- nchar(county_data$id) == 4  # select rows w/ 4 chars
# Add leading zero to rows using mask
county_data$id[add_zero] <- paste("0",county_data$id[add_zero],sep='') 

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


county_map_data <- left_join(county_map_df, county_data)
      

# Two different ways to plot the Democrat and Republican votes

# mdem uses geom_polygon
# mdem2 uses geom_map wrapper

mdem <- ggplot(county_map_data,
               aes(x = long, y = lat, group = group)) +
        geom_polygon(aes(fill=PERCENT_DEM)) +
        scale_fill_gradientn(colors=brewer.pal(5,"Blues"),
                             limits=c(0,100),
                             guide=guide_legend(title="% Democrat\n Votes")) +
        coord_map("polyconic") +
        labs(title = "US 2008 Presidential General Election\nDemocrat Vote Percentages by County") +
        annotate("text", x = -105, y = 23, label = "data source:  National Atlas USGS 2008") +
        theme_minimal

mdem2 <- ggplot() +
         geom_map(map=county_map_data, data=county_map_data,
                  aes(map_id=id, x=long, y=lat, 
                      group=group, fill=PERCENT_DEM),
                      color="white", size=0.05) +
         scale_fill_continuous(low="white", high="blue",
                               limits=c(0,100),
                               guide=guide_legend(title="% Democrat\n Votes")) +
        coord_map("polyconic") +
        labs(title = "US 2008 Presidential General Election\nDemocrat Vote Percentages by County") +
        annotate("text", x = -105, y = 23, label = "data source:  National Atlas USGS 2008") +
        theme_minimal


# Two different ways to plot the Democrat and Republican votes

# mrep uses geom_polygon
# mrep uses geom_map wrapper

mrep <- ggplot(county_map_data,
               aes(x = long, y = lat, group = group)) +
        geom_polygon(aes(color="black", 
                         fill=PERCENT_REP)) +
        scale_fill_gradientn(colors=brewer.pal(5,"Reds"),
                             limits=c(0,100),
                             guide=guide_legend(title="% Republican\n Votes")) +
        coord_map("polyconic") +
        labs(title = "US 2008 Presidential General Election\nRepublican Vote Percentages by County") +
        annotate("text", x = -105, y = 23, label = "data source:  National Atlas USGS 2008") +
        theme_minimal

mrep2 <- ggplot() +
         geom_map(map=county_map_data, data=county_map_data,
                  aes(map_id=id, x=long, y=lat, 
                      group=group, fill=PERCENT_REP),
                      color="white", size=0.05) +
         scale_fill_continuous(low="white", high="red",
                               limits=c(0,100),
                               guide=guide_legend(title="% Republican\n Votes")) +
        coord_map("polyconic") +
        labs(title = "US 2008 Presidential General Election\nRepublican Vote Percentages by County") +
        annotate("text", x = -105, y = 23, label = "data source:  National Atlas USGS 2008") +
        theme_minimal


# Save the plots to png files
# Set the width and height or the size of rstudio or studio server will
# influence the size of the plot

ggsave(mdem2,
       width = 11,
       height = 8.5,
       dpi = 300,
       file = "../plots/2008_dem_percentages_by_county.png",
       type = "cairo-png")       

ggsave(mrep2,
       width = 11,
       height = 8.5,
       dpi = 300,
       file = "../plots/2008_rep_percentages_by_county.png",
       type = "cairo-png")       
