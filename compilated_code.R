library(wordcloud2)
source('E:/RStudio Scripts/Capstone Project/Prediction.R')

predict_word = TRUE
while(predict_word == TRUE) {
  Word <- readline(prompt = "Enter the Word: ")
  Word = tolower(Word)
  word_count = stri_count_words(Word)
  # display_num = readline(prompt = "Enter the top number of words to be displayed: ") %>% 
  #   as.integer()
  # 
  display_num = 10
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

  reqd_words = data.frame(Words = list_of_words, Probability = display_num:1)
  word_plot = wordcloud2(reqd_words, fontWeight = 'normal', gridSize = 0.6, size = 0.75)
  word_plot
  
  predict_word = switch(menu(c("Yes", "No"), title = "Do you want to predict word of another sentence?"), 
                        TRUE, FALSE)
}
