library(shiny)
library(ggplot2)
library(dplyr)




Covid_data <- read.csv("Covid_data")

# Define UI for application that draws a histogram
ui <- fluidPage(theme = "app.css", 
  
  # title
  titlePanel("COVID19 Myths and Facts Analyzation"),
  
  
  # main image
  fluidRow ( 
    column(12, 
           tags$img(src = "covid_image.jpg")
    )
  ),

  
  # problem statement
  fluidRow( 
    column(12, 
           
           # title
           h4("Problem statement"),
           
           # body
           div("As the world continues to fight the spread of COVID19 and we gradually 
               reopen our communities, monitoring public health is essential for 
               everyone's safety! Since COVID19 is a new virus, the world currently 
               is faced with uncertainty and the unknown. In order to protect ourselves 
               and others around us, we need to know COVID19 facts and take appropriate 
               precautions. Our aim is to first, raise awareness about COVID19, by analysing 
               it’s most common myths and facts based on trustworthy datasets, second, 
               analise how seriously people take the COVID19 rules and facts through easy to 
               understand visuals, to help stop the spread of rumours and the disease as the 
               situation with COVID19 continues."),
           
           # line break
           br(), 
           
           
           # title
           h4("About InfoGears"),
           
           # about infogears
           div(
               a(href="https://infogears.org/", "Infogears dataset"), 
               "is maily used to do the analysis. Infogears is a 
               crowdsourced COVID-19 symptoms data site for your local community.
               Infogears data platform was created to rely on crowdsourcing and 
               self-reporting. Infogear's goal is to to help local communities 
               visualize the prevalence of coronavirus symptoms and other aspects of life 
               impacted by the crisis. Infogears believes that since symptoms come before 
               positive case identification, therefore are predictive. It's outcome is 
               that predicted coming up cases increase or decrease in a local area. 
               This FREE project is made possible by the NetGenix Inc."), 
           
           
           # line separator
           hr(),
    )
  ), 
  

  # data description
  fluidRow(
    column(12, 
           
           # tilte
           h4("InfoGears Dataset Description"),
           
           # body
           div(
             "The infogears dataset has the following features:",
             br(), 
             br(), 
             "Age  -  18-25, 26-35, 36-45, 46-55, 56-65, 65-75, 75+", 
             br(), 
             "Antibody test  -  negative, notTested, positive", 
             br(), 
             "Created at  -  created at date and time", 
             br(), 
             "Exposure level  -  doNotKnow, haveDirectContact", 
             br(), 
             "Face covering  -  ",
             br(), 
             "Gender  -  female, male, notShared, notWantToShare, other", 
             br(),
             "Guid  -  guid " ,
             br(),
             "Health issues  -  chronicIssues, noIssues, someIssues",
             br(),
             "House hold head count  -  number of house hold",
             br(),
             "Ip  -  ip address",
             br(),
             "Left home times  -  didNotLeave, oneTime, twoTimesOrMore",
             br(),
             "Mental health impact  -  noImpact, significantImpact, someImpact",
             br(),
             "Updated at  -  updated at date and time",
             br(),
             "User agent  -  user agent",
             br(),
             "Virus test  -  awaitingResults, negative, notTested, positi",
             br(),
             "Zip code  -  zip code",
             br(),br(), 
             "Body ache, Diarrhea, Difficulty breathing, Disorientation, Fatigue, 
              Headache, Irritated eyes, Persistent cough, Sore throat, Temperature, 
              Loss of smell  and ‘no symptoms’ indicate having  COVID19 symptoms and their 
              values are just 0 or 1 (true or false). Left for exercise , Left for others, 
              Left for shopping, Left for work values are also only 0 and 1.These columns 
              are of Factor type.", 
              br(),br(), 
             "Data is categorized by individual ZIP codes. 
              In this dataset columns age, guid, ip and zipCode are 
              of Character type, the rest are of numeric type.", 
              br(), 
              "Overall there are 16,768 observations in the dataset."),
           
           
           # line break
           br(), 
           
      
           #title
           h4("Changed or Added Columns"),
           
           # line break
           br(), 
           
           tags$table(
                tags$thead(
                     tags$tr(
                        tags$th(colspan = 2,
                                width = 500)
                    )
                ), 
                
                tags$tbody(
                      tags$tr(
                          tags$td(align = "center", "Person's wellness"),
                          tags$td(align = "center", "isEmployer")
                       ),
                      tags$tr(
                          tags$td(align = "center", "0 / 1"),
                          tags$td(align = "center", "0 / 1")
                      )
                ), 
              
                tags$tbody(
                  tags$tr(
                    tags$td(align = "center", "Left not for work"),
                    tags$td(align = "center", "very high exposure")
                  ),
                  tags$tr(
                    tags$td(align = "center", "0 / 1"),
                    tags$td(align = "center", "0 / 1")
                  )
                )
           ),
           
           
           br(), 
           
           # line separator
           hr(),
    )
  ),
  
  # fact 1 
  fluidRow(
      column(12, 
      # Does physical health condition affect the level of vulnerability to COVID19
      
      # title
      h4("Does physical health condition affect the level of vulnerability to COVID19?"), 
      
      # fact 1
      div("According to", 
          a(href="https://www.health.gov.au/news/health-alerts/novel-coronavirus-2019-ncov-
            health-alert/advice-for-people-at-risk-of-coronavirus-covid-19/coronavirus-covid-
            19-advice-for-people-with-chronic-health-conditions", 
            "Australian Government, Department of Health"), 
            ", Anyone could develop serious or severe illness from COVID-19, but those with 
            chronic health conditions or weakened immune systems are at greater risk."), 
      
      # line break
      br(), 
      
      # guidance
      div("You can check the truthness of this statement by choosing three different
          physical health conditions and chek the resulting barcharts."), 
      
      # line break
      br(), 
    )
  ), 
  
  # fact 1 analyzation
  fluidRow(
    # input 
    column(12, 
       radioButtons(inputId = "gender", 
                    label = h5("Choose a gender"),
                    choices = list("Female" = "female", 
                                    "Male" = "male", 
                                    "Other" = "other"), 
                    selected = "female"),   
       # chart output
       plotOutput("barchart")
      ),
  )
)



# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # chosen health condition reactive data
  chosen_gender_data <- reactive({
    Covid_data %>%
      filter(gender == input$gender, 
             Person_Wellness == "Some symptoms", 
             virusTest == c("positive", "negative")) 
  })
  
  # fact 1 output
  output$barchart <- renderPlot({
    ggplot(chosen_gender_data(), aes(virusTest, fill = virusTest)) + 
      facet_wrap(~healthIssues) + 
      labs(title = "Testing Results Based on Physical Health Condition") + 
      geom_bar( 
        color = "white", 
        size = 0.5, 
        width = 0.9, 
        alpha = 0.5)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)


