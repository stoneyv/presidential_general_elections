# Presidential General Elections 2000 through 2016 

To get the transformed data and scripts
```bash
git clone https://github.com/stoneyv/presidential_general_elections.git
```

* Transformed data for 2000 through 2016 is in the output folder.
* Alaskan data is not satisfactory. Resolving boroughs from precinct/district data.
* The source of original data is cited and some of the data is in the data/ folder.
* The transformation of data may be replicated using the jupyter ipython notebooks.
* The scripts folder contains R based code that produce plots.
* The images folder contains plots that were produced with the scripts or notebooks.

<p align="center">
  <img src="plots/2016_rep_percentages_by_county.png" width="360"/>
  <img src="plots/2016_dem_percentages_by_county.png" width="360"/>
</p>
<p align="center">
  <img src="plots/2012_rep_percentages_by_county.png" width="360"/>
  <img src="plots/2012_dem_percentages_by_county.png" width="360"/>
</p>

## Data Sources

### Census 2010 FIPS
https://www.census.gov/geo/reference/codes/cou.html
http://www2.census.gov/geo/docs/reference/codes/files/national_county.txt

### Census shapefile  
https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html  

### Tony McGovern 2016 Presidential General Election (unofficial results)
NOTE: Alaska vote entries for 2016 are currently repeated state totals. This will be resolved soon.  Also, Each secretary of state has a different date for official certification of elections which occurs before the electoral college vote in December.
* https://github.com/tonmcg/County_Level_Election_Results_12-16
* http://townhall.com/election/2016/president/
* https://www.elections.alaska.gov/index.php

### USGS 2012 Presidential General Election
County Results
https://catalog.data.gov/dataset/presidential-general-election-results-2012-direct-download

### USGS 2008 Presidential General Election
County Results
https://catalog.data.gov/dataset/2008-presidential-general-election-county-results-direct-download

### USGS 2004 Presidential General Election  
https://catalog.data.gov/dataset/2004-presidential-general-election-county-results-direct-download  

### David Lublin and D. Stephen Voss. 2001. "Federal Elections Project." American University, Washington, DC and the University of Kentucky, Lexington, KY.
### 2000 Election Data By State
http://www.american.edu/spa/ccps/Data-Sets.cfm  

### The Guardian, Full US 2012 election county-level results
https://www.theguardian.com/news/datablog/2012/nov/07/us-2012-election-county-results-download
https://fusiontables.google.com/DataSource?docid=1qcQLqrAIAe3RcEfdWSm_QcXMLmteVg4uSpSs1rM#rows:id=1

### The Guardian, 2008 presidential election results by state and county
https://www.theguardian.com/news/datablog/2009/mar/02/us-elections-2008
https://docs.google.com/spreadsheets/d/1gLzjUFBk9gtAPfZ-bNZVfFC1zNhGkY_WI_VD_OXHUYI/edit#gid=0

### Daily Kos 2012, 2008 by congressional district
https://docs.google.com/spreadsheets/d/146z3cDVx5WGCprbKGFSMeGfyTFfIlE8SbjrLQ0sfkBI/edit#gid=0

### history.house.gov Election Statistics, 1920 to Present
http://history.house.gov/Institution/Election-Statistics/Election-Statistics/

### Harvard Election Data Archive
http://projects.iq.harvard.edu/eda/pages/about

### Open Elections
http://openelections.net/
https://github.com/openelections

### Library of Congress, US Election Statistics
https://www.loc.gov/rr/program/bib/elections/statistics.html

### electproject, Voter Turnout
http://www.electproject.org/home/voter-turnout/voter-turnout-data
http://www.electproject.org/2016g
https://docs.google.com/spreadsheets/d/1VAcF0eJ06y_8T4o2gvIL4YcyQy8pxb1zYkgXF76Uu1s/edit#gid=2030096602

### Census voter demographics 2004,2008,2012,2014
2014  
http://www.census.gov/data/tables/time-series/demo/voting-and-registration/p20-577.html  
2012  
http://www.census.gov/data/tables/2012/demo/voting-and-registration/p20-568.html  
2008 pdf  
http://www.census.gov/prod/2010pubs/p20-562.pdf   
2004 pdf  
http://www.census.gov/prod/2006pubs/p20-556.pdf  
2000 pdf with supplement  
https://www.census.gov/prod/techdoc/cps/cpsnov00.pdf  

### Princeton 2016 Election Polling data  
http://election.princeton.edu/code/data/  

### The American Presidency Project
no election county/precinct results, polling and other  
http://www.presidency.ucsb.edu/index.php
