
library(udpipe)
#function to extract keywords
ud_model <- udpipe_download_model(language = "english")
ud_model <- udpipe_load_model(ud_model$file_model)

extract_keywords <- function(x) {
  resume <- read_file(x)
  
  resume_df <- tibble(title = "User", description = resume)
  words <- udpipe_annotate(ud_model, x = resume_df$description)
  words <- as.data.frame(words)
  
  keywords <- textrank_keywords(words$lemma, relevant = words$upos %in% c("NOUN", "ADJ"), ngram_max = 8, sep = " ")
  keywords <- subset(keywords$keywords, freq >= 5)
  return(head(keywords, n = 10))
}



 #extract_keywords(resume_df)



