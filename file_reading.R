library(dplyr)
library(quanteda)
library(corpus)
library(data.table)
library(stringi)
library(stringr)
library(caTools)

#' Read in the text files

setwd("E:/RStudio Scripts/Capstone Project/final/en_US")
file_list = list.files()
con = file(file_list[1], open = "r")
blogs = readLines(con, skipNul = TRUE)
close(con)

con = file(file_list[2], open = "r")
news = readLines(con, skipNul = TRUE)
close(con)

con = file(file_list[3], open = "r")
twitter = readLines(con, skipNul = TRUE)
close(con)

#' The text files are combined together and a small set of data is sampled from them

#data_text = c(blogs, news, twitter)
set.seed(186)
#data = sample(data_text, length(data_text) * 0.1)
blogs_data = sample(blogs, length(blogs) * 0.1)
news_data = sample(blogs, length(news) * 0.1)
twitter_data = sample(blogs, length(twitter) * 0.1)
data = c(blogs_data, news_data, twitter_data)
data = tolower(data)
line_nos = sample.split(data, 0.75)
train_data = subset(data, line_nos == T)
valid_data = subset(data, line_nos == F)

print("sampling DONE")
end1 = Sys.time()

train_data = gsub(train_data, pattern = "[@#$,.?:+*-/&!(\u20AC)\\)\\(]", replacement = "")
train_data = gsub(train_data, pattern = "(.)\\1{2,}", replacement = "") # removes any words with 3 or more repeated letters
train_data = gsub(train_data, pattern = " [a-zA-Z] ", replacement = "")
print("substitution DONE")
end2 = Sys.time() 
rm(blogs)
rm(news)
rm(twitter)
rm(blogs_data)
rm(news_data)
rm(twitter_data)
rm(data)
rm(line_nos)
rm(valid_data)
