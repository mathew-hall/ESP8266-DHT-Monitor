library(dplyr)
library(reshape2)
library(shiny)
library(ggplot2)
library(zoo)
library(scales)

DATA_SRC <- "../temperature.csv"

data <- read.csv(DATA_SRC,header=F)
names(data)<- c("Date", "Sensor", "Temperature", "Humidity")

data <- data %>% 
	filter(Temperature != 0 & Humidity != 0) %>%
	mutate(
		Temperature = Temperature * ifelse(Temperature <= 5, 10,1),
		Humidity = Humidity * ifelse(Humidity <= 5, 10,1)
	)

data$Date <- as.POSIXct(strptime(data$Date, format="%F %T"))




theme_set(theme_minimal())

shinyServer(function(input, output){
	
	wide <- reactive({data$SMA.Temperature <- rollmean(data$Temperature,input$sma_window,fill="expand")
data$SMA.Humidity <- rollmean(data$Humidity,input$sma_window,fill="expand")
data})
	
long <- reactive({melt(wide(), measure.vars=c("Temperature", "Humidity", "SMA.Temperature","SMA.Humidity"))})
  
  output$plot <- renderPlot({
    variables <- c("Temperature","Humidity")
    if(input$sma){
      variables <- c("SMA.Temperature","SMA.Humidity")
    }
  plot <- long() %>% filter(variable %in% variables)%>% ggplot(aes(Date, value, colour=variable)) 
		if(input$raw){
			plot <- plot + geom_line()
		}
		if(input$smooth){
			plot <- plot + geom_smooth()
		}
		if(input$rug){
			plot <- plot + geom_rug(sides="b", alpha=0.2, colour="black",size=0.1)
		}
		plot <- plot + scale_x_datetime(breaks=date_breaks("6 hour"),labels=date_format("%d %b %H:%M"))  + theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) + xlab("\n\nTime")
		
		#, minor_breaks=date_breaks("1 hour"))
		plot
  })
  
})