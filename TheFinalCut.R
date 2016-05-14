library(twitteR)
library(RCurl)
#The package allows one to compose general HTTP requests and provides convenient functions to fetch URIs, get & post forms,
library(RJSONIO)
#This is a package that allows conversion to and from data in Javascript object notation (JSON) format
library(stringr)
library("ROAuth")
library(RColorBrewer)
library(wordcloud)
#Create functions in this 

#####TweeTeR#####
setwd("E://NJIT College//SEM 1//IHLP//Mantej Singh//Mini Proj//Text Mining- R")

api_key <- "6G5bqTU8LidlqUVYT3vYzIK58"
api_secret <- "5v9xCKnXU6R8y9Jj2cRVBeHlye6QLeXNJOvRzJQLFjsP4supya"
access_token <- "143709642-rZmpKLCgYAUyPgih4Xqx2yzOZqlKSlhX60U1Espb"
access_token_secret <- "khqRJuCMjmfw8FnxkEez4RhoJ3jEKUIRwEmjgjeiSQdAC"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
1

a=searchTwitter("Obama", n=50,since='2015-01-01')
#,geocode ='40.742786,-74.180068,100mi')
sentinal = sapply(a, function(x) x$getText())
#sapply() performs (applies) a stated function to each subgroup in a split.

#Boston '42.375,-71.1061111,10mi'
#NJIT   '40.742786, -74.180068,5mi'
#searchTwitter('charlie sheen', since='2011-03-01', until='2011-03-02')
#a=searchTwitter("@McDonaldsCorp or #burger", n=100,since='2015-01-01')
## Search between two dates
#a=searchTwitter('NJIT', since='2015-01-01',n=500)

## geocoded results
#searchTwitter('patriots', geocode='42.375,-71.1061111,10mi')

head(a,n=2)
head(sentinal,n=2)
write.csv(twListToDF(a), file="obama.csv")
#twListToDF function will take a list of objects from a single twitteR class and return a data.frame version of the members 
#......2 hashtag in same tweet#
 
#########RnD##########
#curtrend<- getTrends('NJIT',woeid = 'Yahoo')
mytimeline <- getUser("mdmantejsingh")
myTweets
myTweets<-userTimeline("mdmantejsingh", n = 100)
chinu<-userTimeline("dCD_ROM",n=30)
head(myTweets)
head(chinu)
str(chinu)
twListToDF(chinu)
tweet("TweetR from Rstudio, #IHLP")


bKing<-userTimeline("BurgerKing",n=30)
head(bKing,n=20)

#########TextMining#########
library(tm)

reviews <- read.csv("obama.csv",stringsAsFactors = FALSE)
#reviews <- read.csv("speech2.csv",stringsAsFactors = FALSE)
str(reviews)
#Concatenate Strings using Paste()
review_text <- paste(reviews$text,collapse=" ")
#If a value is specified for collapse, the values in the result are then concatenated into a single string, with the elements being separated by the value of collapse. 
#The form using $ applies to recursive objects such as lists and pairlists. It allows only a literal character string or a symbol as the index.
review_source <- VectorSource(review_text)
#Constructs a source for a vector as input. 
corpus <- Corpus(review_source)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("SMART"))
corpus <- tm_map(corpus, removeWords, c(stopwords("english"),"can","dont","cant","many","get"))
#tm_map=Interface to apply transformation functions (also denoted as mappings) to corpora.

dtm <- DocumentTermMatrix(corpus)
#A document-term matrix or term-document matrix is a mathematical matrix that describes the frequency of terms that occur in a collection of documents. 
#In a document-term matrix, rows correspond to documents in the collection and columns correspond to terms.
#Its a data reduction techniques-used singular value decomposition reduces the number of columns (documents) but keeps the number of rows (words)
dtm2 <- as.matrix(dtm)
#Describes the frequency of terms that occur in a collection of documents
frequency <- colSums(dtm2)
#colSums=Form Row and Column Sums and Means 
frequency <- sort(frequency, decreasing=TRUE)
head(frequency,n=30)
######GraphiX
  
#Creating WORDCLOUD
words <- names(frequency)
png("WordCloud.png", width=1280,height=800)
wordcloud(words[2:10], frequency[1:10],colors=brewer.pal(8,"Dark2"), scale=c(4,0.6), max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE)
dev.off()
#is.list(words)
#wordcloud(words)
#a<-head(words,n=10)
#wordcloud(a)
warnings()
dev.off()
          
#Creating Plot Graphs
library(ggplot2)
tdm <- TermDocumentMatrix(corpus,control = list(wordLengths = c(1, 4),frequency>10))
#tdm <- TermDocumentMatrix(corpus)
idx <- which(dimnames(tdm)$Terms == "r")
head(tdm)
tdm
#setting the brackets
(freq.terms <- findFreqTerms(tdm, lowfreq = 1,highfreq = 2))
#Setting the matrix
term.freq <- rowSums(as.matrix(tdm))
term.freq <- subset(term.freq, term.freq > 1,term.freq < 200)
term.freq
df <- data.frame(term = names(term.freq), freq = term.freq)
#Plot the graph
ggplot(df, aes(x = term, y = freq)) + geom_bar(stat = "identity") + xlab("Frequent Terms") + ylab("Count") + coord_flip()
dev.off()
#findAssocs(dtm, "good", 0.8)
#method 1
# remove sparse terms
library(reshape)

a<-term.freq
head(a)
TDM.dense = melt(a)
head(TDM.dense)
#tdm2 <- removeSparseTerms(TDM.dense, sparse = 0.1)
m2 <- as.matrix(TDM.dense)
# cluster terms
distMatrix <- dist(scale(m2))
fit <- hclust(distMatrix, method = "ward.D2")
plot(fit, cex = .5, col = "red")
#rect.hclust(fit, k = 2) # cut tree into 6 clusters
dev.off()

##The Sentinals

library(Rstem)
library(sentiment)
library(qdap)
library(plyr)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)

# remove retweet entities
sentinal = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", sentinal)
# remove at people
sentinal = gsub("@\\w+", "", sentinal)
# remove punctuation
sentinal = gsub("[[:punct:]]", "", sentinal)
# remove numbers
sentinal = gsub("[[:digit:]]", "", sentinal)
# remove html links
sentinal = gsub("http\\w+", "", sentinal)
# remove unnecessary spaces
sentinal = gsub("[ \t]{2,}", "", sentinal)
sentinal = gsub("^\\s+|\\s+$", "", sentinal)


# classify emotion
class_emo = classify_emotion(sentinal, algorithm="bayes", prior=1.0)
# get emotion best fit
emotion = class_emo[,7]
# substitute NA's by "unknown"
emotion[is.na(emotion)] = "Unknown"

# classify polarity
class_pol = classify_polarity(sentinal, algorithm="bayes")
# get polarity best fit
polarity = class_pol[,4]

# data frame with results
sent_df = data.frame(text=sentinal, emotion=emotion,
                     polarity=polarity, stringsAsFactors=FALSE)

# sort data frame
sent_df = within(sent_df,
                 emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))


# plot distribution of emotions
png("Sentinals.png", width=1280,height=800)
ggplot(sent_df, aes(x=emotion)) +  geom_bar(aes(y=..count.., fill=emotion)) +
  scale_fill_brewer(palette="Dark2") +
  ggtitle("Sentiment Analysis of Tweets:\n(classification by Emotion)") +
  theme(legend.position="right") + ylab("Number of Tweets") + xlab("Emotion Categories")
dev.off()

# plot distribution of polarity
png("Polars.png", width=1280,height=800)

ggplot(sent_df, aes(x=polarity)) +
  geom_bar(aes(y=..count.., fill=polarity)) +
  scale_fill_brewer(palette="RdGy") +
     ggtitle("Sentiment Analysis of Tweets:\n(classification by Polarity)") +
         theme(legend.position="right") + ylab("Number of Tweets") + xlab("Polarity Categories")
dev.off()       

# separating text by emotion
emos = levels(factor(sent_df$emotion))
#send_df(data frame)-Create data frame with the results and obtain some general statistics
nemo = length(emos)
emo.docs = rep("", nemo)
for (i in 1:nemo)
{
  tmp = sentinal[emotion == emos[i]]
  emo.docs[i] = paste(tmp, collapse=" ")
}

# remove stopwords
emo.docs = removeWords(emo.docs, stopwords("english"))
#emo.docs = removeWords(emo.docs, stopwords("catalan"))
# create corpus
corpus = Corpus(VectorSource(emo.docs))
tdm = TermDocumentMatrix(corpus)
tdm = as.matrix(tdm)
colnames(tdm) = emos
dev.off()
# comparison word cloud
png("Comparison2.png", width=1280,height=800)
comparison.cloud(tdm, colors = brewer.pal(nemo, "Dark2"),
                 scale = c(3,.5), random.order = FALSE, title.size = 1.5)
dev.off()
