
library(shiny)
shinyUI(fluidPage(
  
	titlePanel("Sensor Data"),
      sidebarLayout(
        sidebarPanel("Options", 
					checkboxInput("Smooth values",inputId="smooth",F),
					checkboxInput("Show raw", inputId="raw", T),
					checkboxInput("Show rug", inputId="rug", F)),
        mainPanel(plotOutput(outputId = "plot"))
    )
))