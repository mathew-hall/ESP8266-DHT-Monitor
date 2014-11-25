
library(shiny)
shinyUI(fluidPage(
  
	titlePanel("Sensor Data"),
      sidebarLayout(
        sidebarPanel("Options", 
					checkboxInput("Smooth values",inputId="smooth",F),
					checkboxInput("Show raw", inputId="raw", T)),
        mainPanel(plotOutput(outputId = "plot"))
    )
))