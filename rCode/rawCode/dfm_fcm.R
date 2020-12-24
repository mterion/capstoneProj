# Semantic network
    semanticNetwFun(cName = "CAll", toksCType = "toksCAll", minTermFreq = 1000, topFeaturesNr = 50)
    readRDS("./figures/finalFigures/semNetwCAll.RDS")

    semanticNetwFun(cName = "CBlogs", toksCType = "toksCBlogs", minTermFreq = 1000, topFeaturesNr = 50)
    readRDS("./figures/finalFigures/semNetwCBlogs.RDS")
    
    semanticNetwFun(cName = "CNews", toksCType = "toksCNews", minTermFreq = 1000, topFeaturesNr = 50)
    readRDS("./figures/finalFigures/semNetwCNews.RDS")
    
    semanticNetwFun(cName = "CTwitts", toksCType = "toksCTwitts", minTermFreq = 1000, topFeaturesNr = 50)
    readRDS("./figures/finalFigures/semNetwCTwitts.RDS")



        #Quiz:       
        # Question 4: In the en_US twitter data set,Divide the number of lines where the word "love" (all lowercase) occurs by the number of lines the word "hate" (all lowercase) occurs, about what do you get?
                
                # sum(as.numeric(grep("love", twitterLines)))/sum(as.numeric(grep("hate", twitterLines)))
        
        # Q5: The one tweet in the en_US twitter data set that matches the word “biostats” says what?
        
                # grep("biostats", twitterLines, value = TRUE)
        
        # Q6: Question 6: How many tweets have the exact characters "A computer once beat me at chess, but it was no match for me at kickboxing". (I.e. the line matches those characters exactly.)
                
                # length(grep("A computer once beat me at chess, but it was no match for me at kickboxing", twitterLines))

 




