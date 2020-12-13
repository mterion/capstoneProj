nGramTableFun <- function(nGram, maxTableRows = 50000){
               cat(green("Table n-grams -> Tokenization for the n-grams value: ", nGram,"\n"))

                # Global vars
                
                nGram <<- nGram # makes it a global var so that my 2nd fun will find its value
                maxTableRows <<- maxTableRows
                
                # tokens created on the base of the nGram entered
                toksNGramXAll <- tokens_ngrams(toksCAll, nGram)
                        # head(toksNGramXAll)
                # dfm creation
                cat(green("Creation of document-feature matrix\n"))
                dfmToksNGramXAll <- dfm(toksNGramXAll, remove="")
                        # head(dfmToksNGramXAll)
                
                # Dfm subset for 3 types
                        # Blogs
                        dfmToksNGramXBlogs <- dfm_subset(dfmToksNGramXAll, type == "blogs")
                
                        # News
                        dfmToksNGramXNews <- dfm_subset(dfmToksNGramXAll, type == "news")
                
                        # Twitts
                        dfmToksNGramXTwitts <- dfm_subset(dfmToksNGramXAll, type =="twitts")
                                # head(dfmToksNGramXBlogs); head(dfmToksNGramXNews); head(dfmToksNGramXTwitts)
                
        # Plotly tables
                # All
                cat(green("Creation of n-grams table: All\n"))
                rgbChartreuse2 <- "rgb(118,238,0)"
                nGramTableAll <- nGramIndivTableFun(dfmToksNGramXAll, typeDoc = "Integrated Dataset, ", colorHeader = rgbChartreuse2)
                print(nGramTableAll)
                saveRDS(nGramTableAll, "./figures/finalFigures/nGramTableAll.RDS")
                
                # Blogs
                cat(green("Creation of n-grams table: Blogs\n"))
                rgbSteelblue <- "rgb(70,130,180)"
                nGramTableBlogs <- nGramIndivTableFun(dfmToksNGramXAll, typeDoc = "Blogs, ", colorHeader = rgbSteelblue)
                print(nGramTableBlogs)
                saveRDS(nGramTableBlogs, "./figures/finalFigures/nGramTableBlogs.RDS")

                # News
                cat(green("Creation of n-grams table: News\n"))
                rgbSalmon <- "rgb(250,128,114)"
                nGramTableNews <- nGramIndivTableFun(dfmToksNGramXAll, typeDoc = "News, ", colorHeader = rgbSalmon)
                print(nGramTableNews)
                saveRDS(nGramTableNews, "./figures/finalFigures/nGramTableNews.RDS")

                # Twitts
                cat(green("Creation of n-grams table: Twitts\n"))
                rgbSeagreen <- "rgb(46,139,87)"
                nGramTableTwitts <- nGramIndivTableFun(dfmToksNGramXAll, typeDoc = "Twitts, ",colorHeader = rgbSeagreen)
                print(nGramTableTwitts)
                saveRDS(nGramTableTwitts, "./figures/finalFigures/nGramTableTwitts.RDS")

                rm(nGram)# remove global var
                gc() # garbage collection
                
}
        


nGramTableFun(nGram = 1)

nGramTableAll <- readRDS("./figures/finalFigures/nGramTableAll.RDS")
nGramTableBlogs <- readRDS("./figures/finalFigures/nGramTableBlogs.RDS")
nGramTableNews <- readRDS("./figures/finalFigures/nGramTableNews.RDS")
nGramTableTwitts <- readRDS("./figures/finalFigures/nGramTableTwitts.RDS")

print(nGramTableAll)
print(nGramTableBlogs)
print(nGramTableNews)
print(nGramTableTwitts)


               
                     

