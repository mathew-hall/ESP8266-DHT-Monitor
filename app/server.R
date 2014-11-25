library(dplyr)
library(reshape2)
library(shiny)
library(ggplot2)
DATA_SRC <- "../temperature.csv"

data <- read.csv(DATA_SRC,header=F)
names(data)<- c("Date", "Sensor", "Temperature", "Humidity")

data$Date <- as.POSIXct(strptime(data$Date, format="%F %T"))

long <- melt(data, measure.var=c("Temperature", "Humidity"))

long$value <- long$value * ifelse(long$value <= 5,10,1)

shinyServer(function(input, output){
  
  output$plot <- renderPlot({
    plot <- long %>% ggplot(aes(Date, value, colour=variable)) 
		if(input$raw){
			plot <- plot + geom_line()
		}
		if(input$smooth){
			plot <- plot + geom_smooth()
		}
		plot
  })
  
})