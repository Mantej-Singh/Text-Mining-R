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
#Professor you need to set this path....

api_key <- "6G5bqTU8LidlqUVYT3vYzIK58"
api_secret <- "5v9xCKnXU6R8y9Jj2cRVBeHlye6QLeXNJOvRzJQLFjsP4supya"
access_token <- "143709642-rZmpKLCgYAUyPgih4Xqx2yzOZqlKSlhX60U1Espb"
access_token_secret <- "khqRJuCMjmfw8FnxkEez4RhoJ3jEKUIRwEmjgjeiSQdAC"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
1

a=searchTwitter("Obama", n=50,since='2015-01-01',geocode ='40.742786,-74.180068,100mi')
sentinal = sapply(a, function(x) x$getText())
#sapply() performs (applies) a stated function to each subgroup in a split.


head(a,n=2)
head(sentinal,n=2)
write.csv(twListToDF(a), file="obama.csv")
#twListToDF function will take a list of objects from a single twitteR class and return a data.frame version of the members 
#......2 hashtag in same tweet#


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
warnings()
dev.off()


#####The Sentinals######

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
