
library(shiny)
shinyUI(fluidPage(
  
	titlePanel("Sensor Data"),
      sidebarLayout(
        sidebarPanel("Options"),
        mainPanel(plotOutput(outputId = "plot"))
    )
))