source('~/RStudio Scripts/Capstone Project/file_reading.R')

# To calculate the total lines in each of the 3 files

blogs_lines = length(blogs)
news_lines = length(news)
twitter_lines = length(twitter)

#' To calculate the longest length or number of characters that occured in each file

blogs_maxnchar = max(nchar(blogs))
news_maxnchar = max(nchar(news))
twitter_maxnchar = max(nchar(twitter))

#' Converting the text files into a tibble for easy working with the tesxt files

blogs = tibble(text = blogs)
news = tibble(text = news)
twitter = tibble(text = twitter)

#' Calculate the total number of words in each text file

blogs_text = blogs %>%
  unnest_tokens(word, text)

news_text = news %>%
  unnest_tokens(word, text)

twitter_text = twitter %>%
  unnest_tokens(word, text)

blogs_word_count = count(blogs_text, word, sort = TRUE)
news_word_count = count(news_text, word, sort = TRUE)
twitter_word_count = count(twitter_text, word, sort = TRUE)

blogs_total_words = sum(blogs_word_count$n)
news_total_words = sum(news_word_count$n)
twitter_total_words = sum(twitter_word_count$n)

#' Calculate the size of each variable in megabytes

blogs_size = file.info(file_list[1])$size / 2^20
news_size = file.info(file_list[2])$size / 2^20
twitter_size = file.info(file_list[3])$size / 2^20