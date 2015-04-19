#Forecast algorithm
z.charting <- function(salesAnalysisPrevious, salesAnalysisRecent){
  # Previous Year Total
  previous.year.total <- sum(salesAnalysisPrevious)
  
  # Cumulative
  cumulative <- cumsum(salesAnalysisRecent)
  
  # Moving Total Average
  moving.average <- rep(0, length(salesAnalysisRecent))
  
  # Computes the first indexed moving average
  moving.average[1] <- previous.year.total + salesAnalysisRecent[1] - salesAnalysisPrevious[1]
  
  # Initiate at 2
  i <- 2
  
  # Computes the moving average for index 2 using the pre-calculated moving average at index 1
  repeat {
    
    moving.average[i] <- moving.average[i - 1] + salesAnalysisRecent[i] - salesAnalysisPrevious[i]
    
    if(i == length(salesAnalysisPrevious)) break
    
    i <- i + 1
    
  }
  
  return(moving.average) 
}

## server.r

shinyServer(function(input, output) {
  
  #This function is repsonsible for loading in the selected file
  filedata <- reactive({    
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(default.frame)
    }
    read.csv(infile$datapath)
  })
  
  #This previews the CSV data file
  output$filetable <- renderTable({
    filedata()
  })
  
  #This allows users to select the recent sales column
  output$selectCol1 <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    
    items=names(df)
    selectInput("selectRecent", "Select Recent Sales:",items)
    
  })
  
  #This allows users to select the previous sales column
  output$selectCol2 <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    
    items=names(df)
    selectInput("selectPrevious", "Select Previous Sales:",items)
  })
  
  
##
# This code is executed whenever the salesAnalysis Tab is opened. 
# It will collect the data.frame from filedata(), read the chosen
# column names from the input widgets, and pass the chosen columns
# to the z.charting function.
# 
# Plot the results of z.charting()
#


  #This allows the analysis to begin
  output$salesAnalysis <- renderPlot({
    prev <- input$selectPrevious
    recent <- input$selectRecent
    print(names(input))
    print(prev)
    print(recent)
    df <- filedata()
    print(df[c(prev, recent)])
    
    # Any logic for preparing the data for use in z.charting goes here.
    
    z.chart.data <- z.charting(df[,prev], df[,recent])
    plot(z.chart.data, xlab= "Months", xlim = range(1:12), 
         ylab = "Moving Average Sales", ylim = range(0:max(z.chart.data)), main = "Moving Average Trend", col= "blue")
    
    
  })
})
  