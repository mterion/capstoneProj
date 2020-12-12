# Feature plot function for DFM dataDFM and dataNGram

        featPlotFun <- function(dfName, titleFeatPlot, colorFeatPlot){
                      featPlot <- ggplot(dfName, aes(x = reorder(feat, -count), y=count)) + # reorder bars in descending order
                                geom_bar(stat="identity", fill= colorFeatPlot) +
                                theme_minimal() +
                                labs(
                                    x = "Words"
                                    ) +
                                scale_y_continuous(name = "Frequency", labels = scales::number) +
                                theme(axis.text.x = element_text(angle = 90))
                      
                      featPlot <- ggplotly(
                        featPlot,
                        tooltip = "count"
                        )
                      
                      featPlot <- featPlot %>%
                          add_annotations(
                            text = ~unique(titleFeatPlot),
                            x = 0.14,
                            y = 1.1,
                            yref = "paper",
                            xref = "paper",
                            xanchor = "left",
                            yanchor = "top",
                            showarrow = FALSE,
                            font = list(size = 15)
                          )
                      return(featPlot)
        }

# Integrated pannel plot for n-gram : 4 plots (integrated dataset, blogs, news, twitts)
        
        nGramPlotFun <- function(nGram, titleNGramPannelPlot, marginPannelPlot){
                # marginPannelPlot enable to have enough space if the nr of words are increased on the graph
                # tokens created on the base of the nGram entered
                cat(green("Start of the tokenization for the n-grams value chosen\n"))
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
                        
                # Top Features
                cat(green("Identification of 15 top features\n"))
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

                # Feature plots
                # Call function
                
                integratedFeatPlot <- featPlotFun(topFeatAllDf, "Integrated Dataset", "chartreuse2")
                #integratedFeatPlot
                
                blogsFeatPlot <- featPlotFun(topFeatBlogsDf, "Blogs", "steelblue")
                #blogsFeatPlot
                
                newsFeatPlot <- featPlotFun(topFeatNewsDf, "News", "salmon")
                #newsFeatPlot
                
                twittsFeatPlot <- featPlotFun(topFeatTwittsDf, "Twitts", "seagreen")
                #twittsFeatPlot
                 
                pannelFeatPlot <- subplot(integratedFeatPlot, blogsFeatPlot, newsFeatPlot, twittsFeatPlot,  
                                nrows = 2, margin = marginPannelPlot) %>%
                        layout(title= titleNGramPannelPlot, margin = 0.1)
                
                return(pannelFeatPlot)
                
                # Garbage collection cleaned to free up RAM
                gc()
        }