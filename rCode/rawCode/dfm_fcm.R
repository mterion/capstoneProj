


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
        
# Coumns sum
        head(colSums(dfmAll), 10)
        head(colSums(dfmNews), 10)
        
        # simply need to assign this to a vector, sort the order and extract the 50% of this vector
        # I stoped there, need to construct now a Feature co-occurence matrix
