# Tokenization
        cat(green("Running: 'dataTokens.r'\n"))
        cat(green("Tokenization of the whole corpus will start\n"))
        
        # Tokenization + remove punctuation + remove emoji + numbers
        toksCAll1 <- tokens(cAll, remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove_separators = TRUE) # https://quanteda.io/reference/tokens.html
        saveRDS(toksCAll1, "./data/processedData/toksCAll1.RDS")
                # head(toksCAll1, 3)
        
        # Conver to lower case
        toksCAll2 <- tokens_tolower(toksCAll1)
        saveRDS(toksCAll2, "./data/processedData/toksCAll2.RDS")
                rm(cAll,toksCAll, toksCAll1)
                #head(toksCAll2, 3)
        
        cat(green("Tokenization done, punctuation removed, lower case applied\n"))
        gc()
                
#Removing url
        # Removing token with domain names at then end (ex: .com...)
                # It was done because the url quanteda filter left some url names, with for example namex.com with .com at the end 
                # fileUrl <- "https://data.iana.org/TLD/tlds-alpha-by-domain.txt"
                # download.file(fileUrl, destfile = "./data/rawData/domainName.txt")
        domainNamesDf <- read.table("./data/rawData/domainName.txt", sep = "\n", quote = "", header = F, colClasses = "character", encoding="UTF-8")
        
        domainNamesDf <- domainNamesDf %>%
                rename(names = V1) %>%
                mutate(names = tolower(names)) %>%
                mutate(regEx = paste0("[^ ]+(\\.", names,")$"))
                        #head(domainNamesDf)
        
                        # Correct regex with com example: "[^ ]+(\\.com)$"

        
        toksCAll3 <- tokens_remove(toksCAll2, pattern = domainNamesDf$regEx, valuetype = "regex", padding=TRUE ) # fixed for exact matching
        saveRDS(toksCAll3, "./data/processedData/toksCAll3.RDS")
                rm(toksCAll2, domainNamesDf)
                # checks:
                        # kw_domainNames <- kwic(toksCAll, pattern =  "*.com")
                        # head(kw_domainNames)
                        # head(toksCAll3, 3)
         
# Split composed tokens (example: "2.2" or "master-work") separated by a punctuation character
        # Done in a 2 steps because regEx too long
     toksCAll4 <- tokens_split(toksCAll3, separator = "[~|&|<|>|\\*|@|\\|%|[|]|\\^|:|,|-]", valuetype = "regex", remove_separator = TRUE)
                head(toksCAll4, 3)
                
        toksCAll4 <- tokens_split(toksCAll4, separator = "[°|\"|+|=|/|_|(|)|\\.|?|`|;]", valuetype = "regex", remove_separator = TRUE)
                #head(toksCAll4, 3)
        saveRDS(toksCAll4, "./data/processedData/toksCAll4.RDS")
                rm(toksCAll3)
                # head(toksCAll4, 3)
        
# Remove token with numbers into them
                # The one that arised from spliting on . or ,..
        toksCAll5 <- tokens_select(toksCAll4, pattern = "([0-9]+)", selection="remove", valuetype = "regex", padding = TRUE)
        saveRDS(toksCAll5, "./data/processedData/toksCAll5.RDS")
                rm(toksCAll4)
                # head(toksCAll5, 3)
                
# Remove dirty words
        cat(green("Clearing bad words, unsignificant words and urls in tokens\n"))
        
        # download.file('https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en',
                        # "./data/rawData/dirtyWord.txt")
                
        badWords <- read.table("./data/rawData/dirtyWord.txt", sep = "\n", quote = "", header = F, colClasses = "character", encoding="UTF-8")
        toksCAll6 <- tokens_remove(toksCAll5, pattern = badWords$V1, valuetype = "fixed", padding=TRUE ) # fixed for exact matching
        saveRDS(toksCAll6, "./data/processedData/toksCAll6.RDS")
                rm(toksCAll5, badWords)
                # head(toksCAll6, 3)
        
# Remove unsignificant words
        unsigWords <- c(
                "rt", # people type "RT" at the beginning of a Tweet to indicate that they are re-posting someone else's content.
                "g", "mg", "th", "rd", "st", "nd", "p", "m" # g for gram, mg also removed, th century: th removed
        )
        unsigWordsDf <- data.frame(unsigWords, stringsAsFactors = F) %>%
                rename(word = unsigWords)
        
        toksCAllSW <- tokens_remove(toksCAll6, pattern = unsigWordsDf$word, valuetype = "fixed", padding=TRUE ) # fixed for exact matching
                rm(toksCAll6, unsigWords, unsigWordsDf)
                # head(toksCAllSW, 3)

# Remove stop words
        # Save tokens before stop word removal for later model development if needed
        saveRDS(toksCAllSW, "./data/processedData/toksCAllSW.RDS")
        toksCAll <- tokens_remove(toksCAllSW, pattern = stopwords("en"), padding = TRUE)
                # padding = TRUE means that the lenght of doc will not be changed, position indices kept, bec word replaced with ""
        saveRDS(toksCAll, "./data/processedData/toksCAll.RDS")
                # head(toksCAll, 3)


#==========================        
# Subset toksCAll for later use (analyse waged at 4 level: all and on each of the 3 blogs, news, twitts)
#========================== 
# tokens_subset        
        
        toksCBlogs <- tokens_subset(toksCAll, type == "blogs")
        saveRDS(toksCBlogs, "./data/processedData/toksCBlogs.RDS")
                # head(toksCBlogs, 3)
                rm(toksCBlogs)
        
        toksCNews <- tokens_subset(toksCAll, type == "news")
        saveRDS(toksCNews, "./data/processedData/toksCNews.RDS")
                # head(toksCNews, 3)
                rm(toksCNews)
        
        toksCTwitts <- tokens_subset(toksCAll, type == "twitts")
        saveRDS(toksCTwitts, "./data/processedData/toksCTwitts.RDS")
                # head(toksCTwitts, 3)
                rm(toksCTwitts)
                
# tokens_subset (with stopword)        

        toksCBlogsSW <- tokens_subset(toksCAllSW, type == "blogs")
        saveRDS(toksCBlogsSW, "./data/processedData/toksCBlogsSW.RDS")
                # head(toksCBlogsSW, 3)
                rm(toksCBlogsSW)        
        
        toksCNewsSW <- tokens_subset(toksCAllSW, type == "news")
        saveRDS(toksCNewsSW, "./data/processedData/toksCNewsSW.RDS")
                # head(toksCNewsSW, 3)
                rm(toksCNewsSW)
                
        toksCTwittsSW <- tokens_subset(toksCAllSW, type == "twitts")
        saveRDS(toksCTwittsSW, "./data/processedData/toksCTwittsSW.RDS")
                # head(toksCTwittsSW, 3)
                rm(toksCTwittsSW)


        