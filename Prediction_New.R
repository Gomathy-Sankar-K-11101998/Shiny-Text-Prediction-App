Unigram_Words_List = readRDS("Unigrams.RDS")

Bigram_Words_List = readRDS("Bigrams.RDS")

Trigram_Words_List = readRDS("Trigrams.RDS")

UnigramPredictor = function() {
  word_list = Unigram_Words_List[ , 1] %>% as.character()
  word_list
}

BigramPredictor = function(text) {
  row_numbers = which(Bigram_Words_List$Word_1 == text)
  word_list = Bigram_Words_List$Word_2[row_numbers] %>% as.character()
  word_list
}

TrigramPredictor = function(text) {
  row_numbers_1 = which(Trigram_Words_List$Word_1 == text[1])
  Trigram_Words_List_1 = Trigram_Words_List[row_numbers_1, ]
  
  row_numbers_2 = which(Trigram_Words_List_1$Word_2 == text[2])
  Trigram_Words_List_2 = Trigram_Words_List_1[row_numbers_2, ]
  
  word_list = Trigram_Words_List_2$Word_3 %>% as.character()
  word_list
}
