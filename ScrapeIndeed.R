# install.packages("tidyverse")
# install.packages("pacman")
# pacman::p_load(XML,rvest,jiebaR,dplyr,stringer)

library("tidyverse")
library("rvest")
library("xml2")

### url <- "https://www.indeed.com/jobs?q=data%20analyst&l&vjk=2f5b9951466183e2"
### page <- xml2::read_html(url)

page_result_start <- 0 # starting page
page_result_end <- 5 # last page results
page_results <- seq(from = page_result_start, to = page_result_end, by = 5)


full_df <- data.frame()

#occu_list <- c("Data Analyst", " Big Data", "Data Scientist")

#test_input <- c("Data Entry Keyer")

parse_job <- function(input_vector) {
    occu_list <- gsub(" ", "%20", input_vector)
    for (occu in occu_list) {

        # for(i in seq_along(page_results)){
        url <- paste0("https://www.indeed.com/jobs?q=", occu)
        page <- xml2::read_html(url)

        # Sys.sleep pauses R for two seconds before it resumes
        # Putting it there avoids error messages such as "Error in open.connection(con, "rb") : Timeout was reached"
        Sys.sleep(2)


        # get the job title
        job_title <- page %>%
           rvest::html_nodes("div") %>%
           rvest::html_nodes(xpath = '//*[@class = "jobTitle jobTitle-color-purple jobTitle-newJob"]')%>%
           rvest::html_nodes(xpath = '//span[@title]') %>%
           rvest::html_text() 

        # get the company name
        company_name <- page %>%
           rvest::html_nodes("span") %>%
           rvest::html_nodes(xpath = '//*[@class="companyName"]') %>%
           rvest::html_text()

        # get job location
        job_location <- page %>%
            #rvest::html_nodes("span") %>%
            rvest::html_nodes(xpath = '//div[@class="companyLocation"]') %>%
            rvest::html_text()

        # get job description snippet
        job_snippet <- page %>%
            rvest::html_nodes("div") %>%
            rvest::html_nodes(xpath = '//*[@class="job-snippet"]') %>%
            rvest::html_text()

        job_description <- paste(substr(job_snippet, 1, nchar(job_snippet) - 2), "...", sep = "")

        job_occupation <- gsub("%20", " ", occu)

        job_link <- page %>%
            rvest::html_nodes("a") %>%
            rvest::html_nodes(xpath = '//*[contains(@data-hide-spinner, "true")]') %>%
            rvest::html_attr("href")

        link <- paste("https://www.indeed.com", job_link, sep = "")

        #df <- data.frame(job_title, company_name, job_location, job_description, job_occupation, link)
        #names(df)[5] <- "description"
        #full_df <- rbind(full_df, df)
        
        #Avoid not find any jobs and return an error
        if (length(job_title) != 0){
          df <- data.frame(job_title, company_name, job_location, job_occupation, job_description, link)
          names(df)[5] <- "description"
          full_df <- rbind(full_df,df)
        } else {
          df <- data.frame(job_title = "No results found for this occupation", 
                           company_name = "N/A", 
                           job_location = "N/A", 
                           job_occupation,
                           job_description = "N/A",
                           link = "N/A")
          
          names(df)[5] <- "description"
          full_df <- rbind(full_df, df)
        }
        
    }
    return(full_df)
}

#parse_job(occu_list)
#parse_job(test_input)

# print(full_df)



