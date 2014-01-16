#!/usr/bin/Rscript


# Set working directory
setwd("/home/susan/Documents/R Projects/Craigslist/")

source("./SamplePosts.R")
library(doMC)
registerDoMC(15)

temp <- SamplePosts(N=30)

con <- dbConnect(MySQL(), user="susan", dbname="susan", host="localhost")
cl <- dbReadTable(con, "craigslist", row.names=0)
cl <- cl[!is.na(cl$post_id),-1]
cl <- unique(cl)
rownames(cl) <- 1:nrow(cl)
dim(cl)
cl <- as.data.frame(apply(cl, 2, dbEscapeStrings, con=con),stringsAsFactors=FALSE)
dbWriteTable(conn=con, name="craigslist", value=cl, append=FALSE, overwrite=TRUE)
dbDisconnect(con)