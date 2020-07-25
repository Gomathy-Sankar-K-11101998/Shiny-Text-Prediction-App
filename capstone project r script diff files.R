#' Removing all the variables in the environment
rm(list = ls())

start = Sys.time()
#'Installing Libraries 
library(tidytext)
library(tidyverse)
library(dplyr)
library(tibble)
library(corpus)
library(tm)
library(RWeka)
library(data.table)
library(stringi)
library(stringr)
library(caTools)

#' In this step, the working directory is set first
setwd("E:/RStudio Scripts/Capstone Project/final/en_US")

#' In this step, the files in the working directory are listed in a list variable and all those files are read 
#' into 3 different variables

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

#' The next step is to create a training set from the text file

set.seed(12345)
blogs_train = sample(blogs, length(blogs) * 0.1)
news_train = sample(news, length(news) * 0.1)
twitter_train = sample(twitter, length(twitter) * 0.1)

#' Combining of the different training sets and creation of a Corpus Data

Train_set = c(blogs_train, news_train, twitter_train)
line_nos = sample.split(Train_set, 0.75)
Training_set = subset(Train_set, line_nos == T)
Training_Corpus = VCorpus(VectorSource(Training_set))
end1 = Sys.time()

#' In this step, the Corpus is cleaned for text mining tasks. So, the stop words are removed, punctuation 
#' words are removed, numbers are removed, white spaces are stripped off, characters are all converted 
#' to lower case characters and all the characters are finally converted into a plain text document 
#' and stems the words into their root words

Training_Corpus = tm_map(Training_Corpus, removePunctuation)
Training_Corpus = tm_map(Training_Corpus, removeNumbers)
Training_Corpus = tm_map(Training_Corpus, tolower)
Training_Corpus = tm_map(Training_Corpus, stripWhitespace)
Training_Corpus = tm_map(Training_Corpus, PlainTextDocument)
end2 = Sys.time()

#' Now is the time to do some exploratory data analysis.

unigram_tokenizer = function(x) 
  unlist(lapply(ngrams(words(x), 1), paste, collapse = " "), use.names = FALSE)

bigram_tokenizer = function(x) 
  unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)

trigram_tokenizer = function(x) 
  unlist(lapply(ngrams(words(x), 3), paste, collapse = " "), use.names = FALSE)

unigram_tdm = TermDocumentMatrix(Training_Corpus, control = list(tokenize = unigram_tokenizer))
bigram_tdm = TermDocumentMatrix(Training_Corpus, control = list(tokenize = bigram_tokenizer))
trigram_tdm = TermDocumentMatrix(Training_Corpus, control = list(tokenize = trigram_tokenizer))
end3 = Sys.time()

unigram_frequencies = findFreqTerms(unigram_tdm, 30)
bigram_frequencies = findFreqTerms(bigram_tdm, 30)
trigram_frequencies = findFreqTerms(trigram_tdm, 30)

Unigram_Freq = rowSums(as.matrix(unigram_tdm[unigram_frequencies, ]))
Unigram_Freq = data.table(word = names(Unigram_Freq), frequency = Unigram_Freq)

Bigram_Freq = rowSums(as.matrix(bigram_tdm[bigram_frequencies, ]))
Bigram_Freq = data.table(word = names(Bigram_Freq), frequency = Bigram_Freq)

Trigram_Freq = rowSums(as.matrix(trigram_tdm[trigram_frequencies, ]))
Trigram_Freq = data.table(word = names(Trigram_Freq), frequency = Trigram_Freq)

Unigram_Freq = arrange(Unigram_Freq, desc(frequency))
Bigram_Freq = arrange(Bigram_Freq, desc(frequency))
Trigram_Freq = arrange(Trigram_Freq, desc(frequency))

end = Sys.time()

#' Create a code for performing the plotting of top number of word sets
#' 
#' plot_graph = function(data, title, num) {
#'   dataframe = data[1:num, ]
#'   barplot(dataframe$frequency, names.arg = dataframe$word, col = "blue", 
#'           main = title, ylab = "Count", xlab = "Word", las = 2)
#' }
#' #' Time to do some plotting work of the exploratory data analysis to represent the top words (or) set of 
#' #' words that occur in different n gram models.
#' 
#' par(mar = c(10,4,4,2))
#' plot_graph(Unigram_Freq, "Top 15 Unigram Words", 15)
#' plot_graph(Bigram_Freq, "Top 15 Bigram words", 15)
#' plot_graph(Trigram_Freq, "Top 15 Trigram words", 15)
#' 


