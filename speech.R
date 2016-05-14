install.packages('tm')

library(tm)

setwd("E://NJIT College//SEM 1//IHLP//Mantej Singh//Mini Proj//Text Mining- R")

reviews <- read.csv("speech2.csv",stringsAsFactors = FALSE)
#reviews2 <- read.fwf("speech1.txt", widths = c(9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9))
str(reviews)
#print(reviews2)
review_text <- paste(reviews$text,collapse=" ")
review_source <- VectorSource(review_text)
corpus <- Corpus(review_source)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)

dtm <- DocumentTermMatrix(corpus)
dtm2 <- as.matrix(dtm)
frequency <- colSums(dtm2)
frequency <- sort(frequency, decreasing=TRUE)
#frequency <- termFreq(frequency)
#op <- find(frequency,mode = "any")
aa<-head(frequency,n = 300)
install.packages('plyr')
library(plyr)
count(frequency)
tabulate(aa)

#inspect(dtm)
#op <- inspect(dtm)
#op <- sort(op + frequency,decreasing = TRUE)
findFreqTerms(dtm,lowfreq = 0,highfreq =1)

findAssocs(dtm,"game",.999)
#findAssocs(dtm, c("game","fun","love"), c(0.1, 0.1, 0.1))
op <- inspect(DocumentTermMatrix(corpus, list(dictionary = c("know","you","mantej","sid"))))


library(wordcloud)
words <- names(frequency)
wordcloud(words[3:100], frequency[1:100])
wordcloud(words)
words

plot(reviews)
#wordcloud(words,min.freq = 2, scale=c(7,0.5),colors=brewer.pal(8, "Dark2"),  random.color= TRUE, random.order = FALSE, max.words = 150)

#mydata.df <- as.data.frame(inspect(dtm))
#count<- as.data.frame(rowSums(mydata.df))
#count$word = rownames(count)
#colnames(count) <- c("count","word" )
#count<-count[order(count$count, decreasing=TRUE),]


