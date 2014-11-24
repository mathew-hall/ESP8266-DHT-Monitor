library(dplyr)
library(reshape2)
library(shiny)
library(ggplot2)
DATA_SRC <- "../temperature.csv"

data <- read.csv(DATA_SRC,header=F)
names(data)<- c("Date", "Sensor", "Temperature", "Humidity")

data$Date <- as.POSIXct(strptime(data$Date, format="%F %T"))

long <- melt(data, measure.var=c("Temperature", "Humidity"))

shinyServer(function(input, output){
  
  output$plot <- renderPlot({
    long %>% ggplot(aes(Date, value, colour=variable)) + geom_line()
  })
  
})