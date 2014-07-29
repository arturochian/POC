# this code alone will work
# ui <- bootstrapPage(
#   selectInput('colorby', 'Color By', c('economy', 'displacement')),
#   chartOutput('p1', 'libraries/widgets/parcoords')
# )

shinyUI(fluidPage(
  navbarPage("R Shiny + GoogleVis Proof of Concept",
    tabPanel("Vis Examples",
                 tabsetPanel(
                   tabPanel('OPN GD Mapping',sidebarLayout(               
                    sidebarPanel(
                                selectInput("psf", "Choose a dataset:", choices = unique(dat$ProductSubFamily)),
                                #checkboxGroupInput("opn", "Choose OPN:", choices = c('')),
                                selectizeInput('opn', 'Choose OPN:', choices = c(''), multiple = TRUE),
                                actionButton("goButton", "Go!")
                              ),
                              mainPanel(htmlOutput('opngdview'))
                              )
                    ),
                   tabPanel('Motion Chart',htmlOutput('opngdview3')),
                   tabPanel('rChart',sidebarLayout(                     
                     sidebarPanel(
                       selectInput(inputId = "x",
                                   label = "Choose X",
                                   choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
                                   selected = "SepalLength"),
                       selectInput(inputId = "y",
                                   label = "Choose Y",
                                   choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
                                   selected = "SepalWidth")
                     ),
                     mainPanel(
                       showOutput("myChart", "polycharts")
                     )
                    )
                   )
                 ) 
          
    ),
    tabPanel("Append DIM",
             sidebarLayout(
               sidebarPanel(
                 fileInput('file1', 'Choose file to upload',
                           accept = c('text/csv','text/comma-separated-values','text/tab-separated-values','text/plain','.csv')
                 ),
                 tags$hr(),
                 checkboxInput('header', 'Header', TRUE),
                 radioButtons('sep', 'Separator',c(Comma=',',Semicolon=';',Tab='\t'),'\t'),
                 tags$hr(),
                 actionButton("goButton2", "Fetch Data"),
                 actionButton("goButton3", "Append DIM Data"),
                 tags$hr(),
                 downloadButton('downloadData', 'Download Compiled File')
               ),
               mainPanel(
                 checkboxGroupInput("SelectCol","Col to Show",c('')),
                 tableOutput('contents'),
                 tableOutput('joined')
               )
             )
             
    ),
    tabPanel('rChart',
             bootstrapPage(
               selectInput('colorby', 'Color By', c('economy', 'displacement')),
               chartOutput('p2', 'libraries/widgets/parcoords')
             )
             
    ),
    tabPanel("Cleanse Data"),
    tabPanel("TBOR Data Feed")
  )

))