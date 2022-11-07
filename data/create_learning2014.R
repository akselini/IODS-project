#Akseli Niemelä 7.11.2022 Assignment 2: Data wrangling

#read the data and preprocess it
lrn2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",sep="\t",header=TRUE)

#check dimensions
dim(lrn2014)
#output: 183 rows, 60 columns, i.e. 183 students, 60 measured variables 

#check structure
str(lrn2014)
#output: the different variables include Aa, Ab, Ac etc. and R has correctly identified which are encoded as characters and which as numbers 

#variables to combine
deep_qs <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
stra_qs <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
surf_qs <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")

#combine by creating new columns
lrn2014$deep <- rowMeans(lrn2014[,deep_qs])
lrn2014$stra <- rowMeans(lrn2014[,stra_qs])
lrn2014$surf <- rowMeans(lrn2014[,surf_qs])

#scale attitude
lrn2014$attitude <- lrn2014$Attitude / 10

#filter out students with 0 points in exam
library(dplyr)
lrn2014 <- filter(lrn2014,Points > 0)

#take only needed columns from raw data
learning2014 <- lrn2014[, c("gender","Age","attitude", "deep", "stra", "surf", "Points")]

#final touches
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

#check processed data's dimensions
dim(learning2014)
#output: 166 rows, 7 columns as expected

#check processed data's structure
str(learning2014)
#output: values seem to be scaled properly

#create file for processed data
library(tidyverse)
write_csv(learning2014,"data/learning2014.csv")

#check that file was written correctly
written_learning2014 <- read_csv("data/learning2014.csv")
str(written_learning2014)
head(written_learning2014)
#output: data has been stored properly in 166 rows and 7 columns, gender was recognized as a character and the rest as doubles (numerical)

