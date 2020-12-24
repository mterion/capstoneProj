# Color to be used in the whole document
        # All
                rgbChartreuse2 <<- "rgb(118,238,0)"
        # Blogs
                rgbSteelblue <<- "rgb(70,130,180)"
                
        # News
                rgbSalmon <<- "rgb(250,128,114)"
        # Twitts
                rgbSeagreen <<- "rgb(46,139,87)"



# Feature plot function for DFM dataDFM and dataNGram

        ######
        # dfName <- topFeatAllDf
        # titleFeatPlot <- "Integrated Dataset"
        # colorFeatPlot <- "chartreuse2"
        #####

        featPlotFun <- function(dfName, titleFeatPlot, colorFeatPlot){
                      featPlot <- ggplot(dfName, aes(x = reorder(feat, count), y=count)) + # reorder bars in ascending order
                          geom_bar(stat="identity", fill= colorFeatPlot) +
                                theme_minimal() +
                                labs(
                                    x = ""
                                    ) +
                                scale_y_continuous(name = "Frequency", labels = scales::number) +
                                theme(axis.text.x = element_text(angle = 90))
                      
                        # Flip coordinate to be able to read better the labels
                        featPlot <- featPlot + coord_flip() 
                      
                # Send to Plotly
                      featPlot <- ggplotly(
                        featPlot,
                        tooltip = "count"
                        )
                      
                      featPlot <- featPlot %>%
                          add_annotations(
                            text = ~unique(titleFeatPlot),
                            x = 0.14, 
                            y = 1.15, # origin 1.1
                            yref = "paper",
                            xref = "paper",
                            xanchor = "left",
                            yanchor = "top",
                            showarrow = FALSE,
                            font = list(size = 15)
                          )
                      return(featPlot)
        }

#Semantic Network
        ###
        #cName = "CBlogs"; toksCType = "toksCBlogs"; minTermFreq = 1000; topFeaturesNr = 50
        # cName <- cNews        
        # toksCType <- "toksCNews"
        # minTermFreq <- 1000
        # topFeaturesNr <- 50
        ###
                
        semanticNetwFun <- function(cName, toksCType, minTermFreq, topFeaturesNr){
                # Load
                toksCType <- readRDS(paste0("./data/processedData/", toksCType, ".RDS"))
                
                # Remove empty token to avoid cluttering document feature matrix with unusable frequencies
                toksCType <- tokens_select(toksCType, "", selection="remove", valuetype = "fixed", padding=FALSE)
                
                # Document feature matrix creation
                toksDfm <- dfm(toksCType)
                
                # Trim
                toksDfmTrim <- dfm_trim(toksDfm, min_termfreq = minTermFreq)
                        dim(toksDfmTrim)
                        
                # Feature co-occurence matrix (FCM)
                toksFcm <- fcm(toksDfmTrim)
                        dim(toksFcm) 
                        
                # Top features
                topFeatures <- names(topfeatures(toksFcm, topFeaturesNr))
                        head(topFeatures)
                
                # Filter the 50 top features from the FCM
                toksFcmFilt <- fcm_select(toksFcm, pattern = topFeatures, selection = "keep")
                        dim(toksFcmFilt)
                        
                # Plot semantic network
                set.seed(144)
                semNetw <- textplot_network(
                        toksFcmFilt,
                        min_freq = 0.5,
                        omit_isolated = TRUE,
                        edge_color = "lightgrey",
                        edge_alpha = 1,
                        edge_size = 0.8,
                        vertex_color = "steelblue",
                        vertex_size = 2,
                        vertex_labelcolor = NULL,
                        vertex_labelfont = NULL,
                        vertex_labelsize = 5)
                saveRDS(semNetw, paste0("./figures/finalFigures/semNetw", cName,".RDS"))
                return(semNetw)
        }
                
    
# Integrated pannel plot for n-gram : 4 plots (integrated dataset, blogs, news, twitts)
                ###
                        # nGram <- 3
                        # titleNGramPannelPlot <- "15 Top Features: n-grams 3"
                        # marginPannelPlot <- 0.1 # was 0.3, should be 0.1 for ngram3
                ###
               
        nGramPlotFun <- function(nGram, titleNGramPannelPlot, marginPannelPlot){
                # marginPannelPlot enable to have enough space if the nr of words are increased on the graph
                # tokens created on the base of the nGram entered
                cat(green("Plot n-grams -> Tokenization for the n-grams value: ", nGram,"\n"))
                toksNGramXAll <- tokens_ngrams(toksCAll, nGram)
                        # head(toksNGramXAll)
                # dfm creation
                cat(green("           Creation of document-feature matrix\n"))
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
                        
                # Top Features
                cat(green("           Identification of 15 top features\n"))
                topFeatAll <- topfeatures(dfmToksNGramXAll, 15)
                topFeatBlogs <- topfeatures(dfmToksNGramXBlogs, 15)
                topFeatNews <- topfeatures(dfmToksNGramXNews, 15)
                topFeatTwitts <- topfeatures(dfmToksNGramXTwitts, 15)
                        #print(topFeatAll);  print(topFeatBlogs); print(topFeatNews); print(topFeatTwitts)       
                
                # Top Features names
                topFeatAllNames <- names(topFeatAll)
                topFeatBlogsNames <- names(topFeatBlogs)
                topFeatNewsNames <- names(topFeatNews)
                topFeatTwittsNames <- names(topFeatTwitts)
        
                # Df creation
                topFeatAllDf <- data.frame(topFeatAllNames, topFeatAll) %>% rename(feat = topFeatAllNames) %>% rename(count = topFeatAll) %>% arrange(desc(count)) 
                topFeatBlogsDf <- data.frame(topFeatBlogsNames, topFeatBlogs) %>% rename(feat = topFeatBlogsNames) %>% rename(count = topFeatBlogs) %>% mutate(type="Blogs")
                topFeatNewsDf <- data.frame(topFeatNewsNames, topFeatNews)%>% rename(feat = topFeatNewsNames) %>% rename(count = topFeatNews) %>% mutate(type="News")
                topFeatTwittsDf <- data.frame(topFeatTwittsNames, topFeatTwitts)%>% rename(feat = topFeatTwittsNames) %>% rename(count = topFeatTwitts) %>% mutate(type="Twitts")

        # Individual Feature plots
                # Call function
                
                integratedFeatPlot <- featPlotFun(topFeatAllDf, "Integrated Dataset", "chartreuse2")
                #integratedFeatPlot
                
                blogsFeatPlot <- featPlotFun(topFeatBlogsDf, "Blogs", "steelblue")
                #blogsFeatPlot
                
                newsFeatPlot <- featPlotFun(topFeatNewsDf, "News", "salmon")
                #newsFeatPlot
                
                twittsFeatPlot <- featPlotFun(topFeatTwittsDf, "Twitts", "seagreen")
                #twittsFeatPlot
                
        # Pannel plot
         
                pannelFeatPlot <- subplot(integratedFeatPlot, blogsFeatPlot, newsFeatPlot, twittsFeatPlot,  
                                nrows = 2, margin = marginPannelPlot) 
                        # %>% layout(title= titleNGramPannelPlot, margin = 0.1)  : no need of title in the tab version of the report
                
                ###
                #pannelFeatPlot
                ###
                
                return(pannelFeatPlot)
                
                # Garbage collection cleaned to free up RAM
                gc()
        }
        
# Ngram individual tables
        nGramIndivTableFun <- function(dfmToksName, typeDoc, colorHeader){
                                cat(green("          Creation of the individual n-grams table\n"))
                
                                colSumToks <- colSums(dfmToksName)
                                featNamesToks <- names(colSumToks)
                                
                                tableFeatFreq <- data.frame(featNamesToks, colSumToks) %>%
                                                arrange(desc(colSumToks)) %>% 
                                                rename(count = colSumToks) %>%
                                                rename(ngrams = featNamesToks) %>%
                                                mutate(proportion = round((count / sum(count) * 100), digits = 4)) %>%
                                                filter(row_number() < maxTableRows)
                                        
                                        row.names(tableFeatFreq) <- 1: nrow(tableFeatFreq)
                                        
                                fig <- plot_ly(
                                  type = 'table',
                                  columnorder = c(1,2,3,4),
                                  columnwidth = c(80,400, 80, 80),
                                  header = list(
                                    values = c("Rank", paste0(typeDoc, " : n-grams ", nGram), "Count", "Proportion"),
                                  align = c('center', rep('center', ncol(tableFeatFreq))),
                                  line = list(width = 1, color = 'black'),
                                  fill = list(color = colorHeader),
                                  font = list(family = "Arial", size = 14, color = "white")
                                  ),
                                  cells = list(
                                    values = rbind(
                                      rownames(tableFeatFreq), 
                                      t(as.matrix(unname(tableFeatFreq)))
                                    ),
                                    align = c('center', rep('center', ncol(tableFeatFreq))),
                                    line = list(color = "black", width = 1),
                                    fill = list(color = c("rgb(229,229,229)", "rgb(250,250,250)")),
                                    font = list(family = "Arial", size = 12, color = c("black"))
                                  ))
                                return(fig)
        }
        
#nGramTables
        ###
        # nGram <- 2
        # maxTableRows <- 20
        # tokenDataAll <- toksCAll
        # tokenDataBlogs <- toksCBlogs
        # tokenDataNews <- toksCNews
        # tokenDataTwits<- toksCTwitts
        # typeData <- P
        ###
        
        # I cannot use the same procedure than above, subsetting dfm, because all tables of one n-grams will be the same given the fact that it's not based on frequency (just displaying the words) unlike bar plot
        nGramTableFun <- function(tokenDataAll, tokenDataBlogs, tokenDataNews, tokenDataTwits, nGram, maxTableRows, typeData =""){
                       cat(green("Table n-grams -> Tokenization for the n-grams value: ", nGram,"\n"))
        
                        # Global vars
                        nGram <<- nGram # makes it a global var so that my 2nd fun will find its value
                        maxTableRows <<- maxTableRows
                        
                        # tokens created on the base of the nGram entered
                        toksNGramXAll <- tokens_ngrams(tokenDataAll, nGram)
                        ##
                                toksNGramXBlogs <- tokens_ngrams(tokenDataBlogs, nGram)
                                toksNGramXNews <- tokens_ngrams(tokenDataNews, nGram)
                                toksNGramXTwitts <- tokens_ngrams(tokenDataTwits, nGram)
                                        # head(toksNGramXAll); head(toksNGramXBlogs); head(toksNGramXNews); head(toksNGramXTwitts)
                                
                        # dfm creation
                        cat(green("Creation of document-feature matrix\n"))
                        dfmToksNGramXAll <- dfm(toksNGramXAll, remove="")
                        ##
                                dfmToksNGramXBlogs <- dfm(toksNGramXBlogs, remove="")
                                dfmToksNGramXNews <- dfm(toksNGramXNews, remove="")
                                dfmToksNGramXTwitts <- dfm(toksNGramXTwitts, remove="")
                                        # head(dfmToksNGramXAll); head(dfmToksNGramXBlogs); head(dfmToksNGramXNews); head(dfmToksNGramXTwitts); 
                        
                # Plotly tables
                        # All
                        cat(green("     Creation of n-grams table: All\n"))
#                       rgbChartreuse2 <- "rgb(118,238,0)"
                        nGramTableAll <- nGramIndivTableFun(dfmToksNGramXAll, typeDoc = "Integrated Dataset", colorHeader = rgbChartreuse2)
                        print(nGramTableAll)
                        cat(green("     Saving of n-grams table: All\n"))
                        saveRDS(nGramTableAll, paste0("./figures/finalFigures/nGram_", nGram, "_TableAll", typeData, ".RDS"))
                        
                        
                        # Blogs
                        cat(green("     Creation of n-grams table: Blogs\n"))
#                       rgbSteelblue <- "rgb(70,130,180)"
                        nGramTableBlogs <- nGramIndivTableFun(dfmToksNGramXBlogs, typeDoc = "Blogs", colorHeader = rgbSteelblue)
                        print(nGramTableBlogs)
                        cat(green("     Saving of n-grams table: Blogs\n"))
                        saveRDS(nGramTableBlogs, paste0("./figures/finalFigures/nGram_", nGram, "_TableBlogs", typeData, ".RDS"))
                        
                        
                        # News
                        cat(green("     Creation of n-grams table: News\n"))
#                       rgbSalmon <- "rgb(250,128,114)"
                        nGramTableNews <- nGramIndivTableFun(dfmToksNGramXNews, typeDoc = "News", colorHeader = rgbSalmon)
                        print(nGramTableNews)
                        cat(green("     Saving of n-grams table: News\n"))
                        saveRDS(nGramTableNews, paste0("./figures/finalFigures/nGram_", nGram, "_TableNews", typeData, ".RDS"))
                        
                        
                        # Twitts
                        cat(green("     Creation of n-grams table: Twitts\n"))
#                       rgbSeagreen <- "rgb(46,139,87)"
                        nGramTableTwitts <- nGramIndivTableFun(dfmToksNGramXTwitts, typeDoc = "Twitts", colorHeader = rgbSeagreen)
                        print(nGramTableTwitts)
                        cat(green("     Saving of n-grams Twitts: All\n"))
                        saveRDS(nGramTableTwitts, paste0("./figures/finalFigures/nGram_", nGram, "_TableTwitts", typeData, ".RDS"))
                        
                        rm(nGram)# remove global var
                        gc() # garbage collection
        }
       
        

        