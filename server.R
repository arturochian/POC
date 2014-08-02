cars <- read.csv('data/cars.csv')
p1 <- rCharts$new()
p2 <- rCharts$new()

# specify location of parcoords library folder.
p2$setLib('libraries/widgets/parcoords')
p2$set(padding = list(top = 24, left = 0, bottom = 12, right = 200))
p2$set(
  data = toJSONArray(cars, json = F), 
  colorby = 'economy', 
  range = range(cars$economy),
  colors = c('steelblue', 'brown')
)



shinyServer(function(input, output,session) { 
  dsInput <- reactive({
    if(!is.null(dat)){
      datSK <- subset(dat,ProductSubFamily ==input$psf,select=c(1:3))
    }    
    return(datSK)
  })
  
  fetchOPN <- reactive({
    opnList<- dsInput()[,c(1:1)]
  })
  
  fetchsubset <- reactive({
    ds <- dsInput()
    if(is.element('All', input$opn))
    {
      dssubset <- ds
    }
    else{
      dssubset <- ds[which(ds$To %in% input$opn),]
    }    

    return(dssubset)
  })
  
  observe({  
    updateSelectizeInput(session, "opn",choices = c('All',fetchOPN()))     
  })
  
  output$opngdview <- renderGvis({
    input$goButton
    isolate({
    gvisSankey(fetchsubset(), from="From", to="To", weight="QTY",
                         options=list(
                           height=800,
                           sankey="{link: {color: { fill: '#d799ae' } },
                           node: { color: { fill: '#a61d4c' },
                           label: { color: '#871b47' } }}"))
    }) 
  })
  
  output$p2 <- renderChart2({
    p2 <- rCharts$new()
    p2$setLib('libraries/widgets/parcoords')
    p2$set(padding = list(top = 24, left = 100, bottom = 12, right = 50))
    p2$set(
      data = toJSONArray(cars, json = F), 
      colorby = input$colorby, 
      range = range(cars[[input$colorby]]),
      colors = c('steelblue', 'brown'),
      width = 1400,
      height = 900
    )
    p2
  })
  
  
  
  selectedData <- renderText({ 
    paste("Selected:", input$selected)
  })
  
  #===
  #===
})
