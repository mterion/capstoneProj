
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
        readRDS("./figures/finalFigures/pannelFeatPlotNGram1.RDS")
        readRDS("./figures/finalFigures/pannelFeatPlotNGram2.RDS")
        readRDS("./figures/finalFigures/pannelFeatPlotNGram3.RDS")


# Create nGram tables
        
        # Do not run it if not necessary, because it takes time
        cat(green("Creation of tables for n-grams 1\n"))
        nGramTableFun(nGram = 1, maxTableRows = 50000)
        
        cat(green("Creation of tables for n-grams 2\n"))
        nGramTableFun(nGram = 2, maxTableRows = 50000)
        
        cat(green("Creation of tables for n-grams 3\n"))
        nGramTableFun(nGram = 3, maxTableRows = 50000)
        

# Read nGram tables       
        nGramTable_1_All <- readRDS("./figures/finalFigures/nGram_1_TableAll.RDS")
        nGramTable_1_Blogs <- readRDS("./figures/finalFigures/nGram_1_TableBlogs.RDS")
        nGramTable_1_News <- readRDS("./figures/finalFigures/nGram_1_TableNews.RDS")
        nGramTable_1_Twitts <- readRDS("./figures/finalFigures/nGram_1_TableTwitts.RDS")
        
        nGramTable_2_All <- readRDS("./figures/finalFigures/nGram_2_TableAll.RDS")
        nGramTable_2_Blogs <- readRDS("./figures/finalFigures/nGram_2_TableBlogs.RDS")
        nGramTable_2_News <- readRDS("./figures/finalFigures/nGram_2_TableNews.RDS")
        nGramTable_2_Twitts <- readRDS("./figures/finalFigures/nGram_2_TableTwitts.RDS")
        
        nGramTable_3_All <- readRDS("./figures/finalFigures/nGram_3_TableAll.RDS")
        nGramTable_3_Blogs <- readRDS("./figures/finalFigures/nGram_3_TableBlogs.RDS")
        nGramTable_3_News <- readRDS("./figures/finalFigures/nGram_3_TableNews.RDS")
        nGramTable_3_Twitts <- readRDS("./figures/finalFigures/nGram_3_TableTwitts.RDS")
        
        print(nGramTable_1_All)
        print(nGramTable_1_Blogs)
        print(nGramTable_1_News)
        print(nGramTable_1_Twitts)
        
        print(nGramTable_2_All)
        print(nGramTable_2_Blogs)
        print(nGramTable_2_News)
        print(nGramTable_2_Twitts)
        
        print(nGramTable_3_All)
        print(nGramTable_3_Blogs)
        print(nGramTable_3_News)
        print(nGramTable_3_Twitts)