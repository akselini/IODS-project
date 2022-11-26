#Akseli Niemelä 22.11.2022 Assignment 4: Clustering and classification

#read the data
library(tidyverse)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#check structure
glimpse(hd)
#output: 195 rows and 8 columns. character and number data are encoded correctly. 

#get summary
summary(hd)
#no large skews between mean and median values, besides gross national income.

#check structure
glimpse(gii)
#output: 195 rows and 10 columns. character and number data are encoded correctly. 

#get summary
summary(gii)
#large skew in maternal mortality ratio, thus a small number of countries has a high number of mortalities. for other variables median and mean similar

#change names
colnames(hd)
names(hd)[3] <- "HDI"
names(hd)[4] <- "Life.Exp"
names(hd)[5] <- "Edu.Exp"
names(hd)[6] <- "Edu.Yrs"
names(hd)[7] <- "GNI"
names(hd)[8] <- "GNI-HDI Rank"
colnames(hd)

colnames(gii)
names(gii)[3] <- "GII"
names(gii)[4] <- "Mat.Mor"
names(gii)[5] <- "Ado.Birth"
names(gii)[6] <- "Parli.F"
names(gii)[7] <- "Edu2.F"
names(gii)[8] <- "Edu2.M"
names(gii)[9] <- "Labo.F"
names(gii)[10] <- "Labo.M"
colnames(gii)

#add new variables
gii <- mutate(gii,Edu2.FM = Edu2.F/Edu2.M)
gii <- mutate(gii,Labo.FM = Labo.F/Labo.M)

#join datasets by country
human <- inner_join(hd,gii,by="Country")
glimpse(human)
#output: 195 observations and 19 variables as expected

write_csv2(human,"data/human.csv")

