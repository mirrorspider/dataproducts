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
        
  tags$head(tags$style("
        #dispResult * {  
                display: inline;
        }")),
  
  # Application title
  titlePanel("Predict the Age of an Orange Tree",
             "Orange Prognostication"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
            sliderInput("circumference", 
                        paste("Enter the circumference (in mm)", 
                              "of the tree to predict its age (in years)"),
                        min = 30,
                        max = 210,
                        step = 5,
                        value = 100),
            checkboxGroupInput("treeChk", 
                          "Select trees to include in prediction algorithm:",
                          choiceNames = paste("tree", 1:5),
                          choiceValues = c(1:5),
                          selected = c(1:5)),
       radioButtons("colour",
                    "Pick a display colour:",
                    choiceNames = c("red", "blue", "green", "purple", "orange"),
                    choiceValues = 1:5,
                    selected = 5),
       hr(),
       em(paste("Alex Robinson"),br(),"Thu Feb 22 11:51:28 2018")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("orangePlot"),
       div(id = "dispResult", em("The predicted age of the tree is: ",
          strong(textOutput("treeAge")), "years.")),
       hr(),
       h3("Instructions"),
       p("This application is intended to be used to predict the age",
        "of an orange tree based on the Orange dataset provided with R."),
       p("Measure the distance around an orange tree at its", 
         "thickest point (its", em("circumference"),") and",
               "set the circumference slider on the left hand side to",
               "that value. The graph will adjust and a prediction",
               "for the age of the tree will be provided."),
       p("For additional granularity you can select the trees from", 
                "the source dataset used in",
               "making this prediction using the checkboxes provided.",
                "If no trees are selected, all 5 trees from the dataset will",
                "be used. If only a subset of the 5 trees are used, the ",
                "'5-tree' model will be displayed as a lighter line",
                "to allow comparison with the current model."),
       p("As a cosmetic change you can also choose the colour in which",
               "the graph is displayed.")
       
       )
    )
  )
)
