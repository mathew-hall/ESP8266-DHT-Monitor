library(dplyr)
library(reshape2)
library(shiny)
library(ggplot2)
library(zoo)
library(scales)

db <- src_mysql("sensors", "bmo.local", user="", port=3306)
#names(data)<- c("Date", "Sensor", "Temperature", "Humidity")

data <- tbl(db, "logs")

data <- data %>% mutate(ip_addr = INET_NTOA(ip))

dates <- data %>% summarise(min = min(date), max=max(date)) %>% collect
date.min <- dates$min[1]
date.max <- dates$max[1]

theme_set(theme_minimal())

readTimestamp <- function(){
		latest <- data %>% summarise(max=max(date)) %>% collect
		cat("Checking")
		latest$max[1]
}

pad_rollmean <- function(value,window){
	if(window > length(value)){
		return(as.numeric(c(NA)))
	}
	rollmean(value, window, na.pad=TRUE, align="right")
}
getLatestData <- function(input){
	function(){
		subset <- data
		
		if(!input$all){
			ranges <- as.character(input$dates)
			mindate <- ranges[1]
			maxdate <- ranges[2]
			subset <- data %>% filter(date >= mindate & date <= maxdate)
		}
		cat("Updating")
		subset %>% collect %>%
		mutate(date = as.POSIXct(strptime(date, format="%F %T"))) %>%
		group_by(ip,sensor,reading) %>%
		mutate(SMA = pad_rollmean(value,input$sma_window))
	}
	
}

shinyServer(function(input, output){
	
	output$daterange <- renderUI({
		dateRangeInput("dates","Date Range:", min=date.min, max=date.max)
		})
#		reactivePoll(intervalMillis, session, checkFunc,
#		    valueFunc)
	long <- reactivePoll(30000,NULL,readTimestamp,getLatestData(input))
  
  output$plot <- renderPlot({
    response <- "value"
    if(input$sma){
			response <- "SMA"
    }
	
  plot <- long() %>% ggplot(aes_string("date", response, colour="ip_addr",linetype="sensor")) 
		plot <- plot + geom_line()
		
		
		if(input$rug){
			plot <- plot + geom_rug(sides="b", alpha=0.2, colour="black",size=0.1)
		}
#		plot <- plot + scale_x_datetime(breaks=date_breaks("4 hour"), minor_breaks=date_breaks("1 hour"), labels=date_format("%d %b %H:%M"))  
		plot <- plot + theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) + xlab("\n\nTime") + facet_grid(reading ~ ., scales="free_y")
		
		#
		plot
  })
  
})