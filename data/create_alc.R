# Akseli Niemelä 15.11.2022 Merging the student performance dataset from: https://archive.ics.uci.edu/ml/datasets/Student+Performance

math <- read.table("data/student-mat.csv", sep=";",header = TRUE)
por <- read.table("data/student-por.csv",sep = ";", header = TRUE)

#check structure and dimensions of data 
glimpse(math)
glimpse(por)
#output: math has 395 students and 33 measured variables, por has 649 students and 33 variables. data was read correctly

library(dplyr)

#these columns vary between datasets, so all others will be used to id students
free_cols <- c("failures","paid","absences","G1","G2","G3")
#columns to id students
join_cols <- setdiff(colnames(por), free_cols)
#merge the data according to join_cols and label the variable columns according to which dataset they originated from
math_por <- inner_join(math, por, by = join_cols,suffix=c(".math",".por"))

#check structure and dimensions of merged data
glimpse(math_por)
#output: merged data which contain only students who answered the questionnaire in both classes has 370 students and 39 measured variables (including duplicates)

#this means that the same students answered the same questions twice, and thus the duplicate answers should be merged
#collect id data 
alc <- select(math_por, all_of(join_cols))
#perform this to all duplicate columns
for(col_name in free_cols) {
  #select the two columns from por and math subset
  two_cols <- select(math_por, starts_with(col_name))
  #using the first answer determine if it is a numeric or character variable
  first_col <- select(two_cols, 1)[[1]]
  if(is.numeric(first_col)) {
    #-> it's numeric so take mean and add this merged column to alc
    alc[col_name] <- round(rowMeans(two_cols))
  } else {
    #-> it's character so take the first reported value and add this merged column to alc
    alc[col_name] <- first_col
  }
}

#check structure and dimensions of merged data sans duplicates
glimpse(alc)
#output: 370 students and 33 variables as expected


#create new column alc_use which combines average of weekday and weekend alcohol consumption
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
#create new logical column which marks if alc_use is high or not 
alc <- mutate(alc, high_use = alc_use > 2)

#check structure and dimensions of final processed data
glimpse(alc)
#output: 370 students, 35 variables - alc_use and high_use behave as expected

library(tidyverse)
#write the processed data
write_csv(alc,"data/alc.csv")
