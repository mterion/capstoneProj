# Ressources:
# TextMiningInfrastructure : see Pdf
        # Steps:
                # 1. Import text in R
                        # DB mechanism to avoid RAM overload
                                # Holding only pointers or hashtables in memory instaed of full docs

                # 2. Tidy up the text 
                        # Transformation 
                                # whitespace elimination + lower case convention
                                        # stripWhitespace()
                                        # tmToLower
                                # stopword removal
                                        # make a stop word list
                                        # removeWords()
                                # stemming procedures: erase word suffix to retrieve their radicals
                                        # wordStem()
                                # synonyms
                                        # Find them: synonyms()
                                        # Replace them: replaceWords()
                        # Filtering : fun apply on collections to extract patterns of interest
                        # Joining texts: merging
                                # Texts = straightforward
                                # Metadata = more difficult
                        # Tagging words
                                # with their part of speech for further analysis

                # 3. Transform the preprocessed text into structured format (to be computed with)
                        # -> term document matrix
                                # freq of distinct terms for each doc

                # 4. Compute on texts with standard technics stat and data mining techniques
                        # Count-based evaluation
                        # Find association
                                # based on correlations betw terms
                                # findAssocs() ex: assoc for oil with at least 0.85 correlation in the term-doccument matrix
                        # Clustering 
                                # Distance measure
                                        # dissimilarity(, method= "cosine")
                                # Then clustering method clust
                                        # hclust() or kmeans()
                        # classification methods
                                # In contrast to clustering wehre groups are unknown in the begining
                                        # Classf put specific docs into grps known in advance
                                # k-nearest neighbor
                                        # knn()
                                # Support vector machine classification
                                        
# stopped at p.34

        # Corpus (means text collection)
                # Is the text mining framework
        # Sources
                # Text present in different formats in different locations
        # Metadata
                # Modern file formats to annotate docs (XML with tags)
                        # Offer insight into the doc structure
                # Additional metadata will be created during the analysis
                # Can be set at:
                        # Doc level -> short summary of selected docs
                        # Collection level -> collection-wide classification tags