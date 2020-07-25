train_data_corpus = corpus(train_data)

tokenizer <- function(data) {
  tokens(train_data_corpus, 
         what = "fastestword", 
         remove_numbers = TRUE, 
         remove_url = TRUE, 
         split_hyphens = TRUE)
}

train_data_corpus = tokenizer(train_data_corpus)
print("tokenization DONE")
end3 = Sys.time()
rm(train_data)

unigrams_var = tokens_ngrams(train_data_corpus, n = 1, concatenator = " ")
print("tokens 1 DONE")
bigrams_var = tokens_ngrams(train_data_corpus, n = 2, concatenator = " ")
print("tokens 2 DONE")
trigrams_var = tokens_ngrams(train_data_corpus, n = 3, concatenator = " ")
print("tokens 3 DONE")
end4 = Sys.time()

Unigram_Words = as.character(unigrams_var) %>% list()
Bigram_Words = as.character(bigrams_var) %>% list()
Trigram_Words = as.character(trigrams_var) %>% list()

print("converting to list DONE")
end5 = Sys.time()
rm(train_data_corpus)
rm(unigrams_var)
rm(bigrams_var)
rm(trigrams_var)