library("tidyverse")
library("textstem")
library("NLP")
library("tm")
library("text2vec")
library("readxl")

#import occupation data
occupation <- read.csv(file = "Occupation_Data.csv")


# data cleaning function
prep_fun <- function(x) {
    x %>%
        # make text lower case
        str_to_lower() %>%
        # remove non-alphanumeric symbols
        str_replace_all("[^[:alnum:]]", " ") %>%
        # remove numbers
        {
            gsub(patter = "\\d", replace = " ", .)
        } %>%
        # remove stopwords
        removeWords(stopwords()) %>%
        # remove single character
        {
            gsub(patter = "\\b[A-z]\\b{1}", replace = " ", .)
        } %>%
        # collapse multiple spaces
        str_replace_all("\\s+", " ") %>%
        # lemmatization
        lemmatize_strings()
}

  
scoreResult <- function(resumepath, occupation=NA) {
    if ( is.na(occupation) ) {
        occupation <- read_excel("Occupation_Data.xlsx", col_names = c("title", "description"), skip = 1)
    }
    resume = read_file(resumepath)
    # make resume content a dataframe
    resume_df <- tibble(title = "User", description = resume)

    # combine resume and job description
    case_resume <- rbind(resume_df, occupation)


    #print(resume_df)
    # clean the job description data and create a new column
    case_resume$description_clean <- lemmatize_words(prep_fun(case_resume$description))

    # use vocabulary_based vectorization
    it_resume <- itoken(case_resume$description_clean, progressbar = FALSE)
    v_resume <- create_vocabulary(it_resume)

    # eliminate very frequent and very infrequent terms
    # v_resume = prune_vocabulary(v_resume, doc_proportion_max = 0.1, term_count_min = 5)
    # v_resume <- prune_vocabulary(v_resume)
    vectorizer_resume <- vocab_vectorizer(v_resume)

    # apply TF-IDF transformation
    dtm_resume <- create_dtm(it_resume, vectorizer_resume)
    tfidf <- TfIdf$new()
    dtm_tfidf_resume <- fit_transform(dtm_resume, tfidf)

    # compute similarity-score against each row
    resume_tfidf_cos_sim <- sim2(x = dtm_tfidf_resume, method = "cosine", norm = "l2")

    # create a new column for similarity_score of dataframe
    case_resume <- case_resume %>%
        mutate(similarity_score = resume_tfidf_cos_sim[1:nrow(resume_tfidf_cos_sim)])


    # sort the data frame by similarity score from the lowest to the highest
    case_resume_result <- case_resume %>%
        arrange(similarity_score %>% desc()) %>%
        select(c(title, similarity_score)) %>%
        top_n(21) %>%
        slice(2:n())

    return(case_resume_result)
}



# test = read_file("resume.txt")
# scoreResult(test)