#===================================================
# nGrams tables    
#===================================================

# Garbage collection
        # Reallocate space
        gc()

# N-Grams
        cat(green("Running: 'dataDFM.r'\n"))
        cat(green("Creation of n-grams pannel plots\n"))
        
# Lower case
        # I decided to leave upper case letter to improve model accuracy
        

        
# Pannel plot for 15 top features n-gram X
        # Chose n-gram 1, 2 and 3
        
        pannelFeatPlotNGram1 <- nGramPlotFun(nGram =1, titleNGramPannelPlot <- "15 Top Features: n-grams 1", marginPannelPlot = 0.1)
        pannelFeatPlotNGram2 <- nGramPlotFun(nGram =2, titleNGramPannelPlot <- "15 Top Features: n-grams 2", marginPannelPlot = 0.1)
        pannelFeatPlotNGram3 <- nGramPlotFun(nGram =3, titleNGramPannelPlot <- "15 Top Features: n-grams 3", marginPannelPlot = 0.15)
        
        print(pannelFeatPlotNGram1)
        print(pannelFeatPlotNGram2)
        print(pannelFeatPlotNGram3)
        
        saveRDS(pannelFeatPlotNGram1, "./figures/finalFigures/pannelFeatPlotNGram1.RDS")
        saveRDS(pannelFeatPlotNGram2, "./figures/finalFigures/pannelFeatPlotNGram2.RDS")
        saveRDS(pannelFeatPlotNGram3, "./figures/finalFigures/pannelFeatPlotNGram3.RDS")

        rm(pannelFeatPlotNGram1, pannelFeatPlotNGram2, pannelFeatPlotNGram3)

# Create nGram tables : NO PUNCTUATION
        toksCAll <- readRDS("./data/processedData/toksCAll.RDS")  
        toksCBlogs <- readRDS("./data/processedData/toksCBlogs.RDS")
        toksCNews <- readRDS("./data/processedData/toksCNews.RDS")
        toksCTwitts <- readRDS("./data/processedData/toksCTwitts.RDS")
        
        
        # Saved directly in the fun
        cat(green("Creation of tables for n-grams 1\n"))
        nGramTableFun(tokenDataAll =  toksCAll, tokenDataBlogs = toksCBlogs , tokenDataNews = toksCNews, tokenDataTwits = toksCTwitts, nGram = 1, maxTableRows = 5001)
        
        cat(green("Creation of tables for n-grams 2\n"))
        nGramTableFun(tokenDataAll =  toksCAll, tokenDataBlogs = toksCBlogs , tokenDataNews = toksCNews, tokenDataTwits = toksCTwitts, nGram = 2, maxTableRows = 5001)
        
        cat(green("Creation of tables for n-grams 3\n"))
        nGramTableFun(tokenDataAll =  toksCAll, tokenDataBlogs = toksCBlogs , tokenDataNews = toksCNews, tokenDataTwits = toksCTwitts, nGram = 3, maxTableRows = 5001)

        rm(toksCBlogs, toksCNews, toksCTwitts)
        
# Create nGram tables : WITH STWOPWORDS
        memory.limit()
        memory.limit(30000)
        
        toksCAllSW <- readRDS("./data/processedData/toksCAllSW.RDS")        
        toksCBlogsSW <- readRDS("./data/processedData/toksCBlogsSW.RDS")
        toksCNewsSW <- readRDS("./data/processedData/toksCNewsSW.RDS")
        toksCTwittsSW <- readRDS("./data/processedData/toksCTwittsSW.RDS")
        
        # Saved directly in the fun
        cat(green("Creation of tables for n-grams 1\n"))
        nGramTableFun(tokenDataAll =  toksCAllSW, tokenDataBlogs = toksCBlogsSW , tokenDataNews = toksCNewsSW, tokenDataTwits = toksCTwittsSW, nGram = 1, maxTableRows = 5001, typeData = "SW")
        
        cat(green("Creation of tables for n-grams 2\n"))
        nGramTableFun(tokenDataAll =  toksCAllSW, tokenDataBlogs = toksCBlogsSW , tokenDataNews = toksCNewsSW, tokenDataTwits = toksCTwittsSW, nGram = 2, maxTableRows = 5001, typeData = "SW")
        
        cat(green("Creation of tables for n-grams 3\n"))
        nGramTableFun(tokenDataAll =  toksCAllSW, tokenDataBlogs = toksCBlogsSW , tokenDataNews = toksCNewsSW, tokenDataTwits = toksCTwittsSW, nGram = 3, maxTableRows = 5001, typeData = "SW")
        
        rm(toksCBlogsSW, toksCNewsSW, toksCTwittsSW)
#===================================================
# Unique words     
#===================================================

# How many unique words do you need in a frequency sorted dictionary to cover 50% of all word instances in the language? 90%?
        # Watch out: Computation done on the corpus with stopWord!
        toksCAllSW <- readRDS("./data/processedData/toksCAllSW.RDS")
        toksNGram1CAll <- tokens_ngrams(toksCAllSW, 1)
        dfmToks1CAll <- dfm(toksNGram1CAll, remove="")
        head(dfmToks1CAll)

        # Create DF
        colSumToks <- colSums(dfmToks1CAll)
        featNamesToks <- names(colSumToks)
                                
        tableFeatFreq <- data.frame(featNamesToks, colSumToks) %>%
                        arrange(desc(colSumToks)) %>% 
                        rename(count = colSumToks) %>%
                        rename(ngrams = featNamesToks) %>%
                        mutate(cumSum = cumsum(count)) %>%
                        mutate(cumSumDivTotalWord = cumSum / sum(count))
                
        row.names(tableFeatFreq) <- 1: nrow(tableFeatFreq)
        
                # check
                        # head(tableFeatFreq)
                        # tail(tableFeatFreq, 500) ### See url
                        # max(tableFeatFreq$cumSumDivTotalWord)

                                
        nrWordC <- nrow(tableFeatFreq)
                saveRDS(nrWordC, "./figures/finalFigures/nrWordC.RDS")
        
        rowTitle <- "Unique word numbers"
        coverage0.1 <- sum(tableFeatFreq$cumSumDivTotalWord < 0.1)
        coverage0.2 <- sum(tableFeatFreq$cumSumDivTotalWord < 0.2)
        coverage0.3 <- sum(tableFeatFreq$cumSumDivTotalWord < 0.3)
        coverage0.4 <- sum(tableFeatFreq$cumSumDivTotalWord < 0.4)
        coverage0.5 <- sum(tableFeatFreq$cumSumDivTotalWord < 0.5)
                saveRDS(coverage0.5, "./figures/finalFigures/coverage0.5.RDS")
        coverage0.6 <- sum(tableFeatFreq$cumSumDivTotalWord < 0.6)
        coverage0.7 <- sum(tableFeatFreq$cumSumDivTotalWord < 0.7)
        coverage0.8 <- sum(tableFeatFreq$cumSumDivTotalWord < 0.8)
        coverage0.9 <- sum(tableFeatFreq$cumSumDivTotalWord < 0.9)
                saveRDS(coverage0.9, "./figures/finalFigures/coverage0.9.RDS")
        
# Plotly table
         rgbChartreuse2 <- "rgb(118,238,0)"
         colorHeader <- rgbChartreuse2
        
        coverageTable <- plot_ly(
              type = 'table',
              columnwidth = c(160,50,50,50,50,50,50,50, 50, 50),
              columnorder = c(1,2,3,4,5,6,7,8, 9, 10),
              header = list(
                values = c("Integrated Data", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%"),
                align = c("left", "center", "center", "center", "center", "center", "center", "center", "center", "center"),
                line = list(width = 1, color = 'black'),
                fill = list(color = colorHeader),
                font = list(family = "Arial", size = 14, color = "white")
              ),
              cells = list(
                values = rbind(rowTitle, coverage0.1, coverage0.2, coverage0.3, coverage0.4, coverage0.5, coverage0.6, coverage0.7, coverage0.8, coverage0.9),
                align = c("left", "center", "center", "center", "center", "center", "center", "center", "center", "center"),
                line = list(color = "black", width = 1),
                font = list(family = "Arial", size = 12, color = c("black"))
              ))
        print(coverageTable)
        
        cat(green("Word coverage table created and saved\n"))
        saveRDS(coverageTable, "./figures/finalFigures/coverageTable.RDS")
        rm(rowTitle, coverage0.1, coverage0.2, coverage0.3, coverage0.4, coverage0.5, coverage0.6, coverage0.7, coverage0.8, coverage0.9)
        rm(rgbChartreuse2, colorHeader)
        rm(nGram, maxTableRows, colSumToks, featNamesToks)
        rm(coverageTable, dfmToks1CAll, tableFeatFreq, toksNGram1CAll)
        