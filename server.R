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
    updateCheckboxGroupInput(session, "opn",choices = c('All',fetchOPN()))     
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


  output$opngdview3 <- renderGvis({
    gvisMotionChart(data2, idvar='OPN', timevar='Date')
    
  })
  
  output$myChart <- renderChart({
    names(iris) = gsub("\\.", "", names(iris))
    p1 <- rPlot(input$x, input$y, data = iris, color = "Species", 
                facet = "Species", type = 'point')
    p1$addParams(dom = 'myChart')
    return(p1)
  })
  
  
  output$p2 <- renderChart2({
    p2 <- rCharts$new()
    p2$setLib('libraries/widgets/parcoords')
    p2$set(padding = list(top = 24, left = 0, bottom = 12, right = 50))
    p2$set(
      data = toJSONArray(cars, json = F), 
      colorby = input$colorby, 
      range = range(cars[[input$colorby]]),
      colors = c('steelblue', 'brown'),
      width = 300
    )
    p2
  })
  
  
  
  selectedData <- renderText({ 
    paste("Selected:", input$selected)
  })
  
  #===
  
  updateData <- reactive({
      inFile <- input$file1    
      if (is.null(inFile)) {return(NULL)}    
      uploadeddata <- read.csv(inFile$datapath, header = input$header,sep = input$sep) 
  })
  
  fetchCol <- reactive({
      colList <- colnames(updateData())
  })
  
  observe({
      var_A <- fetchCol()
      updateCheckboxGroupInput(session, 'SelectCol',choices = var_A,select = var_A)
      
  })
  
  output$contents <- renderTable({
    dat <- updateData()
    if(input$goButton2)
    {
      src <<- dat[,input$SelectCol]
    }
    head(src,10)
  })
  
  output$joined <- renderTable({
    if(input$goButton3)
    {
      newdata <<- merge(x = src, y = DIM, by.x = 'DEMAND_ITEM', by.y = 'OARSPartName', all.x=TRUE)
      head(newdata,5)
    }
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste('transformed.csv', sep='\t')
    },
    content = function(file) {
      write.csv(newdata, file, row.names=FALSE)
    }
  )
  #===
})
