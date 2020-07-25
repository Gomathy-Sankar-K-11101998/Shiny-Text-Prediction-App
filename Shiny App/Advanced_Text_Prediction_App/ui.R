#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    navbarPage("Text Prediction Application", 
               tabPanel("Text Prediction", 
                        sidebarLayout(
                            sidebarPanel(width = 4, 
                                         textInput("InputText", 
                                                   "Write the set of words here for Prediction: "), 
                                         htmlOutput("Information"), 
                                         h4("This app takes a little time to predict.")
                            ), 
                            
                            mainPanel(
                                htmlOutput("Predict_Word_Sent"), 
                                span(textOutput("PredictWord"), 
                                     style = "font-size:60px"), 
                                htmlOutput("Other_Word_Sent"), 
                                tableOutput("WordsTable")
                            )
                        )
               ), 
               tabPanel("Help Documentation", 
                        verbatimTextOutput("Document")
               )
    )
))
