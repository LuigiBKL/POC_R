library(shiny)
library(data.table)
library(RCurl)

RegData <- read.csv(text = getURL("https://simplonline-v3-prod.s3.eu-west-3.amazonaws.com/media/file/csv/a5707984-9111-4d36-9da9-4ab5d35162cd.csv") )

ui <- fluidPage(
  headerPanel("Regression and Time Series Analysis"), 
  sidebarPanel(
    p("Select the inputs for the Dependent Variable"),
    selectInput(inputId = "DepVar", label = "Dependent Variables", multiple = FALSE, choices = list("price")),
    p("Select the inputs for the Independent Variable"),
    selectInput(inputId = "IndVar", label = "Independent Variables", multiple = FALSE, choices = list( "squareMeters","numberOfRooms","hasYard","hasPool","floors","cityCode","cityPartRange","numPrevOwners","made","isNewBuilt","hasStormProtector","basement","attic","garage","hasStorageRoom","hasGuestRoom"))
  ),
  mainPanel(
    verbatimTextOutput(outputId = "RegSum"),
    verbatimTextOutput(outputId = "IndPrint"),
    verbatimTextOutput(outputId = "DepPrint"),
    plotOutput("displot")
  )
)

server <- function(input, output) {
  
  #lm1 <- reactive({lm(paste0(input$DepVar) ~ paste0(input$IndVar), data = RegData)})
  lm1 <- reactive({lm(reformulate(input$IndVar, input$DepVar), data = RegData)})
  output$DepPrint <- renderPrint({input$DepVar})
  output$IndPrint <- renderPrint({input$IndVar})
  output$RegSum <- renderPrint({summary(lm1())})
  
}

shinyApp(ui = ui, server = server)