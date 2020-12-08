
cat(green("Running: 'dataLoad.R'\n"))

#=======================
# Data summary
#=======================
cat(green("Data summary starting\n"))
# File size
        blogsTxtSize <- file.info("./data/rawData/en_US/en_US.blogs.txt")$size/1024/1024
        newsTxtSize <- file.info("./data/rawData/en_US/en_US.news.txt")$size/1024/1024
        twitterTxtSize <- file.info("./data/rawData/en_US/en_US.twitter.txt")$size/1024/1024

# Read files
        # The readLines function is used to bring text data into the R workspace. 
        # It is especially useful when your data is in a non-standard format. 
        # The readLines function stores data as a character vector, a basic data structure that contains data of 
        # the same type; each line of the input data is an element of the vector.
        
        # It works better than read.table that I tried to use, but stopped using 
        
        connect <- file("./data/rawData/en_US/en_US.blogs.txt", "r")
        blogsLines <- readLines(connect, encoding = "UTF-8", skipNul = TRUE)  # This creates a char vect, every line is a string in this vect
        close(connect)
        
        # connect <- file("./data/rawData/en_US/en_US.news.txt", "r")
        # newsLines1 <- readLines(connect, encoding = "UTF-8", skipNul = TRUE)
        # close(connect)
                # Not displayed because warning displayed : incomplete line found
                      # Connection should be opened in binary mode
                connect <- file("./data/rawData/en_US/en_US.news.txt", "rb")
                newsLines <- readLines(connect, encoding = "UTF-8", skipNul = TRUE)
                close(connect)
                
                # Compare both files size
                        sum(nchar(newsLines, "bytes"))
                        # sum(nchar(newsLines1, "bytes"))
                
                # Conclusion:
                # The original txt file is 196.2775, that means that reading in binary mode should be chosen (rb instead of r)
               
        connect <- file("./data/rawData/en_US/en_US.twitter.txt", "r")
        twitterLines <- readLines(connect, encoding = "UTF-8", skipNul = TRUE)
        close(connect)
 
        cat(green("Data loaded\n"))
        
# Nr of lines
        blogsLinesNr <- length(blogsLines)
        newsLinesNr <- length(newsLines)
        twitterLinesNr <- length(twitterLines)
        
# Length of the longest lines
        # Create another vect with nr char in vector
        blogsCharNr <- nchar(blogsLines)
        newsCharNr <- nchar(newsLines)
        twitterCharNr <- nchar(twitterLines)
        
        blogsCharMax <- max(blogsCharNr)
        newsCharMax <- max(newsCharNr)
        twitterCharMax <- max(twitterCharNr)
        
# Word count
        # Create another vect with nr of word in vector
        blogsWordNr <- stri_count_words(blogsLines)
        newsWordNr <- stri_count_words(newsLines)
        twitterWordNr <- stri_count_words(twitterLines)
        
        # Sum
        blogsWordSum <- sum(blogsWordNr)
        newsWordSum <- sum(newsWordNr)
        twitterWordSum <- sum(twitterWordNr)
        
# Mean
        blogsWordMean <- mean(blogsWordNr)
        newsWordMean <- mean(newsWordNr)
        twitterWordMean <- mean(twitterWordNr)
        
# Median
        blogsWordMedian <- median(blogsWordNr)
        newsWordMedian <- median(newsWordNr)
        twitterWordMedian <- median(twitterWordNr)
        
# Summary
        fileSummary <- data.frame(
          c(blogsTxtSize, newsTxtSize, twitterTxtSize),
          c(blogsLinesNr, newsLinesNr, twitterLinesNr ), 
          c(blogsCharMax, newsCharMax, twitterCharMax), 
          c(blogsWordSum, newsWordSum, twitterWordSum),
          c(blogsWordMean, newsWordMean, twitterWordMean),
          c(blogsWordMedian, newsWordMedian, twitterWordMedian)
        )
        
        rownames(fileSummary) <- c("Blogs", "News", "Twitts")
        colnames(fileSummary) <- c("TxtSize(MB)", "LinesNr", "Maxchar", "WordSum", "WordMean", "WordMedian")

        cat(green("Raw data summary:\n"))
        print(fileSummary)
        rm(blogsCharMax, blogsCharNr, blogsLinesNr, blogsTxtSize, blogsWordMean, blogsWordMedian,
           blogsWordNr, blogsWordSum, connect, newsCharNr, newsLinesNr, newsTxtSize, newsWordMean, newsWordMedian, 
           newsWordNr, newsWordSum, twitterCharMax, twitterCharNr, twitterLinesNr, twitterTxtSize, 
           twitterWordMean, twitterWordMedian, twitterWordNr, twitterWordSum, newsCharMax)

#=======================
# DataFrame creation
#=======================
        # This ease the cleaning process and subsequent transfo into a quanteda corpus format
                # It takes some times, this why they are saved and called in RDS format
                        # blogsDf <- data.frame(as.character(blogsLines))  # system.time : approximately 468
                        # newsDf <- data.frame(as.character(newsLines)) # without char ->  elapsed time 170, with as.char -> 157 
                        # twitterDf <- data.frame(as.character(twitterLines))
                        # 
                        # saveRDS(blogsDf, "./data/processedData/blogsDf.RDS" )
                        # saveRDS(newsDf, "./data/processedData/newsDf.RDS" )
                        # saveRDS(twitterDf, "./data/processedData/twitterDf.RDS")
        
        cat(green("Data frames called from processed file\n"))
        
        blogsDf <- readRDS("./data/processedData/blogsDf.RDS")
        newsDf <- readRDS("./data/processedData/newsDf.RDS")
        twitterDf <- readRDS("./data/processedData/twitterDf.RDS")
        
#=======================
# Clean data
#=======================

        blogsDf <- blogsDf %>% 
                rename(text = as.character.blogsLines.) %>%
                mutate(text = as.character(text)) %>%
                mutate(text = stri_replace_all_regex(text, '\"', '')) %>% # use stringi because much faster than gsub   
                mutate(doc_id = "enBlogs") %>%
                mutate(type = "blogs")
        
        newsDf <- newsDf %>% 
                rename(text = as.character.newsLines.) %>%
                mutate(text = as.character(text)) %>%         
                mutate(text = stri_replace_all_regex(text, '\"', '')) %>%
                mutate(doc_id = "enUSNews") %>%
                mutate(type = "news")
        
        twitterDf <- twitterDf %>%
                rename(text = as.character.twitterLines.) %>%
                mutate(text = as.character(text)) %>%            
                mutate(text = stri_replace_all_regex(text, '\"', '')) %>%
                mutate(doc_id = "enTwitts") %>%
                mutate(type = "twitts")
        
cat(green("Data frames created and cleaned\n"))        
        
        
#=======================
# Corpus creation
#=======================

        cat(green("Corpus creation\n"))
        cBlogs <- corpus(
                blogsDf,
                docid_field = "doc_id",
                text_field = "text", 
                meta = list(),
                unique_docnames = F
        )
        
        
        cNews <- corpus(
                newsDf,
                docid_field = "doc_id",
                text_field = "text", 
                meta = list(),
                unique_docnames = F
        )
        
        cTwitts <- corpus(
                twitterDf,
                docid_field = "doc_id",
                text_field = "text", 
                meta = list(),
                unique_docnames = F
        )


cat(green("Individual corpus created\n"))

        # # Check
        #         summary(cBlogs, 5)
        #         summary(cNews, 5)
        #         summary(cTwitts, 5)

# Combine 3 corpus into 1 big corpus
        cAll <- cBlogs + cNews + cTwitts
                summary(cAll)
                
cat(green("Individual corpuses merged into one large corpus 'cAll'\n"))

# Clear the deck from unneeded files
        rm(cBlogs, cNews, cTwitts)
        rm(blogsDf, newsDf, twitterDf, blogsLines, newsLines, twitterLines)
                
        # I remove the original individual base corpus to avoid mixing them later on
                # I will use subset() to work on them individually


      

        
                
        
# Questions
        # 1. 200 MB
        # 2. Over 2 mio
        # Over 40 thousand
   
        

        
