# Document-feature matrix
        cat(green("Running: 'dataDFM.r'\n"))
        cat(green("Document-feature matrix creation\n"))
        
# Create DFM
        # All
        dfmAll <- dfm(toksCAll, remove="") # need to remove blank strings, because I kept padding true before to keep the order of words
        
        # Blogs
        dfmBlogs <- dfm_subset(dfmAll, type == "blogs")

        # News
        dfmNews <- dfm_subset(dfmAll, type == "news")

        # Twitts
        dfmTwitts <- dfm_subset(dfmAll, type =="twitts")
        
                # Checks
                # head(dfmAll); head(dfmBlogs); head(dfmNews); head(dfmTwitts)
        
# Inspect dfm
        # nr docs
        nrDocAll <- ndoc(dfmAll)
        nrDocBlogs <- ndoc(dfmBlogs)
        nrDocNews <- ndoc(dfmNews)
        nrDocTwitts <- ndoc(dfmTwitts)
        
                # Checks
                # nrDocAll; nrDocBlogs; nrDocNews; nrDocTwitts
        
# Features
        # Number features        
        nrFeatAll <- nfeat(dfmAll)
        nrFeatBlogs <- nfeat(dfmBlogs)
        nrFeatNews <- nfeat(dfmNews)
        nrFeatTwitts <- nfeat(dfmTwitts)
                
                # Checks
                # nrFeatAll; nrFeatBlogs; nrFeatNews; nrFeatTwitts
                # All equal to the same nr of features, bec are simply the cols of the dfm
                
# Top Features
        topFeatAll <- topfeatures(dfmAll, 15)
        topFeatBlogs <- topfeatures(dfmBlogs, 15)
        topFeatNews <- topfeatures(dfmNews, 15)
        topFeatTwitts <- topfeatures(dfmTwitts, 15)
        
                # Checks
                topFeatAll; topFeatBlogs; topFeatNews; topFeatTwitts
                
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
        # function
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
       
        integratedFeatPlot <- featPlotFun(topFeatAllDf, "Integrated Dataset", "chartreuse2")
        integratedFeatPlot
        
        blogsFeatPlot <- featPlotFun(topFeatBlogsDf, "Blogs", "steelblue")
        blogsFeatPlot
        
        newsFeatPlot <- featPlotFun(topFeatNewsDf, "News", "salmon")
        newsFeatPlot
        
        twittsFeatPlot <- featPlotFun(topFeatTwittsDf, "Twitts", "seagreen")
        twittsFeatPlot
         
        pannelFeatPlot <- subplot(integratedFeatPlot, blogsFeatPlot, newsFeatPlot, twittsFeatPlot,  
                        nrows = 2, margin = 0.1) %>%
                layout(title="15 Top Features", margin = 0.1)
        
        pannelFeatPlot
        saveRDS(pannelFeatPlot, "./figures/finalFigures/pannelFeatPlot.RDS")
       
# Clean
        rm(nrDocAll, nrDocBlogs, nrDocNews, nrDocTwitts,
           nrFeatAll, nrFeatBlogs, nrFeatNews, nrFeatTwitts,
           topFeatAll, topFeatAllNames, topFeatBlogs, topFeatBlogsNames, topFeatNews, topFeatNewsNames, topFeatTwitts, topFeatTwittsNames)
        
        rm(blogsFeatPlot, integratedFeatPlot, newsFeatPlot, pannelFeatPlot, topFeatAllDf, topFeatBlogsDf, topFeatNewsDf, topFeatTwittsDf, twittsFeatPlot)        
        
 