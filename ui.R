#this code alone will work
# 
# ui <- bootstrapPage(
#   selectInput('colorby', 'Color By', c('economy', 'displacement')),
#   chartOutput('p2', 'libraries/widgets/parcoords')
# )

shinyUI(fluidPage(
  navbarPage("R Shiny + GoogleVis Proof of Concept",
    tabPanel("Vis Examples",
                 tabsetPanel(
                   tabPanel('Gvis Sankey',sidebarLayout(               
                    sidebarPanel(
                                selectizeInput("psf", "Choose a dataset:", choices = c('',unique(dat$ProductSubFamily))),
                                selectizeInput("opn", "Choose OPN:", choices = c(''),multiple = TRUE),
                                actionButton("goButton", "Go!")
                              ),
                              mainPanel(htmlOutput('opngdview'))
                              )
                    ),
                   tabPanel('rChart', bootstrapPage(
                     selectInput('colorby', 'Color By', c('economy', 'displacement')),
                     chartOutput('p2', 'libraries/widgets/parcoords')
                   )
                   )
                 ) 
          
    )
  )

))