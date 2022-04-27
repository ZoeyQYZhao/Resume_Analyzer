library(shinyWidgets)



shinyServer <- function(input, output, session) {
    # analysis resume and occupation
    restab <- eventReactive(input$go, {
        req(input$resume)
        scoreResult(input$resume$datapath)
    })

    #Scrape jobs from Indeed
    job_Indeed <- eventReactive(input$go_jobs, {
      selected <- c(input$ka, input$kb, input$kc)
      jobs <- parse_job(selected)
    })
    
    
    #Text frequency analysis
    text_freq <- eventReactive(input$go_jobs, {
      req(input$resume)
      extract_keywords(input$resume$datapath)
    })
    
    text_freq_jobs <- eventReactive(input$go_jobs, {
      req(input$resume)
      selected <- c(input$ka, input$kb, input$kc)
      feq <- parse_job(selected)$description
      extract_keywords(feq)
    })



    # occupation result output
    output$occupation_result <- renderDataTable(
        {
            restab()
        },
          #server = TRUE
    )

    # select 5 occupations
    output$reportTitle <- renderUI({
         #br()
         #fluidRow(
            #column(
               # width = 6,
                dropdownButton(
                  label = "Choose Occupations", status = "default", width = 600, 
                  icon = icon("bars"),
                  tooltip = "Click the button to choose occupations", circle = FALSE,
                  tags$h3("Choose 5 Matching Occupations:"),
                  br(),
                  fluidRow(
                    column(
                            width = 4,
                            checkboxGroupInput(inputId = "ka", label = NULL, choices = restab()$title[1:7])
                        ),
                        column(
                            width = 4,
                            checkboxGroupInput(inputId = "kb", label = NULL, choices = restab()$title[8:14])
                            ),
                        column(
                            width = 4,
                            checkboxGroupInput(inputId = "kc", label = NULL, choices = restab()$title[15:20])
                        )
                    ),
                actionButton("go_jobs", "Submit", style = "color: #fff; background-color: #337ab7")
                )
             #)
         # )
      })

    observeEvent(input$go_jobs, {
      updateTabsetPanel(session = session, inputId = "tabs", selected = "Scrape Indeed")
    })
    
    
    # input number cannot more than 5 occupations
    observe({
      if(length(c(input$ka, input$kb, input$kc)) > 5){
        showModal(modalDialog(tags$h3('Please Only Select up to 5 Occupations!')
        ))
        updateCheckboxGroupInput(session, "ka", selected = character(0))
        updateCheckboxGroupInput(session, "kb", selected = character(0))
        updateCheckboxGroupInput(session, "kc", selected = character(0))
      }
    })

    #jobs from Indeed output
    

    # job scrape output
    output$job_result <- DT::renderDataTable(
        {
            withProgress(
                message = "Analyzing",
                detail = "this may take a few minutes...",
                value = 10,
                job_Indeed()
            )
        },
        options = list(autoWidth = TRUE,
                       scrollX = TRUE,
                       columnDefs = list(list(
                         render = JS(
                           "function(data, type, row, meta) {",
                           "return type === 'display' && data.length > 50 ?",
                           "'<span title=\"' + data + '\">' + data.substr(0, 50) + '...</span>' : data;",
                           "}"),
                         targets = (6))
                       )
        ),
        server = TRUE
    )

    # download job result
    output$downloadData <- downloadHandler(
        #filename = function() {
            #radioButtons("format", "Document format", c("PDF", "Excel"), inline = TRUE)
           # paste("data-", Sys.Date(), '.csv', sep = " ")
        #},
        #content = function(con) {
            #write.csv(job_Indeed(), con)
          
        filename = function() {
          paste0(input$job_result, "_Table", input$downloadType)
        },
        content = function(file) {
          if(input$downloadType == ".csv") {
            write.csv(job_Indeed(), file, row.names = FALSE)
          } else if(input$downloadType == ".json") {
            exportJSON <- toJSON(job_Indeed())
            write(exportJSON, file)
          } else if(input$downloadType == ".xlsx") {
            write.xlsx(job_Indeed(), file, 
                       sheetName = "Sheet1", row.names = FALSE)
          } else if(input$downloadType == ".tsv") {
            write.table(job_Indeed(), file, quote = FALSE, 
                        sep='\t', row.names = FALSE)
          }
        }
    )

    # Text frequency analysis output
    resume_caption_str <- as.character(shiny::tags$h3( "Text Frequency of Resume"))
    jd_caption_str <- as.character(shiny::tags$h3( "Text Frequency of Job Description"))
    
    #output <- data.frame(matrix(ncol = 3, nrow = 0))
    
    fluidRow(
      div(
        width = 8,
        output$text_frequency_resume <- renderTable(
          {withProgress(message = "Analyzing",
                        detail = "this may take a few minutes...",
                        value = 10,
                        {text_freq()})
          },
          caption = resume_caption_str,
          caption.placement = getOption("xtable.caption.placement", "top"),
          caption.width = getOption("xtable.caption.width", NULL),
          server = TRUE)
      ),
      div(
        width = 8,
        output$text_frequency_job <- renderTable(
          {withProgress(message = "Analyzing",
                        detail = "this may take a few minutes...",
                        value = 10,
                        {text_freq_jobs()})
          },
          caption = jd_caption_str,
          caption.placement = getOption("xtable.caption.placement", "top"),
          caption.width = getOption("xtable.caption.width", NULL),
          server = TRUE)
      ))
    
    
    # stop when closed web tab 
    session$onSessionEnded(stopApp)
}








