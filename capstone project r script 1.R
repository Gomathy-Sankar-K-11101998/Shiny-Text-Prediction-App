#' Removing all the variables in the environment
rm(list = ls())

#'Installing Libraries 
library(dplyr)
library(data.table)
library(quanteda)
library(readtext)

#' In this step, the working directory is set first
setwd("C:/Users/Home/Documents/RStudio Scripts/Capstone Project/final/en_US")

#' In this step, the files in the working directory are listed in a list variable and all those files are read 
#' into another variable
file_list = list.files()
datalist = lapply(file_list, function(x) readtext(x, ignore_missing_files = TRUE)) 


#' In this step, all the lines in the text file are read and saved in the lineslist variable and that variable 
#' is now used to find the length of each line in all the text files.
# lineslist = lapply(datalist, function(x) readLines(x)) 
# letters_list = lapply(lineslist, nchar)

#' The line with the longest length i.e., the number of characters and the highest number of characters in each
#' of the text file is noted down.
# max_letters_row = lapply(letters_list, function(x) which.max(x))
# max_letters = lapply(letters_list, function(x) max(x))

#' This step deals with separating all the text into separate words and counting the total number of 
#' times each word has appeared in the text.
# lineslist = lapply(lineslist, function(x) tibble(text = x))
# words_list = lapply(lineslist, unnest_tokens, word, text) %>% 
#   lapply(function(x) anti_join(x, stop_words))

#' words_list_count = lapply(words_list, function(x) count(x, word, sort = TRUE)) %>% 
#'   lapply(function(x) setDT(x))
#' head(words_list_count)
#' 
#' #' In this step, a histogram representing the words that has appeared different times
#' word_count_plot = lapply(words_list_count, function(x) 
#'   ggplot(x, aes(n)) + 
#'     geom_histogram() + scale_x_log10())
#' word_count_plot
#' 
#' #' In a statistical model for a text, if a word only appears 1 or 2 times in a text then that is more likely 
#' #' to be a noise in the text. In the previous plots, we have seen that there are many number of unique words 
#' #' which when viewed in the count variable contained many noise than useful words. So, in this step, these
#' #' words are filtered out from the word count.
#' 
#' words_list_new = lapply(words_list, function(x) filter(x, 
#'                                                       !str_detect(word, pattern = "[[:digit:]]"), # removes any words with numeric digits
#'                                                       !str_detect(word, pattern = "[[:punct:]]"), # removes any remaining punctuations
#'                                                       !str_detect(word, pattern = "(.)\\1{2,}"),  # removes any words with 3 or more repeated letters
#'                                                       !str_detect(word, pattern = "\\b(.)\\b")    # removes any remaining single letter words
#'                                                       ))
#' 
#' #' In this step, some of the words like "love", "loving", "lovers", etc., are all words that belongs to the 
#' #' root word "love". So, in this step, the words are all converted into their root words. The stemmer 
#' #' argument in the text_tokens function is assigned "en" which represents "english".
#' 
#' ###words_list_new_copy = words_list_new %>% lapply(function(x) text_tokens(x, stemmer = "en")) %>% 
#'   ###unlist()
#' 
#' words_list_count_new = lapply(words_list_new, function(x) count(x, word, sort = TRUE)) %>% 
#'   lapply(function(x) setDT(x))
#' head(words_list_count_new)
