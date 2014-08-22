library(shiny)
library("ggplot2")

load("out.RData")

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  
  output$summary <- renderPrint({
        
    sprintf( "Input Summary: %s", as.character(input$varReportStatus) )
  })
  
  
  output$distPlot <- renderPlot({
    
    if ( as.character(input$varReportStatus) == "All Data") x<-out
    else x<-out[out$ReportStatus == as.character(input$varReportStatus),]
    
    
    if ( input$varFatalInjuries ) x<-x[!is.na(x$TotalFatalInjuries),]
    
    #
    q95 <- data.frame( percentile = quantile(x$investigationTimeDay, 0.95))
    
    
    ggplot(x, aes(x = investigationTimeDays)) + 
      geom_histogram(binwidth = diff(range(log10(out$investigationTimeDay)))/30) + 
      scale_x_log10() +
      geom_vline(aes(xintercept = percentile), data = q95, 
                 colour="#BB0000", linetype="dashed") + 
      ggtitle(paste0( "Distribution of time (in days) between incident and report publication.\nReport type = ", 
                      as.character(input$varReportStatus), 
                      "\n95% percentile = ", as.numeric(round(q95)) 
                      )
              )

  }, height = 600, width = 600)
})