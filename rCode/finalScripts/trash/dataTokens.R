cat(green("Running: 'dataTokens.R'\n"))

#=======================
# Document level variables
#=======================


# Document level variables
        head(docvars(cAll))
        
# Inspect var
        print(table(cAll$type))
                
# Subset corpus based on doc level var type
        ndoc(cAll)
        # 
        # cBlogs <- corpus_subset(cAll, type %in% "blogs")
        # cNews <- corpus_subset(cAll, type %in% "news")
        # cTwitts <- corpus_subset(cAll, type %in% "twitts")
        # ndoc(cNews)
        
# Tokenization
        
        cat(green("Tokenization of the whole corpus will start\n"))
        
        # Tokenization + remove punctuation
        toksCAll <- tokens(cAll, remove_punct = TRUE)

        # Check
                #head(toksCAll)
                #head(docvars(toksCAll)))

        cat(green("Tokenization done and punctuation removed\n"))
                

# Select tokens
        # Remove stop words
                # toksNoStop1 <- tokens_select(toksCAll, pattern = stopwords("en"), selection = "remove")
        
                # Is the same as (but keep the position indices)
                toksCAll <- tokens_remove(toksCAll, pattern = stopwords("en"), padding = TRUE)
                        # padding = TRUE means that the lenght of doc will not be changed
                # Show
                # head(toksNoStop1)       # Position index not kept
                # head(toksNoStop2)       # Position indices kept, bec word replaced with ""
                # tail(toksNoStop)        # ... the last
                
                        # print()       # Careful, could print the whole!
                
        # Remove dirty words
                # Bad words
                        # download.file('https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en',
                        # "./data/rawData/dirtyWord.txt")
                
                badWords <- read.table("./data/rawData/dirtyWord.txt", sep = "\n", quote = "", header = F, colClasses = "character", encoding="UTF-8")
                
                cat(green("Stop words and dirty words removed\n"))
                
        # Lowercase tokens
                toksCAll <- tokens_tolower(toksCAll)
                cat(green("Tokens converted to lower case\n"))

# Quiz:       
        # Divide the number of lines where the word "love" (all lowercase) occurs by the number of lines the word "hate" (all lowercase) occurs, about what do you get?
        # Keyword search:
                kwLove <- kwic(toksCAll, pattern = "love")
                kwHate <- kwic(toksCAll, pattern = "hate")
                
                table(kwLove$pattern)
                table(kwHate$pattern)
                
                linesNrLove <- length(kwLove$docname)
                linesNrHate <- length(kwHate$docname)
                linesNrLove / linesNrHate
                # Problem with this approach is that it takes all instances of the word
                        # Then the doc is cited twice if twice the word in the document
                        # Also need to focus just on the subset twitter
                        # This kind of processing is easier to do from r at the begining with readLines (see dataLoad file)
                
                kwLove <- kwic(toksCAll, pattern = "love" & cAll$type %in% "blogs")
                kwHate <- kwic(toksCAll, pattern = "hate")
                
                linesNrLoveUnique <-length(unique(kwLove$docname))
                linesNrHateUnique <- length(unique(kwHate$docname))
                linesNrLoveUnique / linesNrHateUnique
                
                cAll$type %in% "blogs"
                

                
                kwLoveRegEx <- kwic(toksCAll, phrase("love"), valuetype = "regex")
                kwHateRegEx <- kwic(toksCAll, phrase("hate"), valuetype = "regex")
                kwHateRegEx$keyword
                

                

       
                