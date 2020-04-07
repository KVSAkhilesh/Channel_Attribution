library(shiny)

shinyUI(navbarPage("Channel Attribution Model", 
                   
                   
                   tabPanel(
                     "Input",
                   sidebarLayout(
                       sidebarPanel(
                         fileInput('file1', 'Upload input data',
                                   accept=c('text/csv', 
                                            'text/comma-separated-values,text/plain', 
                                            '.csv')),
                         tags$hr(),
                         checkboxInput('header', 'Headers', TRUE),
                         numericInput('markov_order','Order of Makov',min = 1, max = 15, value = 1),
                         radioButtons('sep', 'Separator',
                                      c('Semi-Colon'=';',
                                        'Comma'=',',
                                        'Tab'='\t'),
                                      ';'),
                         radioButtons('quote', 'Quote',
                                      c('Null'='',
                                        'Double Qoute'='"',
                                        'Single Quote'="'"),
                                      '"'),
                         downloadButton('downloadData', 'Download')
                         
                         
                         ),
                       mainPanel(
                               tabsetPanel(type = "tabs",
                                           
                                           
                                           tabPanel("Tables", tableOutput("table")),
                                           tabPanel("Results", tableOutput("results")),
                                           tabPanel("Plots", plotOutput("plots"))
                                           ),
                               tableOutput('Results')
                              
                               
                                )
                              )
                           )
)
)