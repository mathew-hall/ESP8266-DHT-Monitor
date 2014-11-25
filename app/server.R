library(dplyr)
library(reshape2)
library(shiny)
library(ggplot2)
DATA_SRC <- "../temperature.csv"

data <- read.csv(DATA_SRC,header=F)
names(data)<- c("Date", "Sensor", "Temperature", "Humidity")

data$Date <- as.POSIXct(strptime(data$Date, format="%F %T"))

long <- melt(data, measure.var=c("Temperature", "Humidity"))

#Rescale old values if they're out of the expected range
long$value <- long$value * ifelse(long$value <= 5,10,1)

long <- long %>% filter(value != 0)

theme_set(theme_minimal())

shinyServer(function(input, output){
  
  output$plot <- renderPlot({
    plot <- long %>% ggplot(aes(Date, value, colour=variable)) 
		if(input$raw){
			plot <- plot + geom_line()
		}
		if(input$smooth){
			plot <- plot + geom_smooth()
		}
		if(input$rug){
			plot <- plot + geom_rug(sides="b", alpha=0.2, colour="black",size=0.1)
		}
		plot
  })
  
})