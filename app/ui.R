
library(shiny)
shinyUI(fluidPage(
  
	titlePanel("Sensor Data"),
      sidebarLayout(
        sidebarPanel("Options", 
					checkboxInput("Smooth values",inputId="smooth",F),
                    checkboxInput("Moving average", inputId="sma",F),
					sliderInput("Moving average window", inputId="sma_window", 1, 180, value=15),
					checkboxInput("Show raw", inputId="raw", T),
					checkboxInput("Show rug", inputId="rug", F)),
        mainPanel(plotOutput(outputId = "plot"))
    )
))