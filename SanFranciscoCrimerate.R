library(ggplot2)

setwd("E://NJIT College//SEM 1//IHLP//Mantej Singh//Mini Proj//Text Mining- R")

df.sf_crime <- read.csv("test.csv")

#------------------------------
# Download water boundaries
#  and neighborhood boundaries
#------------------------------
df.sf_neighborhoods <- read.csv(url("http://www.sharpsightlabs.com/wp-content/uploads/2014/12/sf_neighborhood_boundaries.txt"))
df.sf_water <- read.csv(url("http://www.sharpsightlabs.com/wp-content/uploads/2014/12/sf_water_boundaries.txt"))



################
# PLOT THE DATA
################
ggplot() +
  geom_polygon(data=df.sf_neighborhoods,aes(x=long,y=lat,group=group) ,fill="#404040",colour= "#5A5A5A", lwd=0.05) +
  geom_polygon(data=df.sf_water, aes(x=long, y=lat, group=group),colour= "#708090", fill="#708090") +
  geom_point(data=df.sf_crime, aes(x=df.sf_crime$X, y=df.sf_crime$Y), color="#FFFF3309", fill="#FFFF3309", size=1.3) +
  geom_polygon(data=df.sf_neighborhoods, aes(x=long,y=lat, group=group) ,fill=NA,colour= "#DDDDDD55", lwd=.3) +
  ggtitle("San Francisco Crime (2014)") +
  theme(panel.background = element_rect(fill="#708090")) +
  theme(axis.title = element_blank()) +
  theme(axis.text = element_blank()) +
  theme(axis.ticks = element_blank()) +
  theme(panel.grid = element_blank()) +
  theme(plot.title = element_text(family="Consolas", size=38, face="bold", hjust=0, color="#777777"))
