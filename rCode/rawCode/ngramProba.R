library(quanteda)
myCorp <- corpus(data_char_ukimmig2010, 
                     docvars = data.frame(party = names(data_char_ukimmig2010)))
print(myCorp)



toks <- tokens(myCorp, remove_punct = TRUE)
toks <- tokens_tolower(toks)

ngram1 <- tokens_ngrams(toks, 1)
ngram2 <- tokens_ngrams(toks, 2)
ngram3 <- tokens_ngrams(toks, 3)

        ngram1
        ngram2        
        ngram3        
        