library(shiny)

shinyServer(function(input, output) {
  
  output$table.output <- renderTable({
    
    inFile <- input$file1
    
    if (is.null(inFile))
    return(NULL)
    
    read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
  })

  output$print <- renderTable({
    previous.year <- input$inFile[1]# stuck on how to get the fourth column of data in the csv
    #current.year <- 
    print(previous.year)
  })
  

  
})