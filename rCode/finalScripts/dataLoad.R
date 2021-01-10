
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
        cat(green("Data summary calculations and plots\n"))
        blogsLinesNr <- length(blogsLines)
        newsLinesNr <- length(newsLines)
        twitterLinesNr <- length(twitterLines)
        nrOfLinesTotal <-  sum(blogsLinesNr,newsLinesNr,twitterLinesNr)
                saveRDS(nrOfLinesTotal, "./figures/finalFigures/nrOfLinesTotal.RDS")
        
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
        nrOfWordsTotal <- sum(blogsWordNr,newsWordNr,twitterWordNr)
                saveRDS(nrOfWordsTotal, "./figures/finalFigures/nrOfWordsTotal.RDS")
        
        # Plot
                #Make df
                blogsWordNrDf <- data.frame(blogsWordNr) %>%
                              rename(nr = blogsWordNr) %>%
                              mutate(type = "Blogs")
                newsWordNrDf <- data.frame(newsWordNr) %>%
                              rename(nr = newsWordNr) %>%
                              mutate(type = "News")
                twitterWordNrDf <- data.frame(twitterWordNr) %>%
                              rename(nr = twitterWordNr) %>%
                              mutate(type = "Tweets")
                head(blogsWordNrDf); head(newsWordNrDf); head(twitterWordNrDf)
                
                # Merge 3 df into 1 df with cols: nr and type
                wordNrDf <- rbind(blogsWordNrDf, newsWordNrDf, twitterWordNrDf) %>%
                  mutate(type = as.factor(type))
                
                rm(blogsWordNrDf, newsWordNrDf, twitterWordNrDf)
                        #table(wordNrDf$type)
                
        # Facets histogram plot
                histWordCount <- ggplot(data=wordNrDf, aes(x = nr, fill = type)) +
                          scale_fill_manual(values=c("steelblue", "salmon", "seagreen")) +
                          geom_histogram(
                            breaks= seq(0, 180, by=1)) +
                          labs(
                            title = "Word Count",
                            x = "Number of words"
                            ) +
                          scale_y_continuous(name = "Frequency", labels = scales::number) +
                          theme(plot.title = element_text(hjust = 0.5, size = 15)) +
                                theme(legend.title = element_text(face = "bold")) +
                         facet_wrap(~type) +
                        theme(plot.margin=unit(c(0.5,0,0.5,0),"cm")) +
                         theme(legend.position = "none")
                #print(histWordCount)
                histWordCount <- ggplotly(histWordCount)
                print(histWordCount)
                saveRDS(histWordCount, "./figures/finalFigures/histWordCount.RDS")
             
        # Violin plot
                violinWordCount <- ggplot(data=wordNrDf, aes(x = type, y = nr)) +
                  geom_violin(
                    aes(fill = type), alpha = 0.9
                    ) +
                  scale_fill_manual(values=c("steelblue", "salmon", "seagreen")) +
                  coord_cartesian(ylim = c(0,150)) + #coor_cart is a simple zoom, it won't chang the data setting limits on a scale as well, so it won't change the mean/median stat
                  geom_boxplot(width=0.1) +
                  labs(
                    fill = "Type",
                    # title = "Distributions with medians and quartiles",
                    x = "",
                    y = "Frequency"
                  ) +
                  # theme(plot.title = element_text(hjust = 0.5, size = 15)) +
                  theme(legend.position = "none")
                #print(violinWordCount)
                violinWordCount <- ggplotly(violinWordCount)
                print(violinWordCount)
                saveRDS(violinWordCount, "./figures/finalFigures/violinWordCount.RDS")
              
# Word Sum
        blogsWordSum <- sum(blogsWordNr)
        newsWordSum <- sum(newsWordNr)
        twitterWordSum <- sum(twitterWordNr)
        
# Word max
        blogsWordMax <- max(blogsWordNr)
        newsWordMax <- max(newsWordNr)
        twitterWordMax <- max(twitterWordNr)
        
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
          c("Blogs", "News", "Twitts"),
          c(blogsTxtSize, newsTxtSize, twitterTxtSize),
          c(blogsLinesNr, newsLinesNr, twitterLinesNr ), 
          c(blogsCharMax, newsCharMax, twitterCharMax), 
          c(blogsWordSum, newsWordSum, twitterWordSum),
          c(blogsWordMax, newsWordMax, twitterWordMax),
          c(blogsWordMean, newsWordMean, twitterWordMean),
          c(blogsWordMedian, newsWordMedian, twitterWordMedian)
        ) 
        
        rownames(fileSummary) <- c("Blogs", "News", "Twitts")
        colnames(fileSummary) <- c("Source", "TxtSizeMB", "LinesNr", "Maxchar", "WordSum", "WordMax", "WordMean", "WordMedian")

        fileSummary <- fileSummary %>%
          mutate(TxtSizeMB = round(TxtSizeMB, 0)) %>%
          mutate(WordMean = round(WordMean, 1)) %>%
          mutate(Source = as.character(Source))
        cat(green("Raw data summary:\n"))

        
        rm(blogsCharMax, blogsCharNr, blogsLinesNr, blogsTxtSize, blogsWordMean, blogsWordMedian,
           blogsWordNr, blogsWordSum, connect, newsCharNr, newsLinesNr, newsTxtSize, newsWordMean, newsWordMedian, 
           newsWordNr, newsWordSum, twitterCharMax, twitterCharNr, twitterLinesNr, twitterTxtSize, 
           twitterWordMean, twitterWordMedian, twitterWordNr, twitterWordSum, newsCharMax,
           blogsWordMax, newsWordMax, twitterWordMax, histWordCount, violinWordCount, wordNrDf)

# Plotly table
         rgbChartreuse2 <- "rgb(118,238,0)"
         colorHeader <- rgbChartreuse2
        
        fileSummaryTable <- plot_ly(
              type = 'table',
              columnwidth = c(50,50,50,50,50,50,50,50),
              columnorder = c(1,2,3,4,5,6,7,8),
              header = list(
                values = c("File Sources", "File Size (MB)","Number of Doc.", "Number of Words", "Max. Characters per Doc.",  "Max. Words per Doc.", "Mean Words per Doc.", "Median Words per Doc."),
                align = c("center", "center", "center", "center", "center", "center", "center", "center"),
                line = list(width = 1, color = 'black'),
                fill = list(color = c("grey", "grey")),
                font = list(family = "Arial", size = 14, color = "white")
              ),
              cells = list(
                values = rbind(fileSummary$Source, fileSummary$TxtSizeMB, fileSummary$LinesNr, fileSummary$WordSum, fileSummary$Maxchar,  fileSummary$WordMax, fileSummary$WordMean, fileSummary$WordMedian),
                align = c("center", "center", "center", "center", "center", "center", "center", "center"),
                line = list(color = "black", width = 1),
                font = list(family = "Arial", size = 12, color = c("black"))
              ))
            
        # fileSummaryTable
        # fig <- fileSummaryTable %>% layout(autosize = T)
        
        print(fileSummaryTable)
        saveRDS(fileSummaryTable, "./figures/finalFigures/fSumTable.RDS")
        rm(fileSummary, fileSummaryTable, colorHeader, rgbChartreuse2, nrOfLinesTotal)
        
        
       
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

        # Remove twitter abbreviations before tokenization
                # If not, the removal of punctuation during tokenization will hinder the detection of twitter abbrevations
        twitterAbbrRegEx <-tolower("\\b(
                CC|CX|CT|DM|HT|MT|PRT|RT|EM|EZine|FB|LI|SEO|SM|SMM|SMO|SN|SROI|UGC|YT|AB|ABT|AFAIK|AYFKMWTS|
                B4|BFN|BGD|BH|BR|BTW|CD9|CHK|CUL8R|DAM|DD|DF|DP|DS|DYK|EM|EML|EMA|F2F|FTF|FB|FF|FFS|FM|FOTD|
                FTW|FUBAR|FWIW|GMAFB|GTFOOH|GTS|HAGN|HAND|HOTD|HT|HTH|IC|ICYMI|IDK|IIRC|IMHO|IR|IWSN|JK|JSYK|JV|KK|
                KYSO|LHH|LMAO|LMK|LO|LOL|MM|MIRL|MRJN|NBD|NCT|NFW|NJoy|NSFW|NTS|OH|OMFG|OOMF|ORLY|PLMK|PNP|QOTD|RE|
                RLRT|RTFM|RTQ|SFW|SMDH|SMH|SNAFU|SO|SOB|SRS|STFU|STFW|TFTF|TFTT|TJ|TL|TLDR|TL;DR|TMB|TT|TY|TYIA|TYT|
                TYVW|W/E|W/|W|WE|WTV|YGTR|YKWIM|YKYAT|YMMV|YOLO|YOYO|YW|ZOMG|
                #BrandChat|#CMAD|#CMGR|#FB|#FF|#in|#LI|#LinkedInChat|#Mmchat|#Pinchat|#SMManners|#SMMeasure|#SMOchat|#SocialChat|#SocialMedia
                )\\b")
        
# Df with train-valid-test partition
        blogsDf <- blogsDf %>% 
                rename(text = as.character.blogsLines.) %>%
                mutate(text = as.character(text)) %>%
                mutate(text = tolower(text)) %>%
                mutate(text = stri_replace_all_regex(text, twitterAbbrRegEx , "")) %>% 
                mutate(doc_id = "enBlogs") %>%
                mutate(type = "blogs") %>%
                mutate(typeIdNr = row_number()) %>%
                mutate(trainTestSet = case_when(
                        typeIdNr < round(nrow(blogsDf) * 0.8) ~ "train",
                        TRUE ~ "test")) %>% # equivalent to else
                mutate(trainValidTestSet = case_when(
                        typeIdNr < round(length(which(trainTestSet == "train")) * 0.8) ~ "train",
                        typeIdNr >= round(length(which(trainTestSet == "train")) * 0.8) & trainTestSet == "train" ~ "valid",
                        TRUE ~ "test"))
        
        newsDf <- newsDf %>% 
                rename(text = as.character.newsLines.) %>%
                mutate(text = as.character(text)) %>%
                mutate(text = tolower(text)) %>%
                mutate(text = stri_replace_all_regex(text, twitterAbbrRegEx , "")) %>% 
                mutate(doc_id = "enUSNews") %>%
                mutate(type = "news")%>%
                mutate(typeIdNr = row_number()) %>%
                mutate(trainTestSet = case_when(
                        typeIdNr < round(nrow(newsDf) * 0.8) ~ "train",
                        TRUE ~ "test")) %>% # equivalent to else
                mutate(trainValidTestSet = case_when(
                        typeIdNr < round(length(which(trainTestSet == "train")) * 0.8) ~ "train",
                        typeIdNr >= round(length(which(trainTestSet == "train")) * 0.8) & trainTestSet == "train" ~ "valid",
                        TRUE ~ "test"))
        
        twitterDf <- twitterDf %>%
                rename(text = as.character.twitterLines.) %>%
                mutate(text = as.character(text)) %>%
                mutate(text = tolower(text)) %>%
                mutate(text = stri_replace_all_regex(text, twitterAbbrRegEx , "")) %>% 
                mutate(doc_id = "enTwitts") %>%
                mutate(type = "twitts")%>%
                mutate(typeIdNr = row_number()) %>%
                mutate(trainTestSet = case_when(
                        typeIdNr < round(nrow(twitterDf) * 0.8) ~ "train",
                        TRUE ~ "test")) %>% # equivalent to else
                mutate(trainValidTestSet = case_when(
                        typeIdNr < round(length(which(trainTestSet == "train")) * 0.8) ~ "train",
                        typeIdNr >= round(length(which(trainTestSet == "train")) * 0.8) & trainTestSet == "train" ~ "valid",
                        TRUE ~ "test"))
        
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
        saveRDS(cAll, "./data/processedData/cAll.RDS")
                
cat(green("Individual corpuses merged into one large corpus 'cAll'\n"))

# Clear the deck from unneeded files
        rm(cBlogs, cNews, cTwitts, nrOfWordsTotal)
        rm(blogsDf, newsDf, twitterDf, blogsLines, newsLines, twitterLines)
                
        # I remove the original individual base corpus to avoid mixing them later on
                # I will use subset() to work on them individually


# Check train/valid/test sets
        # trainCAll <- length(which(cAll$trainTestSet == "train"))
        # testCAll <- length(which(cAll$trainTestSet == "test"))
        # trainCAll + testCAll == ndoc(cAll)
        #        
        # trainCAll <- length(which(cAll$trainValidTestSet == "train"))
        # validCAll <- length(which(cAll$trainValidTestSet == "valid"))
        # testCAll <- length(which(cAll$trainValidTestSet == "test"))
        # trainCAll + + validCAll + testCAll == ndoc(cAll)
        # 
        
   
        

        
