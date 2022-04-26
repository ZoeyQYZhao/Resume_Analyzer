#library(shiny)

# Define UI for app
my_ui <- shinyUI(
       navbarPage(
           # Fluid pages scale their components
           # in realtime to fill all available browser width
           # titlePanel: create a header panel containing an application title
           titlePanel(title = "Resume Analyzer"),
           wellPanel(
               p("Please upload your resume file as a plain text file."),
               p("When finished, you can download job Indeed table as excel file.")
           ),

           # SidebarLayout():create a layout with a sidebar and main area
           sidebarLayout(
               sidebarPanel(
                   # Inupt
                   fileInput("resume", "Upload Resume File (.txt)",
                       multiple = FALSE
                   ),
                   actionButton("go", "Submit",
                       style = "color: #fff; background-color: #337ab7"
                   ),
                   helpText("Default max. file size is 5MB"),
                   uiOutput("formatBtn"),
                   uiOutput("downloadBtn")
               ),
               mainPanel(
                   tabsetPanel(
                       type = "tabs",
                       tabPanel(
                           "Matched Occupation",
                           dataTableOutput("occupation_result"),
                           uiOutput("reportTitle"),
                       ),
                       tabPanel(
                           "Scrape Indeed",
                           #radioButtons("format", "Document format",
                              # c("PDF", "CSV"),
                              # inline = TRUE
                           #),
                           radioButtons("downloadType", "Download Type", 
                           choices = c("CSV" = ".csv",
                                       "JSON" = ".json",
                                       "XLSX" = ".xlsx",
                                       "TSV" = ".tsv"),
                           inline = TRUE),
                           downloadButton("downloadData", "Download"),
                           DT::dataTableOutput("job_result")
                       ),
                       tabPanel(
                           "Text Frequency",
                           tableOutput("text_frequency_resume"),
                           tableOutput("text_frequency_job")
                       )
                   ),
               )
           )
       )
   )


