# Tokenization
        cat(green("Running: 'dataTokens.r'\n"))
        cat(green("Tokenization of the whole corpus will start\n"))
        
        # Tokenization + remove punctuation + remove emoji + numbers
                # Individual characters like # or other are removed before creating the corpus, in the individual Df (see dataLoad)
        toksCAll <- tokens(cAll, remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove_separators = TRUE) # https://quanteda.io/reference/tokens.html
        
        # Conver to lower case
        toksCAll <- tokens_tolower(toksCAll)
        
        # Check
                #head(toksCAll)

        cat(green("Tokenization done, punctuation removed, lower case applied\n"))
        
# Remove stop words
        toksCAll <- tokens_remove(toksCAll, pattern = stopwords("en"), padding = TRUE)
                # padding = TRUE means that the lenght of doc will not be changed, position indices kept, bec word replaced with ""
        
                # check
                # head(toksCAll)       
                
# Remove dirty words
        cat(green("Clearing bad words, unsignificant words and urls in tokens\n"))
        
        # download.file('https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en',
                        # "./data/rawData/dirtyWord.txt")
                
        badWords <- read.table("./data/rawData/dirtyWord.txt", sep = "\n", quote = "", header = F, colClasses = "character", encoding="UTF-8")
        toksCAll <- tokens_remove(toksCAll, pattern = badWords$V1, valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        rm(badWords)
        
# Remove unsignificant words
        unsigWords <- c(
                "rt", # people type "RT" at the beginning of a Tweet to indicate that they are re-posting someone else's content.
                ">", "<", "=", "~", "#", "g", "mg", "th", "rd", "st", "nd" # g for gram, mg also removed, th century: th removed
        )
        unsigWordsDf <- data.frame(unsigWords, stringsAsFactors = F) %>%
                rename(word = unsigWords)
        
        toksCAll <- tokens_remove(toksCAll, pattern = unsigWordsDf$word, valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        rm(unsigWords, unsigWordsDf)

#Removing url
        # Removing token with domain names at then end (ex: .com...)
                # It was done because the url quanteda filter left some url names, with for example namex.com with .com at the end 
                # fileUrl <- "https://data.iana.org/TLD/tlds-alpha-by-domain.txt"
                # download.file(fileUrl, destfile = "./data/rawData/domainName.txt")
        domainNamesDf <- read.table("./data/rawData/domainName.txt", sep = "\n", quote = "", header = F, colClasses = "character", encoding="UTF-8")
        
        domainNamesDf <- domainNamesDf %>%
                rename(names = V1) %>%
                mutate(names = tolower(names)) %>%
                mutate(regEx = paste0("(.*).", names,"$"))
                        #head(domainNamesDf)
        
        toksCAll <- tokens_remove(toksCAll, pattern = domainNamesDf$regEx, valuetype = "regex", padding=TRUE ) # fixed for exact matching
                # checks:
                        # kw_domainNames <- kwic(toksCAll, pattern =  "*.com")
                        # head(kw_domainNames)
                        # kw_domainNames1 <- kwic(toksCAll1, pattern =  "*.com")
                        # head(kw_domainNames1)
         rm(domainNamesDf)              
        
#==========================        
# Subset toksCAll for later use (analyse waged at 4 level: all and on each of the 3 blogs, news, twitts)
#========================== 
# tokens_subset        
        
        toksCBlogs <- tokens_subset(toksCAll, type == "blogs")
        toksCNews <- tokens_subset(toksCAll, type == "news")
        toksCTwitts <- tokens_subset(toksCAll, type == "twitts")
                # head(toksCAll); head(toksCBlogs); head(toksCNews); head(toksCTwitts);
        


        