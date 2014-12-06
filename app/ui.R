
library(shiny)
shinyUI(fluidPage(
  
	titlePanel("Sensor Data"),
      sidebarLayout(
        sidebarPanel("Options", 
				checkboxInput("Show all", inputId="all",T),
				conditionalPanel(
						condition="!input.all",
						uiOutput("daterange")
				),

                checkboxInput("Moving average", inputId="sma",F),
				conditionalPanel(
					condition="input.sma",
					sliderInput("Moving average window", inputId="sma_window", 1, 180, value=15)
				),
				checkboxInput("Show rug", inputId="rug",F)
		),
        mainPanel(plotOutput(outputId = "plot"))
    )
))