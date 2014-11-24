# About

This script and Shiny app accompany the ESP8266 [temperature logger](https://github.com/mathew-hall/esp8266-dht). The listen.sh script receives updates on the configured UDP port and logs it to a CSV file via the `local_monitor.py` script.

The Shiny app loads the CSV file and displays a basic time series plot.

# Running the Monitor

Launch the `listen.sh` script on the host the ESP firmware sends the data to. By default it appends to `temperature.csv`, but this can be changed by adding the name as an argument to the `listen.sh` script.

# Running the Shiny App

If running on a separate server to the monitor, copy the `temperature.csv` file to the Shiny host. The app needs the `dplyr`,`reshape2`,`ggplot2` and `shiny` packages to be installed.

To launch the app, change to the `app` directory, start an R session and run `shiny::runApp()`.