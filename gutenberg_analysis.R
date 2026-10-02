# NLP Project based on GutenbergR

library(gutenbergr)
library(tidytext)
library(dplyr)

my_mirror <- "http://mirrors.xmission.com/gutenberg/"

gutenberg

df<-gutenberg_metadata

unique(df$author)[startsWith(unique(df$author), "To")]

gutenberg_works(author == "Topin, Marius")

Man <- gutenberg_download(70207, mirror = my_mirror)

#working with texts - some ideas 

words_Man<-unnest_tokens(Man,words,text)

countwords<-count(words_Man,words,sort=TRUE)


bigram_Man<-unnest_tokens(Man,words,text,token = "ngrams", n=2)

countbigram<-count(bigram_Man,words,sort=TRUE)


trigram_Man<-unnest_tokens(Man,words,text,token = "ngrams", n=3)

counttrigram<-count(trigram_Man,words,sort=TRUE)



# test for dependence of biagram <-> phrases

countbigram<-count(bigram_Man,words,sort=TRUE)

countbigram<-countbigram[-2,]

countbigram[startsWith(countbigram$words, "according to"),]
countbigram[startsWith(countbigram$words, "according"),]
countbigram[endsWith(countbigram$words, "to"),]

a.t. <- countbigram[startsWith(countbigram$words, "according to"),]$n
a.nott. <- sum(countbigram[startsWith(countbigram$words, "according"),]$n) - a.t.
nota.t. <- sum(countbigram[startsWith(countbigram$words, "to"),]$n) - a.t.
nota.nott. <- sum(countbigram$n) - a.nott. - nota.t. - a.t.

freq<-matrix(c(a.t.,a.nott.,nota.t.,nota.nott.),ncol = 2, byrow = T)

mosaicplot(freq)

chisq.test(freq)

# independent

countbigram[startsWith(countbigram$words, "of their"),]
countbigram[startsWith(countbigram$words, "of"),]
countbigram[endsWith(countbigram$words, "thier"),]

o.t. <- countbigram[startsWith(countbigram$words, "of their"),]$n
o.nott. <- sum(countbigram[startsWith(countbigram$words, "of"),]$n) - o.t.
noto.t. <- sum(countbigram[startsWith(countbigram$words, "their"),]$n) - o.t.
noto.nott. <- sum(countbigram$n) - o.nott. - noto.t. - o.t.

freq1<-matrix(c(o.t.,o.nott.,noto.t.,noto.nott.),ncol = 2, byrow = T)

mosaicplot(freq1)

chisq.test(freq1)


# entropy of 1000-word parts

# first 1000 words: 

entr<-words_Man[1:1000,2]
char<-unnest_tokens(entr,token,words, token ="characters")
df.char<-as.data.frame(count(char,token,sort=TRUE))
df.char$relfreq<-df.char$n/sum(df.char$n)
df.char$ent<-df.char$relfreq*log2(df.char$relfreq)
entropy <- -sum(df.char$ent)

# the rest: 

entropy<-c()
for (i in 0:115)
{
  entr<-words_Man[(i*1000+1):(i*1000+1000),2]
  char<-unnest_tokens(entr,token,words, token ="characters")
  df.char<-as.data.frame(count(char,token,sort=TRUE))
  df.char$relfreq<-df.char$n/sum(df.char$n)
  df.char$ent<-df.char$relfreq*log2(df.char$relfreq)
  entropy <- c(entropy, -sum(df.char$ent))
}

entropy

plot(entropy)

# 0.95% confidence interval

n <- length(entropy)            
mean_entropy <- mean(entropy)   
sd_entropy <- sd(entropy)       

alpha <- 0.05
t_value <- qt(1 - alpha/2, df = n - 1) 

margin <- t_value * sd_entropy / sqrt(n)
lower <- mean_entropy - margin
upper <- mean_entropy + margin

c(lower, upper)

# naive bayes

11855/4

Man1<-Man[1:2963,]
Man2<-Man[(2963+1):(2*2963),]
Man3<-Man[(2*2963+1):(3*2963),]
Man4<-Man[(3*2963+1):11855,]

## sentence ##

sentence <- "The comparison of dates and the very expressions of the King’s letter indicate it sufficiently."

# Tokenize sentence
words_sentence <- unlist(strsplit(sentence, " "))

compute_prob <- function(section, words_sentence) {
  words_section <- unlist(strsplit(section$text, " ")) 
  
  vocab <- unique(words_section)
  total_words <- length(words_section)
  
  prob <- 1
  for(w in words_sentence){
    count_w <- sum(words_section == w)
    prob <- prob * (count_w + 1) / (total_words + length(vocab)) 
  }
  return(prob)
}

# Compute probabilities for each section
p1 <- compute_prob(Man1, words_sentence)
p2 <- compute_prob(Man2, words_sentence)
p3 <- compute_prob(Man3, words_sentence)
p4 <- compute_prob(Man4, words_sentence)

# Normalize to get posterior probabilities
posterior <- c(p1, p2, p3, p4)
posterior <- posterior / sum(posterior)
posterior







