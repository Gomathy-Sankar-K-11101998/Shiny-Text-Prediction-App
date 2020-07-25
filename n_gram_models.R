source('E:/RStudio Scripts/Capstone Project/file_reading.R')

source('E:/RStudio Scripts/Capstone Project/tokenization.R')

Unigram_Freq_Dist = table(Unigram_Words) %>% 
  as.data.frame(responseName = "Frequency") %>% 
  arrange(desc(Frequency))
print("Unigram arranging DONE")
end6 = Sys.time()
rm(Unigram_Words)

Bigram_Freq_Dist = table(Bigram_Words) %>% 
  as.data.frame(responseName = "Frequency") %>% 
  arrange(desc(Frequency))
print("Bigram arranging DONE")
end7 = Sys.time()
rm(Bigram_Words)

Trigram_Freq_Dist = table(Trigram_Words) %>%
  as.data.frame(responseName = "Frequency") %>%
  arrange(desc(Frequency))
print("Trigram arranging DONE")
end8 = Sys.time()
rm(Trigram_Words)

Unigram_Words_List = Unigram_Freq_Dist[ , 1] %>% 
  as.character() %>% 
  as.data.frame() %>% 
  cbind(Unigram_Freq_Dist$Frequency)
print("Unigrams Words done")
end9 = Sys.time()
rm(Unigram_Freq_Dist)

Bigram_Words_List = str_split_fixed(Bigram_Freq_Dist$Bigram_Words, " ", 2) %>% 
  as.data.frame() %>% 
  cbind(Bigram_Freq_Dist$Frequency)
print("Bigrams Words done")
end10 = Sys.time()
rm(Bigram_Freq_Dist)

Trigram_Words_List = str_split_fixed(Trigram_Freq_Dist$Trigram_Words, " ", 3) %>%
  as.data.frame() %>%
  cbind(Trigram_Freq_Dist$Frequency)
print("Trigrams Words done")
end11 = Sys.time()
rm(Trigram_Freq_Dist)

names(Unigram_Words_List) = c("Words", "Frequency")
names(Bigram_Words_List) = c("Word_1", "Word_2", "Frequency")
names(Trigram_Words_List) = c("Word_1", "Word_2", "Word_3", "Frequency")

saveRDS(Unigram_Words_List, file = "Unigrams.RDS")
saveRDS(Bigram_Words_List, file = "Bigrams.RDS")
saveRDS(Trigram_Words_List, file = "Trigram.RDS")