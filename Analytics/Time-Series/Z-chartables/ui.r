shinyUI(pageWithSidebar(
  headerPanel("Zchartables"),
  
  sidebarPanel(
    #Selector for file upload
    fileInput('datafile', 'Choose CSV file',
              accept=c('text/csv', 'text/comma-separated-values,text/plain')),
    #These column selectors are dynamically created when the file is loaded
    uiOutput("selectCol1"),
    uiOutput("selectCol2"),
    #The action button allows you to start analyzing
    actionButton("analysis", "Begin Forecast")
    
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("File Table",tableOutput("filetable")), 
      tabPanel("Analysis", plotOutput("salesAnalysis"))
    )
  )
))