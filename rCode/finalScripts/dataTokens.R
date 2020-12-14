# Tokenization
        cat(green("Running: 'dataTokens.r'\n"))
        cat(green("Tokenization of the whole corpus will start\n"))
        
        # Tokenization + remove punctuation + remove emoji + numbers
                # Individual characters like # or other are removed before creating the corpus, in the individual Df (see dataLoad)
        toksCAll <- tokens(cAll, remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE) # https://quanteda.io/reference/tokens.html 
        
        # Check
                #head(toksCAll)

        cat(green("Tokenization done and punctuation removed\n"))
        
# Remove stop words
        toksCAll <- tokens_remove(toksCAll, pattern = stopwords("en"), padding = TRUE)
                # padding = TRUE means that the lenght of doc will not be changed
        
                # check
                # head(toksCAll)       # Position indices kept, bec word replaced with ""
                
# Remove dirty words

        # download.file('https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en',
                        # "./data/rawData/dirtyWord.txt")
                
        badWords <- read.table("./data/rawData/dirtyWord.txt", sep = "\n", quote = "", header = F, colClasses = "character", encoding="UTF-8")
        toksCAll <- tokens_remove(toksCAll, pattern = badWords$V1, valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        rm(badWords)
        
# Remove unsignificant words
        unsigWords <- c(
                "rt", # people type "RT" at the beginning of a Tweet to indicate that they are re-posting someone else's content.
                ">", "<", "=", "~", "#"
        )
        unsigWordsDf <- data.frame(unsigWords, stringsAsFactors = F) %>%
                rename(word = unsigWords)
        
        toksCAll <- tokens_remove(toksCAll, pattern = unsigWordsDf$word, valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        rm(unsigWords, unsigWordsDf)

# Subset toksCAll for later use (analyse waged at 4 level: all and on each of the 3 blogs, news, twitts)       