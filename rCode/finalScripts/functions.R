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
        
# Ngram individual tables
# dfmToksName <- dfmToksNGramXAll
# typeDoc <- "Integrated Dataset, "
# colorHeader <- "rgb(118,238,0)"
# colorFirstCol <-  "lightgreen"
        

        
        nGramIndivTableFun <- function(dfmToksName, typeDoc, colorHeader){
                                cat(green("Creation of individual n-grams table\n"))
                
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
                                    values = c("Rank", paste(typeDoc, "n-grams:", nGram), "Count", "Proportion"),
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