# Import libraries
library(shiny)
library(shinythemes)
library(data.table)
library(randomForest)
#library(car)

# Read in the RF model
model <- readRDS("model.rds")

# Training set
Train <- read.csv("train.csv",sep=",", header = TRUE)
Train <- Train[,-1]


####################################
# User interface                   #
####################################

ui <- fluidPage(theme = shinytheme("superhero"),
  
  # Page header
  headerPanel('Prédiction des prix à paris selon le nbre de pièces et m²'),
  
  # Input values
  sidebarPanel(
    HTML("<h3>Input parameters</h4>"),
    sliderInput("squareMeters", label = "squareMeters", value = 89.0,
                min = min(Train$squareMeters),
                max = max(Train$squareMeters)
    ),
    
    sliderInput("numberOfRooms", label = "numberOfRooms", value = 3.6,
                min = min(Train$numberOfRooms),
                max = max(Train$numberOfRooms)),
    sliderInput("isNewBuilt", label = "isNewBuilt", value = 0.0,
                min = min(Train$isNewBuilt),
                max = max(Train$isNewBuilt)),
    sliderInput("cityCode", label = "cityCode", value = 3.0,
                min = min(Train$cityCode),
                max = max(Train$cityCode)),
    
  
    actionButton("submitbutton", "Prediction", class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h3('Sortie')), # Status/Output Text Box
    verbatimTextOutput('contents'),
    tableOutput('tabledata') # Prediction results table
    
  )
)

####################################
# Server                           #
####################################

server<- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    df <- data.frame(
      Name = c(
               "squareMeters",
               "numberOfRooms",
               "cityCode",
               "isNewBuilt"
               ),
      Value = as.character(c(input$squareMeters,
                             input$numberOfRooms,
                             input$cityCode,
                             input$isNewBuilt,
                             input$price)),
      stringsAsFactors = FALSE)
    
    price <- 0
    df <- rbind(df, price)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    Output <- data.frame(Prediction=predict(model,test),Devise="Euros")
    print(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Prediction terminée.") 
    } else {
      return("En attente.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}


# Create the shiny app

shinyApp(ui = ui, server = server)