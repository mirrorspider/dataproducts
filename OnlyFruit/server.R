#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
require(RColorBrewer)

# Setup global data
data("Orange")
ora <- Orange
orig <- ora
bestFit <- lm(age ~ circumference, data = ora)
fit <- bestFit
selColor <- brewer.pal(5, "Set1")
unColor <- adjustcolor(selColor, alpha.f = 0.3)


updateModel <- function(selection){
        # generic code to fit a linear model
        # code by both input callbacks
        
        # if the selection length is 0, include all tree information
        if(length(selection) == 0){
                sel <- c(1:5)
        } else{
                sel <- selection
        }

        orig$selected <<- orig$Tree %in% sel
        ora <<- orig[orig$Tree %in% sel,]
        # fit a model based on the selected trees
        fit <<- lm(age ~ circumference, data = ora)

}

shinyServer(function(input, output) {
        output$orangePlot <- renderPlot({

                updateModel(input$treeChk)
                
                c <- input$circumference
                ic <- as.numeric(input$colour)

                p <- predict(fit, 
                             newdata = data.frame(
                                     circumference = input$circumference))
                pb <- predict(bestFit, 
                              newdata = data.frame(
                                      circumference = input$circumference))
                
                labeltxt <- paste(c, "mm\n", 
                                  format(round(p,0), nsmall = 0), "days")
                
                # plot the graph based on the dynamic information
                plot(age ~ circumference, data = orig, 
                     col = ifelse(selected, selColor[ic], unColor[ic]),
                     pch = 18, cex = 2, ylim = c(0,2500), xlim = c(0,250),
                     xlab = "circumference in mm", ylab = "age in days",
                     axes = FALSE)
                axis(1, col = "gray", pos = 0)
                axis(2, col = "gray", pos = 0)
                abline(fit, col = selColor[ic])
                abline(bestFit, col = unColor[ic])
                points(x = c, y = pb, 
                       col = unColor[ic], cex = 1, pch = 16)
                points(x = c, y = p, 
                       col = selColor[ic], cex = 2, pch = 21, bg = "white",
                       lwd = 2)
                text(x = c, y = p, labels = labeltxt, pos = 4)
                legend(x = 200, y = 500, legend = c("selected", "unselected"),
                       col = c(selColor[ic], unColor[ic]), pch = 18, pt.cex = 2)
})
  
        output$treeAge <- renderText({
                updateModel(input$treeChk)
                p <- predict(fit, 
                      newdata = data.frame(
                              circumference = input$circumference))
                #paste("The predicted age of the tree is:",
                #    format(round(p/(7*52),1), nsmall = 1), "years.")
                format(round(p/(7*52),1), nsmall = 1)
        })
})
