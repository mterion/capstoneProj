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
        
# Features
        # Number features        
        nrFeatAll <- nfeat(dfmAll)
                head(featnames(dfmAll))
                
       
        
        
        
         # Top features
        topFeat <- topfeatures(dfmAll,10)
        
        
        topFeatBlogs <- topfeatures(dfmAll$type %in% "blogs",10)
        