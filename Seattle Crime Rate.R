library(ggmap)
library(dplyr)
library(ggplot2)

download.file("http://www.sharpsightlabs.com/wp-content/uploads/2015/01/seattle_crime_2010_to_2014_REDUCED.txt.zip", destfile="seattle_crime_2010_to_2014_REDUCED.txt.zip")
unzip("seattle_crime_2010_to_2014_REDUCED.txt.zip")

#------------------------------------
# Read crime data into an R dataframe
#------------------------------------
df.seattle_crime <- read.csv("seattle_crime_2010_to_2014_REDUCED.txt")


################
# SEATTLE GGMAP
################

map.seattle_city <- qmap("seattle", zoom = 11, source="stamen", maptype="toner")
#,darken = c(.3,"#BBBBBB")
map.seattle_city
##########################
# CREATE BASIC MAP
#  - dot distribution map
##########################
map.seattle_city +
  geom_point(data=df.seattle_crime, aes(x=Longitude, y=Latitude))
#####################
# CREATE SCATTERPLOT
#####################
ggplot() +geom_point(data=df.seattle_crime, aes(x=Longitude, y=Latitude))
#############################
# ADD TRANSPARENCY and COLOR
#############################

map.seattle_city +
  geom_point(data=df.seattle_crime, aes(x=Longitude, y=Latitude), color="dark green", alpha=.03, size=1.1)

#################################
# TILED version 
#  tile border mapped to density
#################################
map.seattle_city +
  stat_density2d(data=df.seattle_crime, aes(x=Longitude
                                            , y=Latitude
                                            ,color=..density..
                                            ,size=ifelse(..density..<=1,0,..density..)
                                            ,alpha=..density..)
                 ,geom="tile",contour=F) +
  scale_color_continuous(low="orange", high="red", guide = "none") +
  scale_size_continuous(range = c(0, 3), guide = "none") +
  scale_alpha(range = c(0,.5), guide="none") +
  ggtitle("Seattle Crime Rate") +
  theme(plot.title = element_text(family="Trebuchet MS", size=36, face="bold", hjust=0, color="#777777"))
