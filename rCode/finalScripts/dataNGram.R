
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
        pannelFeatPlotNGram2 <- nGramPlotFun(nGram =2, titleNGramPannelPlot <- "15 Top Features: n-grams 2", marginPannelPlot = 0.2)
        pannelFeatPlotNGram3 <- nGramPlotFun(nGram =3, titleNGramPannelPlot <- "15 Top Features: n-grams 3", marginPannelPlot = 0.25)
        
        print(pannelFeatPlotNGram1)
        print(pannelFeatPlotNGram2)
        print(pannelFeatPlotNGram3)
        
        saveRDS(pannelFeatPlotNGram1, "./figures/finalFigures/pannelFeatPlotNGram1.RDS")
        saveRDS(pannelFeatPlotNGram2, "./figures/finalFigures/pannelFeatPlotNGram2.RDS")
        saveRDS(pannelFeatPlotNGram3, "./figures/finalFigures/pannelFeatPlotNGram3.RDS")
        
        readRDS("./figures/finalFigures/pannelFeatPlotNGram1.RDS")
        readRDS("./figures/finalFigures/pannelFeatPlotNGram2.RDS")
        readRDS("./figures/finalFigures/pannelFeatPlotNGram3.RDS")


