list.of.packages <- c("shiny", "shinyjs", "shinyFiles", "fs", "knitr", "shinythemes", "htmlwidgets", "DT",
                      "rjson", "xlsx", "tidytext", "kableExtra", "rmdformats", "magrittr", "tinytex", "rvest",
                      "rmarkdown", "rsconnect", "tidyverse", "writexl", "dplyr", "text2vec", "readr",
                      "stringr", "stopwords", "textstem", "tm", "NLP", "quanteda", "corpus", "tibble",
                      "gsubfn", "plotly", "textrank", "udpipe", "xtable", "xml2", "readxl", "shinyWidgets")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if (length(new.packages)) install.packages(new.packages)

# # prepare environments
library("shinyWidgets")
library("htmlwidgets")
library("rjson")
library("xlsx")
library("xtable")
library("shiny")
library("udpipe")
library("readxl")
library("readr")
library("tibble")
library("textstem")
library("tm")
library("tidyverse")
library("text2vec")
library("textrank")
library("DT")
library("NLP")
library("rvest")
library("tidytext")
library("xml2")
library("rsconnect")
library("plotly")




#library(DT)
#library(xml2)
#library(shinythemes)
#library(tidytext)
# library(shinyjs)
# library(shinyFiles)
# library(fs)
# library(knitr)
# # library(kableExtra)
# library(rmdformats)
# library(magrittr)
# library(tinytex)
# library(rmarkdown)
# library(rsconnect)
# library(writexl)
# library(dplyr)
# library(stringr)
# library(stopwords)
# library(NLP)
# library(quanteda)
# library(corpus)
# library(gsubfn)
# library(plotly)


# tinytex::install_tinytex()
# install.packages("shinyFiles")
# install.packages("plotly")
#install.packages("xlsx")

