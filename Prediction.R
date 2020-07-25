Unigram_Words_List = readRDS("E:/RStudio Scripts/Capstone Project/Unigrams.RDS")

Bigram_Words_List = readRDS("E:/RStudio Scripts/Capstone Project/Bigrams.RDS")

Trigram_Words_List = readRDS("E:/RStudio Scripts/Capstone Project/Trigrams.RDS")

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
