# import libraries
library(dplyr)
library(ggplot2)
library(readxl)
library(shiny)


# import datasets
# infogears_covid_data <- read_excel("covid-06-27-2020.xlsx")
# 
# 
# # data cleaning
# # replace all "didNotLefts" to "didNotLeave" in lefHomeTimes
# infogears_covid_data <- infogears_covid_data %>%
#   mutate(leftHomeTimes = ifelse(leftHomeTimes == "didNotLeft", "didNotLeave", leftHomeTimes))
# 
# # replace all "notWantToShare" to "notShared"
# infogears_covid_data <- infogears_covid_data %>%
#   mutate(gender = ifelse(gender == "notWantToShare", "notShared", gender))
# 
# # add Person_Wellness depending on having symptoms
# infogears_covid_data <- infogears_covid_data %>%
#   mutate(Person_Wellness = ifelse(noSymptoms == 1, "No symptoms", "Some symptoms"))
# 
# 
# # categorical variable
# # no sypmtoms, some symptoms
# infogears_covid_data$Person_Wellness <-
#   as.factor(infogears_covid_data$Person_Wellness)
# 
# # negative, notTested, positive
# infogears_covid_data$antibodyTest <-
#   as.factor(infogears_covid_data$antibodyTest)
# 
# # doNotKnow, haveDirectContact
# infogears_covid_data$exposureLevel <-
#   as.factor(infogears_covid_data$exposureLevel)
# 
# # female, male, notShared, notWantToShare, other
# infogears_covid_data$gender <-
#   as.factor(infogears_covid_data$gender)
# 
# # chronicIssues, noIssues, someIssues
# infogears_covid_data$healthIssues <-
#   as.factor(infogears_covid_data$healthIssues)
# 
# # didNotLeave, oneTime, twoTimesOrMore
# infogears_covid_data$leftHomeTimes <-
#   as.factor(infogears_covid_data$leftHomeTimes)
# 
# # noImpact, significantImpact, someImpact
# infogears_covid_data$mentalHealthImpact <-
#   as.factor(infogears_covid_data$mentalHealthImpact)
# 
# # awaitingResults, negative, notTested, positive
# infogears_covid_data$virusTest <-
#   as.factor(infogears_covid_data$virusTest)
# 
# # 0, 1
# infogears_covid_data$bodyAche <-
#   as.factor(infogears_covid_data$bodyAche)
# 
# # 0, 1
# infogears_covid_data$diarrhea <-
#   as.factor(infogears_covid_data$diarrhea)
# 
# # 0, 1
# infogears_covid_data$difficultyBreathing <-
#   as.factor(infogears_covid_data$difficultyBreathing)
# 
# # 0, 1
# infogears_covid_data$disorientation <-
#   as.factor(infogears_covid_data$disorientation)
# 
# # 0, 1
# infogears_covid_data$fatigue <-
#   as.factor(infogears_covid_data$fatigue)
# 
# # 0, 1
# infogears_covid_data$headAche <-
#   as.factor(infogears_covid_data$headAche)
# 
# # 0, 1
# infogears_covid_data$irritatedEyes <-
#   as.factor(infogears_covid_data$irritatedEyes)
# 
# # 0, 1
# infogears_covid_data$lossOfSmell <-
#   as.factor(infogears_covid_data$lossOfSmell)
# 
# # 0, 1
# infogears_covid_data$persistentCough <-
#   as.factor(infogears_covid_data$persistentCough)
# 
# # 0, 1
# infogears_covid_data$soreThroat <-
#   as.factor(infogears_covid_data$soreThroat)
# 
# # 0, 1
# infogears_covid_data$temperature <-
#   as.factor(infogears_covid_data$temperature)
# 
# # 0, 1
# infogears_covid_data$leftForExercise <-
#   as.factor(infogears_covid_data$leftForExercise)
# 
# # 0, 1
# infogears_covid_data$leftForShopping <-
#   as.factor(infogears_covid_data$leftForShopping)
# 
# # 0, 1
# infogears_covid_data$leftForWork <-
#   as.factor(infogears_covid_data$leftForWork)
# 
# # infogears_covid_data$faceCovering <-
# #   as.factor(infogears_covid_data$faceCovering)
# 
# 
# # reorder levels
# levels(infogears_covid_data$healthIssues) <- c("noIssues", "someIssues", "chronicIssues")
# levels(infogears_covid_data$mentalHealthImpact) <- c("noImpact", "someImpace", "significantImpact")
# levels(infogears_covid_data$virusTest) <- c("notTested", "awaitingResults", "negative", "positive")
# levels(infogears_covid_data$gender) <- c("female", "male", "other", "notShared")


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
           div("Since COVID19 is a new virus, the world is faced with 
                uncertainty and the unknown. In order to protect ourselves 
                and others around us, we need to know COVID19 facts and 
                take appropriate precautions. Our aim is to raise awareness 
                about COVID19, by analysing it’s most common myths and facts 
                based on trustworthy datasets, to help stop the spread of 
                rumours and the disease as the situation with COVID19 continues. "),
           
           # line separator
           hr(),
    )
  ), 
  
  
  # data description
  fluidPage(
    column(12, 
           
           # tilte
           h4("Data Description"),
           
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
             br(), 
             "Body ache, Diarrhea, Difficulty breathing, Disorientation, Fatigue, 
              Headache, Irritated eyes, Persistent cough, Sore throat, Temperature, 
              Loss of smell  and ‘no symptoms’ indicate having  COVID19 symptoms and their 
              values are just 0 or 1 (true or false). Left for exercise , Left for others, 
              Left for shopping, Left for work values are also only 0 and 1.These columns 
              are of Factor type.", 
              br(),
              br(), 
             "In this dataset columns age, guid, ip and zipCode are 
              of Character type, the rest are of numeric type.
              Overall there are 16,768 observations in the dataset."),
           
           
           # line separator
           hr(),
      
    )
  ),
  
  # out put
  mainPanel()
)

# Define server logic required to draw a histogram
server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)


