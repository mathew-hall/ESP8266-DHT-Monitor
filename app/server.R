library(dplyr)
library(reshape2)
library(shiny)
library(ggplot2)
library(zoo)
library(scales)

db <- src_mysql("sensors", "bmo.local", user="", port=3306)
#names(data)<- c("Date", "Sensor", "Temperature", "Humidity")

data <- tbl(db, "logs")


theme_set(theme_minimal())

shinyServer(function(input, output){
	
	long <- reactive({
		data %>% collect %>%
		mutate(date = as.POSIXct(strptime(date, format="%F %T"))) %>%
		group_by(sensor,reading) %>%
		mutate(SMA = rollmean(value,input$sma_window,fill="expand"))
	})
  
  output$plot <- renderPlot({
    response <- "value"
    if(input$sma){
			response <- "SMA"
    }
	
  plot <- long() %>% ggplot(aes_string("date", response, colour="sensor")) 
		if(input$raw){
			plot <- plot + geom_line()
		}
		if(input$smooth){
			plot <- plot + geom_smooth()
		}
		if(input$rug){
			plot <- plot + geom_rug(sides="b", alpha=0.2, colour="black",size=0.1)
		}
#		plot <- plot + scale_x_datetime(breaks=date_breaks("4 hour"), minor_breaks=date_breaks("1 hour"), labels=date_format("%d %b %H:%M"))  
		plot <- plot + theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) + xlab("\n\nTime") + facet_grid(reading ~ ., scales="free_y")
		
		#
		plot
  })
  
})