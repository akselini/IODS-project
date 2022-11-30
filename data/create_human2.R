#Akseli Niemelä 26.11.2022 Assignment 5
#data from: https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human1.txt
#which was processed from: https://hdr.undp.org/data-center/documentation-and-downloads

#The data set contains countries and various values ranking their welfare and gender equality. 
#On the welfare side, there's e.g. 
#   HDI for human development index, 
#   Life.Exp for life expectancy, 
#   Edu.Exp for expected years of schooling and 
#   GNI for gross national income per capita. 
#Values such as 
#   Mat.Mor describe maternal mortality ratio, 
#   Ado.Birth adolescent birth rate, 
#   Parli.F the percentage of female representatives in parliament, 
#   Edu2.FM the ratio of female and male populations with secondary education and 
#   Labo.FM the same within the workforce.
#Now, let's manipulate it to match our needs.

library(tidyverse)
human <- read.csv2("data/human.csv")
glimpse(human)

#1. remove commas from GNI values and store as numeric
human$GNI <- gsub(",", "", human$GNI) %>% as.numeric

#2. remove unneeded variables
keep_rows <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(keep_rows))

#3. remove NA values
human <- filter(human, complete.cases(human))

#4. & 5. name rows as countries and remove the region values
rownames(human) <- human$Country
last <- nrow(human) - 7
human <- human[1:last, ]

#5. validate the structure and save
human <- dplyr::select(human,-1)
glimpse(human)
#output: 155 observations and 8 variables as expected.
write.csv(human,"data/human2.csv",row.names=TRUE)

