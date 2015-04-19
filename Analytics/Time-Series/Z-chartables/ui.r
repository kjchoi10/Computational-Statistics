library(shiny)

shinyUI(pageWithSidebar(
  headerPanel('Upload Files'),
      sidebarPanel(
        fileInput('file1', 'Choose CSV File', 
        accept=c('text/csv', 'text/comma-separated-values', 'ues', 'text/plain', '.csv')),
        checkboxInput('header', 'Header', TRUE),
        radioButtons('sep', 'Seperator', c(Comma=',', Semicolon=';', Tab='\t'), ','),
        radioButtons('quote', 'Quote', c(None='','Double Quote'='"','Single Quote'="'"),'"')),
        
        mainPanel(
        tableOutput('table.output')
        )
      ))




