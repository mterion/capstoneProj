        wordsSW50Df <- readRDS("./data/processedData/wordsSW50Df.RDS")
        wordsSW60Df <- readRDS("./data/processedData/wordsSW60Df.RDS")
        wordsSW70Df <- readRDS("./data/processedData/wordsSW70Df.RDS")
        wordsSW80Df <- readRDS("./data/processedData/wordsSW80Df.RDS") 
        wordsSW85Df <- readRDS("./data/processedData/wordsSW85Df.RDS") # should use this one
        wordsSW90Df <- readRDS("./data/processedData/wordsSW90Df.RDS")



# function getWordOnLetters recorded into functions file



system.time(getWordOnLetters("al", wordsSW50Df)) # 0.02 sec for 138 words
system.time(getWordOnLetters("al", wordsSW60Df)) # 0 sec for 366 words
system.time(getWordOnLetters("al", wordsSW70Df)) # 0 sec for 941 words
system.time(getWordOnLetters("al", wordsSW80Df)) # 0 sec for 2448 words
system.time(getWordOnLetters("al", wordsSW85Df)) # 0.01 sec for 4184 words
system.time(getWordOnLetters("al", wordsSW90Df)) # 0.04 sec for 7905 words

        # Concl: 
                # The time mainly depend on whether he finds 3 results or not
                        # If ony find 2, then the time increase
                        # If finds 3 and moves beyond 85, increase

        # Conclusion: should use 85
