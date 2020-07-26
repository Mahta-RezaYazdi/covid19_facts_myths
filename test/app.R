# ui
ui <- fluidPage(
  
  h1("testing"), 
  
  div("I can and I will do it"), 
  
  tabsetPanel(
    tabPanel("one", "content1"),
    tabPanel("two", "content2")
  ),
  
  sidebarLayout(
    sidebarPanel (
      
    ),
    mainPanel (
      
    )
  )
)

# server
server <- function(input, output) {}

# shinyapp
shinyApp(ui = ui, server = server)