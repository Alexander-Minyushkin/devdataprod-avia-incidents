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
    h5("Documentation can be found here"),
    a("https://github.com/Alexander-Minyushkin/devdataprod-avia-incidents",
      href="https://github.com/Alexander-Minyushkin/devdataprod-avia-incidents"),

    br(),
    
    plotOutput("distPlot", width = "100%")
  )
))