 # Keep only certain word
        toksWordSel <- tokens_select(toksCAll, pattern = c("worker"), padding = TRUE)
                
                # Show (but this keep the whole set of doc, even if empty!)
                head(toksWordSel)
        
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
