#' remove all the existing variables
rm(list = ls())
cat("\014")

#' Load the necessary r packages

library(dplyr)
library(quanteda)
library(tidytext)
library(tidyverse)
library(corpus)
library(tm)
library(RWeka)
library(data.table)
library(wordcloud)
library(caret)
library(caTools)
library(stringi)

#' Read in the text files

setwd("C:/Users/Home/Documents/RStudio Scripts/Capstone Project/final/en_US")
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
set.seed(1234)
#data = sample(data_text, length(data_text) * 0.1)
blogs_data = sample(blogs, length(blogs) * 0.1)
news_data = sample(blogs, length(news) * 0.1)
twitter_data = sample(blogs, length(twitter) * 0.1)
data = c(blogs_data, news_data, twitter_data)
data = tolower(data)

line_nos = sample.split(data, 0.75)
train_data = subset(data, line_nos == T)
valid_data = subset(data, line_nos == F)
train_data = valid_data

#' Training_Corpus = VCorpus(VectorSource(Training_set))
train_data_corpus = corpus(train_data)

tokenizer <- function(data) {
  tokens(train_data_corpus, 
         remove_numbers = TRUE, 
         remove_punct = TRUE, 
         remove_symbols = TRUE, 
         remove_twitter = TRUE, 
         remove_url = TRUE, 
         split_hyphens = TRUE)
}

train_data_corpus = tokenizer(train_data_corpus)
train_data_corpus = tokens_remove(train_data_corpus, stopwords("english"))

unigrams_var = tokens_ngrams(train_data_corpus, n = 1, concatenator = " ")
bigrams_var = tokens_ngrams(train_data_corpus, n = 2, concatenator = " ")
trigrams_var = tokens_ngrams(train_data_corpus, n = 3, concatenator = " ")

Unigram_Words = gsub(pattern = "[#@]", "", unigrams_var)
Unigram_Words = gsub(pattern = "^[a-zA-Z]$", "", Unigram_Words) %>% list()
Bigram_Words = gsub(pattern = "[#@]", "", bigrams_var) %>% list()
Trigram_Words = gsub(pattern = "[#@]", "", trigrams_var) %>% list()

Unigram_Freq_Dist = table(Unigram_Words) %>% 
  as.data.frame(responseName = "Frequency") %>% 
  arrange(desc(Frequency))

Bigram_Freq_Dist = table(Bigram_Words) %>% 
  as.data.frame(responseName = "Frequency") %>% 
  arrange(desc(Frequency))

Trigram_Freq_Dist = table(Trigram_Words) %>% 
  as.data.frame(responseName = "Frequency") %>% 
  arrange(desc(Frequency))

# plot_graph = function(data, title, num) {
#   dataframe = data[1:num, ]
#   barplot(dataframe$Frequency, names.arg = dataframe[ , 1], col = "blue", 
#           main = title, ylab = "Count", xlab = "Word", las = 2)
# }
# par(mar = c(10,4,4,2))
# plot_graph(Unigram_Freq_Dist, "Top 15 Unigram Words", 15)
# plot_graph(Bigram_Freq_Dist, "Top 15 Bigram words", 15)
# plot_graph(Trigram_Freq_Dist, "Top 15 Trigram words", 15)

Unigram_Words_List = Unigram_Freq_Dist[ , 1] %>% 
  as.character() %>% 
  as.data.frame() %>% 
  cbind(Unigram_Freq_Dist$Frequency)
Bigram_Words_List = str_split_fixed(Bigram_Freq_Dist$Bigram_Words, " ", 2) %>% 
  as.data.frame() %>% 
  cbind(Bigram_Freq_Dist$Frequency)
Trigram_Words_List = str_split_fixed(Trigram_Freq_Dist$Trigram_Words, " ", 3) %>% 
  as.data.frame() %>% 
  cbind(Trigram_Freq_Dist$Frequency)

names(Unigram_Words_List) = c("Words", "Frequency")
names(Bigram_Words_List) = c("Word_1", "Word_2", "Frequency")
names(Trigram_Words_List) = c("Word_1", "Word_2", "Word_3", "Frequency")

UnigramPredictor = function(number) {
  word_list = Unigram_Words_List[1:number, 1] %>% as.character()
  word_list
}

BigramPredictor = function(text, number) {
  row_numbers = which(Bigram_Words_List$Word_1 == text)[1:number]
  word_list = Bigram_Words_List$Word_2[row_numbers] %>% as.character()
  word_list
}

TrigramPredictor = function(text, number) {
  row_numbers_1 = which(Trigram_Words_List$Word_1 == text[1])
  Trigram_Words_List_1 = Trigram_Words_List[row_numbers_1, ]
  
  row_numbers_2 = which(Trigram_Words_List_1$Word_2 == text[2])
  Trigram_Words_List_2 = Trigram_Words_List_1[row_numbers_2, ]
  
  word_list = Trigram_Words_List_2$Word_3[1:number] %>% as.character()
  word_list
}

Word <- readline(prompt="Enter the Word: ")
Word = tolower(Word)
word_count = stri_count_words(Word)
display_num = readline(prompt = "Enter the top number of words to be displayed: ") %>% 
  as.integer()

if(word_count >= 3) {
  Words = strsplit(Word, " ") %>% unlist()
  Words = tail(Words, 2)
  Word = paste(Words[1], Words[2], sep = " ") %>% tolower()
  word_count = stri_count_words(Word)
}

if(word_count == 2) {
  Words = strsplit(Word, " ") %>% unlist()
  list_of_words = TrigramPredictor(Words, display_num)
  na_sum = sum(is.na(list_of_words))
  if(na_sum == 0){
    print(list_of_words)
  }
  else {
    na_rows = which(is.na(list_of_words))
    extra_words = BigramPredictor(Words[2], na_sum)
    list_of_words[na_rows] = extra_words
    
    na_sum = sum(is.na(list_of_words))
    if(na_sum == 0){
      print(list_of_words)
    }
    else {
      na_rows = which(is.na(list_of_words))
      extra_words = UnigramPredictor(na_sum)
      list_of_words[na_rows] = extra_words
      print(list_of_words)
    }
  }
}

if(word_count == 1) {
  list_of_words = BigramPredictor(Word, display_num)
  
  na_sum = sum(is.na(list_of_words))
  if(na_sum == 0){
    print(list_of_words)
  }
  else {
    na_rows = which(is.na(list_of_words))
    extra_words = UnigramPredictor(na_sum)
    list_of_words[na_rows] = extra_words
  }
}

if(word_count == 0) {
  list_of_words = UnigramPredictor(display_num)
  print(list_of_words)
}