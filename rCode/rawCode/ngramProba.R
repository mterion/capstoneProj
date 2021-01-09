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
        
        
ngram1Dfm <- dfm(ngram1)
ngram1Dfm
ndoc(ngram1Dfm)
nfeat(ngram1Dfm)
docnames(ngram1Dfm)
featnames(ngram1Dfm)
rowSums(ngram1Dfm)
head(colSums(ngram1Dfm), 10)
# Convert frequency count for a doc into prop
dfProp <- dfm_weight(ngram1Dfm, scheme = "prop")
        rowSums(dfProp)
        head(colSums(dfProp), 10)


# Stat analysis        
textstat_frequency(ngram1Dfm, 10)
        # Group along doc vars
        head(ngram1Dfm)
        docvars(ngram1Dfm)
        textstat_frequency(ngram1Dfm, 10, groups = "party")
        
        # Make a Df to extract total values of word frequencies
statDf <- textstat_frequency(ngram1Dfm)
        head(statDf)
        tail(statDf)
        
        # If number of T word types: how likely is word x to follow word y
        tWordType <- nrow(statDf)
                tWordType
        tTokens <- sum(statDf$frequency)
                tTokens
                # Then: freq (the) / tTokens
                statDf[1,2] / tTokens
                
                ngram1

# Types:
        # Nr of distinct words in a corpus

summary(myCorp)

# Tokens:
        # Total numbers of words