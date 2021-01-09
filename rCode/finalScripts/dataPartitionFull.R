        blogsDf <- readRDS("./data/processedData/blogsDf.RDS")
        

        
        blogsDf1 <- blogsDf %>% 
                rename(text = as.character.blogsLines.) %>%
                mutate(text = as.character(text)) %>%
                mutate(doc_id = "enBlogs") %>%
                mutate(type = "blogs") %>%
                mutate(typeIdNr = row_number()) %>%
                mutate(trainTestSet = if_else(typeIdNr < round(nrow(blogsDf) * 0.8), "train", "test")) %>%
                mutate(trainValidTestSet = if_else(typeIdNr < round(length(which(trainTestSet == "train")) * 0.8), "train", "valid")) %>%
                mutate(trainValidTestSet = if(trainTestSet == "test"), "test")
   
# do the same with case_when             
   https://datasciencelessons.wordpress.com/2019/11/22/tired-of-nested-ifelse-in-dplyr/

           
                   
        nrowTrain <- length(which(blogsDf1$trainValidTestSet == "train"))
        nrowValid <- length(which(blogsDf1$trainValidTestSet == "valid"))
        nrowTest <- length(which(blogsDf1$trainValidTestSet == "test"))
        
        nrowTrain + nrowValid + nrowTest
        
        
        round(length(which(blogsDf1$set == "train")) * 0.8)

        
        