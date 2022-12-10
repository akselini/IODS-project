# Akseli Niemelä 10.12.2022 Preparing data from a rat nutrition study and a study on psychiatric treatments

#load data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = TRUE, sep  =" ")
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')


#check the structure of data
glimpse(BPRS)
#output: 40 observations and 11 variables. 9 of the variables (week0-week8) lists the development of the same assessed psychiatric value over the course of several weeks.
summary(BPRS)
#output: there's 40 subjects divided evenly to two groups which compare treatments. Looking at the mean values, generally the assessed psychiatric value is lower after 8 weeks of treatment compared to baseline.

glimpse(RATS)
#output: 16 observations and 13 variables. 11 of the variables (WD starting ones) describe the development of weight on rats under different treatments. 
summary(RATS)
#output: 16 different rats, which have been classified to 3 treatment groups. Based on WD means, weight seems to generally increase under all treatment plans.


#converting the identifying variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)


#converting the data to long form
BPRSL <- pivot_longer(BPRS, cols=-c(treatment,subject),names_to = "weeks",values_to = "bprs") %>% mutate(week = as.integer(substr(weeks,5,5))) %>% arrange(weeks)
RATSL <- pivot_longer(RATS, cols=-c(ID,Group), names_to = "WD",values_to = "Weight")          %>% mutate(Time = as.integer(substr(WD,3,4)))    %>% arrange(Time)



#check the structure of long form data
glimpse(BPRSL)
#output: 360 observations and 5 variables. Now all the psychiatric data is listed in one variable instead of 9, and each week is listed in a separate integer variable. 
summary(BPRSL)
#output: now the mean value for bprs gives the average score of all data combined, which is quite useless, but the data can now be used in longitudal analysis. Weeks increase from 0-8

# BPRSL data variables are as follows
# treatment = id of the treatment
# subject   = id of the subject
# weeks     = character representation of each week
# bprs      = psychiatric score
# week      = integer representation of each week

glimpse(RATSL)
#output: 176 observations and 5 variables. Same as before, now all weight data is in one variable.
summary(RATSL)
#output: findings are same as before, days increase from 1 to 64.

# RATSL data variables are as follows
# Group     = id of the nutritional plan
# ID        = id of the rat
# WD        = character representation of each day
# Weight    = weight
# Time      = integer representation of each day

#write the wrangled data
library(tidyverse)
write_csv(BPRSL,"data/bprsl.csv")
write_csv(RATSL,"data/ratsl.csv")
