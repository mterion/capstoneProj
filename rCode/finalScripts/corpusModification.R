cAll <- readRDS("./data/processedData/cAll.RDS")


# Tokenization
        cat(green("Running: 'corpusModification.r'\n"))
        cat(green("Tokenization of the whole corpus will start\n"))
        
        # Tokenization + remove punctuation
        toksCAll <- tokens(cAll, remove_punct = TRUE)
        
        # Check
                #head(toksCAll)

        cat(green("Tokenization done and punctuation removed\n"))
        
# Remove stop words
        toksCAll1 <- tokens_remove(toksCAll, pattern = stopwords("en"), padding = TRUE)
                # padding = TRUE means that the lenght of doc will not be changed
        # Show
        head(toksCAll1)       # Position indices kept, bec word replaced with ""
                
# Remove dirty words

        # download.file('https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en',
                        # "./data/rawData/dirtyWord.txt")
                
        badWords <- read.table("./data/rawData/dirtyWord.txt", sep = "\n", quote = "", header = F, colClasses = "character", encoding="UTF-8")
        toksCAll2 <- tokens_remove(toksCAll1, pattern = badWords$V1, valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        head(toksCAll2)
        