cat(green("Running: 'inspectCorpus.R'\n"))

#=======================
# Document level variables
#=======================


# Document level variables
        head(docvars(cAll))
        
# Inspect var
        print(table(cAll$type))
                
# Subset corpus based on doc level var
        # ndoc(cAll)
        # 
        # cNews <- corpus_subset(cAll, type %in% "news")
        # ndoc(cNews)
        # 
# Tokenization
        
        cat(green("Tokenization of the whole corpus will start\n"))
        
        # Tokenization + remove punctuation
        toksCAll <- tokens(cAll, remove_punct = TRUE)
        
        # Check
                #head(toksCAll)

        cat(green("Tokenization done and punctuation removed\n"))


        
# Select tokens
        # Remove stop words
                # toksNoStop1 <- tokens_select(toksCAll, pattern = stopwords("en"), selection = "remove")
        
                # Is the same as (but keep the position indices)
                toksCAll1 <- tokens_remove(toksCAll, pattern = stopwords("en"), padding = TRUE)
                        # padding = TRUE means that the lenght of doc will not be changed
                # Show
                head(toksNoStop1)       # Position index not kept
                head(toksNoStop2)       # Position indices kept, bec word replaced with ""
                tail(toksNoStop)        # ... the last
                
                        # print()       # Careful, could print the whole!
                
        # Remove dirty words
                # Bad words
                        # download.file('https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en',
                        # "./data/rawData/dirtyWord.txt")
                
                badWords <- read.table("./data/rawData/dirtyWord.txt", sep = "\n", quote = "", header = F, colClasses = "character", encoding="UTF-8")
                
                
        
        # Keep only certain word
        toksWordSel <- tokens_select(toksCAll, pattern = c("worker"), padding = TRUE)
                
                # Show (but this keep the whole set of doc, even if empty!)
                        #head(toksWordSel)
        
        # To analyze worlds around keyword
        toksWindSel <- tokens_select(toksCAll, pattern = "worker", padding = TRUE, window = 5)
                
                # Show
                head(toksWindSel)
        
        # Regular expression:
                # Can be used: see ?pattern
                # See regularExpression Cheatsheet
                
                
# Keyword in context
        # Single kw
                # can also use * for ex: "viol*" 
        kwViolence <- kwic(toksCAll, pattern = "violence")
        
        # Visualization: the best is to clik on it in the data environment to be displayed in the viewer
        head(kwViolence)
        
        # Multiple kw
        kmViolWorker <- kwic(toksCAll, pattern= c("violence", "worker"))
                # But it seems that it makes OR and not AND bec it adds up both
        
        # Window -> nr of word betw keywords
        kmViolWorkWind <- kwic(toksCAll, pattern= c("violence", "worker"), window = 2)
                # Does not seem to work always the same result
        
        # Phrase
        kmPhrase <- kwic(toksCAll, pattern= phrase("Laudan Taiby"))
        
        # With a dictionary
        download.file('https://raw.githubusercontent.com/quanteda/tutorials.quanteda.io/master/content/dictionary/newsmap.yml', './data/rawData/newsmap.yml')
        
        dict_newsmap <- dictionary(file = "./data/rawData/newsmap.yml")
        
        kmAfrica <- kwic(toksCAll, dict_newsmap["AFRICA"])
        head(kmAfrica)
        
# Look up dictionary
        toksAllCountry <- tokens_lookup(toksCAll, dictionary = dict_newsmap, levels = 3)
        head(toksAllCountry)
        dfm(toksAllCountry)

       
                