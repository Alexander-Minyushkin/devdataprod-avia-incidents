library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Avia incidents investigation time"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
      selectInput("varReportStatus", "Report Status:",
                  list("Preliminary",
                       "Factual",
                       "Foreign",
                       "Probable Cause", 
                       "All Data")
      ),
      checkboxInput("varFatalInjuries", "Acidents with fatal injures only", FALSE)
  ),
    
  
  # Show a plot of the generated distribution
  mainPanel(
    #verbatimTextOutput("summary"),
    h5("Data collected from NTSB Aviation Accident Database"),
    a("http://catalog.data.gov/dataset/ntsb-aviation-accident-database-extract-of-aviation-accident-records-since-1982--ntsb-1962",
      href="http://catalog.data.gov/dataset/ntsb-aviation-accident-database-extract-of-aviation-accident-records-since-1982--ntsb-1962"),

    br(),
    
    plotOutput("distPlot", width = "100%")
  )
))