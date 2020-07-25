Unigram_Words_List = readRDS("E:/RStudio Scripts/Capstone Project/Unigrams.RDS")

Bigram_Words_List = readRDS("E:/RStudio Scripts/Capstone Project/Bigrams.RDS")

Trigram_Words_List = readRDS("E:/RStudio Scripts/Capstone Project/Trigram.RDS")

Unigrams = subset(Unigram_Words_List, Frequency > 50)
Bigrams = subset(Bigram_Words_List, Frequency > 1)
Trigrams = subset(Trigram_Words_List, Frequency > 1)

UNIGRAMS = unigrams[ , 1]
BIGRAMS = Bigrams[ , 1:2]
TRIGRAMS = trigrams[ , 1:3]

saveRDS(UNIGRAMS, file = "UNIGRAMS.RDS")
saveRDS(BIGRAMS, file = "BIGRAMS.RDS")
saveRDS(TRIGRAMS, file = "TRIGRAMS.RDS")