library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)
library(tm)
library(tidyr)

#reading datasets
infogears_covid_data <- read.csv("Covid_data.csv")
Covid_geo_data <- read.csv("Country_Region.csv")

Top_Regions <- c("California", "Texas","Florida","Pennsylvania","Illinois",
                 "Ohio","New Jersey","Arizona","Michigan","Washington","Georgia")

data_with_cases <- read.csv("owid-covid-data.csv",stringsAsFactors = F)
data_usa <- data_with_cases%>%
  filter(iso_code=="USA" & complete.cases(iso_code) & date>="2020-04-16" & date<="2020-07-13")
colnames(data_usa)[6:18]<-c("New cases","Total deaths","New deaths","Total cases(per million)", "New cases(per million)", "Total deaths(per million)","New deaths(per million)",      
                            "Total tests","New tests","Total tests(per thousand)","New tests(per thousand)","New tests smoothed","New tests smoothed(per thousand)")

covid_num <- infogears_covid_data[,sapply(infogears_covid_data, is.numeric)]

data_with_cases_num <- data_with_cases[,sapply(data_with_cases, is.numeric)]




# Define UI for application that draws a histogram
ui <- fluidPage(theme = "app.css",
  
  # title
  titlePanel("COVID19 Myths and Facts Analyzation"),

  tabsetPanel(
    # problem statement panel
     
    # about project panel
    tabPanel("About Project", 
             
             # logo image
             tags$img(src = "logo.png", width = 200, height = 150),
             
             # line break
             br(), br(), 
             
             # problem statement
             fluidRow(
               column(12, 
                      
                      div(
                      # title
                        h4("Problem statement"),
                        
                        # body
                        p("As the world continues to fight the spread of COVID19 and we gradually 
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
                        hr(), 
                      ) # end of div
                ), # end of column1 
            ), # end of fluid row "problem statement"
            
            fluidRow(
              column(12, 
                     
                     div(
                       # title
                       h4("Hypothesis"),
                       
                       # body
                       p(
                         h5("USA analysis"),
                         "-What is the frequency of face covering when leaving home by gender.",
                         br(),
                         "-What is the percentage of Mental health impact by region and gender",
                         br(),
                         "-How number of total cases, new cases, total deaths, new deaths, total cases(per million),
new cases(per million), total deaths(per million), new deaths(per million), 
new tests, total tests, total tests (per thousand), new tests(per thousand), 
new tests smoothed, new tests smoothed(per thousand) by the time period of Infogears dataset.",
                         br(),
                         "-What is the number of people with health issues and 
                        by amount of leaving home times.",
                         br(),
                         "-What is the number of people with mental health impact.",
                         br(),
                         "-What is the relationship between household people 
                        number and the amount of leaving home by gender.",
                         br(),
                         br(),
                         
                         h5("Global analysis"),
                         "-What is the relationship between total deaths and total cases by continents.",
                         br(),
                         "-What is the relationship between total deaths and median age within a given country.",
                         br(),
                         "-What is the relationship between total deaths and cardivascular death rate within a country.",
                       ),
                     ),
                     
                     
                     # line break
                     br(), 
                     # line break
                     hr(), 
                     # end of div
              ), # end of column1 
            ), # end of fluid row "problem statement"
            
            # data description
            fluidRow(
              column(12, 
                  div(
                    # title
                    h4("About InfoGears"), 
                    
                    # about infogears
                    p(a(href="https://infogears.org/", "Infogears dataset"), 
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
                    
                  ) # end of div
              ) # end of column 1
            ), # end of fluid row "data description"
            
            # changed features/description in the dataset
            fluidRow(
              column(12, 
                div(
                  # tilte
                  h4("InfoGears Dataset Description"),
                  
                  # body
                  p(
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
                ) # end of div
              )# end of column
            ), # end of fuild row "changes"
            
            # data description
            fluidRow(
              column(12, 
                     div(
                       # title
                       h4("Supportive Dataset for IP addresses"), 
                       p(
                         "As it is mentioned in the description of the Infogears dataset, it has a column 'Ip  -  ip address'.
                         IP addresses can help us to find the geolocation from  which the data is collected. To get such kind of statistics
                         a supportive dataset is used which source is ",
                         a(href="http://www.ip2location.com", "IP2Location LITE"),
                         "."
                       ),
                      
                       
                       p("To get a data geolocations for instances of InfoGears dataset, the IP addresses have first of all 
                         been mapped to their corresponding numeric values. Then with the help of two mapping functions the regions from the 
                         'IP2Location LITE' dataset have been mapped according to their IP ranges."),
                       
                       p("As a result 'Country_Region.csv' have been created which is available in the project's", 
                         a(href="https://github.com/Mahta-RezaYazdi/covid19_facts_myths", "GitGub repostory."),
                         "Below is the description of the dataset:",
                         br(), 
                         br(),
                         "Created at  -  created at date and time", 
                         br(), 
                         "Face covering  -  Always, Sometimes, Never",
                         br(), 
                         "Gender  -  female, male, notShared, notWantToShare, other", 
                         br(),
                         "Health issues  -  chronicIssues, noIssues, someIssues",
                         br(),
                         "ip_numeric  -  numeric value of ip address",
                         br(),
                         "Left home times  -  Didn't leave, Left Once, Left Twice/more",
                         br(),
                         "Mental health impact  -  No Impact, Significant Impact, Some Impact",
                         br(),
                         "region_name - the name of the region",
                         br(),
                         "city_name - the name of the city of ip address",),
                  
                       
                       # line separator
                       hr(), 
                       
                     ) # end of div
              ) # end of column 1
            ), # end of fluid row "data description"
            
            # data description
            fluidRow(
              column(12, 
                     div(
                       # title
                       h4(a(href="https://github.com/owid/covid-19-data/tree/master/public/data?fbclid=IwAR2lh01Dxl991Dh1RESDnyUPri3r5XslckOf4Xd5JLXLMtJrUd370iCnnlo",
                            "'Our World in Data' Dataset")), 
                       p(
                         "This data has been collected, aggregated, and documented by Diana Beltekian, Daniel Gavrilov, Charlie Giattino, Joe Hasell, 
                         Bobbie Macdonald, Edouard Mathieu, Esteban Ortiz-Ospina, Hannah Ritchie, Max Roser. The mission of Our World in Data is to make data 
                         and research on the world’s largest problems understandable and accessible."
                       ),
                       
                       p("Below is the explanation of variables in dataset "),
                       
                       p(
                         br(),
                         "iso_code – country codes list",	
                         br(),
                         "continent – world continent" ,
                         br(),
                         "location – location",
                         br(),
                         "date – day/month/year",
                         br(),
                         "total_cases – number of total cases",
                         br(),
                         "new-cases – number of new cases",
                         br(),
                         "total_deaths – number of total deaths",
                         br(),
                         "new_deaths – number of new deaths",
                         br(),
                         "total_cases_per_million – number of total cases per million people",
                         br(),
                         "new_cases_per_million - number of new cases per million people",
                         br(),
                         "total_deaths_per_million - number of total deaths per million people",
                         br(),
                         "new_deaths_per_million - number of new deaths per million people",
                         br(),
                         "new_tests – number of newly tested people", 
                         br(),
                         "total_tests - number of total tested people",
                         br(),
                         "total_tests_per_thousand – number of total tests per thousand people",
                         br(),
                         "new_tests_per_thousand - number of new tests per thousand people",
                         br(),
                         "new_tests_smoothed – number of new tests smoothed",
                         br(),
                         "new_tests_smoothed_per_thousand – number of new tests smoothed per thousand people", 
                         br(),
                         "tests_units – tests units",
                         br(),
                         "stringency_index - It is a metrics being used by the Oxford COVID-19 Government Response Tracker.",
                         br(),
                         "population – population of given region", 
                         br(),
                         "population_density – population density of given region", 
                         br(),
                         "median_age – median age at given region",
                         br(),
                         "aged_65_older – age > 65",
                         br(),
                         "aged_70_older – age > 70",
                         br(),
                         "gdp_per_capita - Gross Domestic Product per capita in given area",
                         br(),
                         "extreme_poverty – extreme poverty in given area",
                         br(),
                         "cardiovasc_death_rate – death rate of cardiovascular disease in given area",
                         br(),
                         "diabetes_prevalence - diabetes prevalence in given area",
                         br(),
                         "female_smokers – number of female smokers",
                         br(),
                         "male_smokers – number of male smokers",
                         br(),
                         "handwashing_facilities – handwashing facilities",
                         br(),
                         "hospital_beds_per_thousand – nuber of hospital beds per thousand people",
                         br(),
                         "life_expectancy – expected life time in given area", 
                         br(),
                         br(),
                         p("Overall, there are 32.568 observations, 34 variables and 29 numeric in dataset.")),
                    
                       # line separator
                       hr(), 
                       
                     ) # end of div
              ) # end of column 1
            )
    ), # end of tabPanel
    
    # Data visualization panel
    tabPanel("COVID19 USA Data Visualisation", 
             
             # Fact 1 description
             # Fact 1 description
             fluidRow(
               div(style = "margin: 10px",
                   column(12,
                          # Does physical health condition affect the level of vulnerability to COVID19
                          
                          # title
                          h4(style = "color: #483D8B;", "Does physical health condition affect the level of vulnerability to COVID19?"),
                          
                          # fact 1
                          p("According to",
                            a(href="https://www.health.gov.au/news/health-alerts/novel-coronavirus-2019-ncov-
                     health-alert/advice-for-people-at-risk-of-coronavirus-covid-19/coronavirus-covid-
                     19-advice-for-people-with-chronic-health-conditions",
                              "Australian Government, Department of Health"),
                            
                            ", Anyone could develop serious or severe illness from COVID-19, but those with
                     chronic health conditions or weakened immune systems are at greater risk."),
                          
                          # line break
                          br(),
                          
                          # guidance
                          p("You can check the truthness of this statement by choosing three different
                   physical health conditions and gender to chek the resulting barcharts."),
                          
                          # line break
                          br(),
                   ) # end of column
               ) # end of div
             ), # end of fluid row fact 1 description
             
             # Fact 1 input
             fluidRow(
               column(6,
                      # choose gender
                      radioButtons(inputId = "gender",
                                   label = h5("Choose a gender"),
                                   choices = list("Female" = "female",
                                                  "Male" = "male"),
                                   selected = "female"),
               ), # end of column
               column(6,
                      # choose physical health condition
                      radioButtons(inputId = "physical_health_condition",
                                   label = h5("Choose a physical health condition"),
                                   choices = list("No issues" = "noIssues",
                                                  "Some issues" = "someIssues",
                                                  "Chronic issues" = "chronicIssues"),
                                   selecte = "noIssues"),        
               ),
             ),
             
             mainPanel(plotOutput("barchart")),
             
             # line break
             br(),
             
             # result of the analysation
             fluidRow(
               div(style = "margin: 10px",
                   column(12,
                          p("As you can see, anyone at any age might catch COVID19, however people who
                have some or chronic health issues are at higher risk."),
                          
                          # line
                          hr(),
                   ) # end of column
               ) # end of div
             ), # end of fluid row result of the analysation
           
           #Region_Cities visualization
           fluidRow(
             div(
               column(12, 
                      # title
                      h4("Does people follow lockdown and face covering guidances in different Regions of USA?"), 
                      
                      # fact 1
                      p("According to", 
                        a(href="https://www.nist.gov/blogs/taking-measure/my-stay-home-lab-shows-how-face-coverings-can-slow-spread-disease", 
                          "My Stay-at-Home Lab Shows How Face Coverings Can Slow the Spread of Disease"), 
                        
                        "article, a breathable well-fitting face covering may help slow the spread of the virus, 
                        since COVID-19 spreads mainly from person to person through respiratory droplets produced when an 
                        infected person coughs, sneezes or talks."), 
                      
                      # line break
                      br(), 
                      
                      # guidance
                      p("The other most important factor is lockdown, which enables preventing the exposure of virus. It is interesting to see
                        how efficiently people follow this guidances in different regions of USA."), 
                      
                      # line break
                      br(), 
                      
                      # guidance
                      p("You can check the statement by choosing the region name and see how often people leave houses in different regions. 
                        Faceting in the graph is done according to face covering frequency."), 
                      
                      # line break
                      br(), 
               ) # end of column
             ) # end of div
           ), # end of fluid row fact description
           
           fluidRow(
             column(4, selectInput("regionName", "Region Name", choices = unique(Covid_geo_data$region_name),selected = "Massachusetts"))
           ),
           plotOutput("geo_lefthome"),
           
           fluidRow(
             div(
               column(12, 
                      # title
                      h4("Is the lockdown a barrier or is it a chance to ... "), 
                      p("According to", 
                        a(href="https://www.euro.who.int/en/health-topics/health-emergencies/coronavirus-covid-19/technical-guidance/mental-health-and-covid-19", 
                          "World Health Organization"), 
                        
                        ", there is a high chance of getting mental health problems when being sick with COVID19. 
                        In public mental health terms, the main psychological impact to date is elevated rates of stress or anxiety.",
                      
                      "Many of us, even those who have not been infected by the virus, 
                        will choose to quarantine in our homes for the upcoming weeks. According to ",
                        
                        a(href="https://adaa.org/", 
                          "Anxiety and Depression Association of America"), 
                        
                        ", capsized travel plans, indefinite isolation, panic over scarce re-sources 
                        and information overload could be a recipe for unchecked anxiety and feelings of isolation. 
                        There are a" ,
                        
                        a(href="https://adaa.org/learn-from-us/from-the-experts/blog-posts/consumer/covid-19-lockdown-guide-how-manage-anxiety-and", 
                          "few pointers"),
                        
                        " that could help us survive spiraling negative thoughts about this uncertain time."), 
                      
                      # line break
                      br(), 
                      
                      # guidance
                      p("It is up to us to decide whether THE LOCKDOWN is a BARRIER FOR OUR PLANS AND LIFE STYLE and, therefore, A CAUSE OF STRESS, 
                        or it is A GOOD CHANCE to do things at home for which we haven't found time before!"), 
                      
                      # line break
                      br(), 
                      
                      # guidance
                      p("Let's check how the lockdown affected people's mental health condition in different regions of USA. 
                        The pie chart shows how males/females deal with the lockdown process depending on how often they go out."), 
                      
                      # line break
                      br(), 
               ) # end of column
             ) # end of div
           ), # end of fluid row fact 1 description
           fluidRow(
             column(3, selectInput("topRegionName", "Region Name", choices = Top_Regions,selected = "California")),
             column(3, selectInput("pie_gender", "Gender", choices = c("male", "female"),selected = "Female")),
             column(4, selectInput("geo_leftHome", "Home Leaving Times", choices = unique(Covid_geo_data$leftHomeTimes),selected = "Didn't leave"))
           ),
           
           plotOutput("geo_pie"),
           
           
           #########################
           fluidRow(column(12, 
                           div(
                             # title
                             h3("What are the scales of cases, deaths, tests in the USA and how they change? "), 
                             p("We subsetted",a(href="https://github.com/owid/covid-19-data/tree/master/public/data", "the dataset"), 
                               " to have all the information about US (total cases, total deaths etc.), 
                                     you can choose the category you want to see the change of each category in the time period Infogears dataset
                                     is available. We can state that the cases and test number are increasing daily, but the deaths have tendency to incline "),
                             
                             # line separator
                             br(), 
                             
                             p("According to ",a(href="https://www.nytimes.com/2020/07/03/world/coronavirus-updates.html", "The New Yotk Times,"), 
                               " After a minor late-spring lull, the number of confirmed coronavirus cases in 
                                     the United States is again on the rise. 
                                     States like Arizona, Florida and Texas are seeing some of their highest numbers
                                     to date, and as the nation hurtles deeper into summer,
                                     the surge shows few signs of stopping. 
                                     Yet the virus appears to be killing fewer of the people it infects — a 
                                     seemingly counterintuitive trend that might not last, experts said."),
                             
                             # line separator
                             br(), 
                             
                           ) 
           ),
           fluidRow(
             column(6 ,selectInput(inputId="timing",
                                   label="Select parameter",
                                   choices= colnames(data_usa)[6:18],
                                   selected = "New cases")
             )
           ),
           
           plotOutput("scatterplot"),
           
           hr(),
           ),
           fluidRow(
             div(style = "margin: 10px",
                 column(12,
                        # Does physical health condition affect the level of vulnerability to COVID19
                        
                        # title
                        h4(style = "color: #483D8B;",
                           "Understand the potential risks of going out"),
                        
                        # fact 1
                        p("According to",
                          a(href="https://www.euro.who.int/en/health-topics/health-emergencies/coronavirus-covid-19/statements/statement-older-people-are-at-highest-risk-from-covid-19,-but-all-must-act-to-prevent-community-spread",
                            "World Health Organization"),
                          
                          ",the rate of leaving houses and getting sick with COVID19 is positively related.It is very important that people with symptoms that may be due to COVID-19 and their household members stay at home. Staying at home will help prevent the spread of the virus to family, friends, the wider community, and particularly those who are clinically extremely vulnerable. "),
                        
                        # line break
                        br(),
                 )
             )
           ),
           
           
           
           selectInput(inputId ="left",
                       label="Choose the number of times the peron left home",
                       choices = list("Did not leave" = "didNotLeave",
                                      "Once" = "oneTime",
                                      "Twice or more" = "twoTimesOrMore"),
                       selected = "didNotLeave"),
           
           plotOutput("barchart1"),
           
           
           # result of the analysation
           fluidRow(
             div(style = "margin: 10px",
                 column(12,
                        p("
                        According to the above bar charts, unfortunately, some people who either are  
                        positive COVID19 patients or have some COVID19 symports do leave their homes  
                        during the day, which represents there is risk of catching COVID19 outdoors.  
                        However, it can also be interpreted that the higher percent of people who are  
                        plosive COVID19 patients do not leave their homes, which has a huge effect on  
                        slowing down the pace of COVID19 spread in the community
                        If you decide to engage in public activities, continue to
                        protect yourself by",
                          a(href="https://www.cdc.gov/coronavirus/2019-ncov/prevent-getting-sick/prevention.html",
                            "practicing everyday preventive actions.")),
                        
                        # line
                        hr(),
                 ) # end of column
             ) # end of div
           ), # end of fluid row result of the analysation
             
    ), 
    tabPanel("COVID-19 Global Data Visualization",
      fluidRow(
        div(
          column(12, 
                 
                 h4("Does geographical location affect the rate of deaths from COVID19?"), 
                 
                 p("Since first being recorded late last year in China, the Covid-19 coronavirus has spread around the world, and been declared a pandemic by the World Health Organization. However, differences in testing mean that the number of cases may be understated for some countries. According to", 
                   a(href="https://www.theguardian.com/world/2020/jul/26/coronavirus-world-map-which-countries-have-the-most-covid-19-cases-and-deaths", 
                     "Support the Guardian"), 
                   
                   ", US has the most deaths, which drastically differs from the rates of other countries."), 
                 
                 
                 br(), 
                 
                 p("You can check the truthiness of the statement by choosing the region or the exact country and check the resulting scatterplot."), 
                 
                 
                 br(), 
                 p("The scatterplot shows the relation of the total deaths from COVID19 and total cases of COVID19 within each continent or country"), 
                 
                 
                 br(), 
          ) 
        ) 
      ),
      fluidRow(
      column(5, selectInput(inputId = "forth", label="Choose the continent",
                  choices = c('Asia', 'Europe', 'Africa', 'North America', 'South America', 'Oceania'),
                  selected = "Asia")),
      column(5, selectInput(inputId ="first", label="Choose the country",
                  choices = unique(data_with_cases$location),
                  selected = "Afghanistan"))),
      
      
      plotOutput("scatterplot2"),
      
      plotOutput("scatterplot3"),
      
      ###################################
      fluidRow(
        div(
          column(12, 
                 
                 h4("The relationship between COVID19 and cardiovascular desease"), 
                 
                 p("Cardiovascular disease (CVD) is a general term for conditions affecting the heart or blood vessels. According to", 
                   a(href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7138145/", 
                     "US National Library of Medicine-National Institutes of Health"), 
                   
                   ", there is a strongly positive relation of coronavirus and cardiovascular disease. They state, that people with cardiovascular disease are within the death zone, and people coronavirus can gain cardiovascular diseases."), 
                 
                 br(), 
                 
                 p("You can check the truthiness of the statement by choosing the continent and check the resulting scatterplot."), 
                 
                 br(), 
                 p("The scatterplot shows the relation of the total death rate from COVID19 and the death rate from cardiovascular deseases within each continent or country. The line in a scatterplot is the mean line."), 
                 
                 br(),
          ) 
        ) 
      ),
      
      
      
      selectInput(inputId ="select", label="Choose the continent",
                  choices = unique(data_with_cases$continent),
                  selected = "Asia"),
      
      
      
      plotOutput("scatterplot4"),
      
      ##################################
      fluidRow(
        div(
          column(12, 
                 
                 h4("Does death rate from COVID19 differs from age to age?"), 
                 
                 p("There is a straightforward question that most people would like answered. If someone is infected with COVID-19, how likely is that person to die? 
                             According to", 
                   a(href="https://ourworldindata.org/grapher/case-fatality-rate-of-covid-19-vs-median-age?country=COL~SYC", 
                     "University of Oxford"), 
                   
                   ", mean age of coronavirus death is 40 in the world. "), 
                 
                 br(), 
                 
                 p("You can check the truthiness of the statement by choosing the region or the exact country and check the resulting scatterplot."), 
                 
                 br(), 
                 p("The scatterplot shows the relation of the total death rate and the median age within each continent or country. The line in each scatterplot is the mean line."), 
                 
                 br(),
          ) 
        ) 
      ),
      fluidRow(
      column(4,selectInput(inputId ="fifth", label="Choose a continent",
                  choices = unique(data_with_cases$continent),
                  selected = "Asia")),
      
      column(4,selectInput(inputId ="sixth", label="Choose a country",
                  choices = unique(data_with_cases$location),
                  selected = "Armenia"))
      ),
      plotOutput("scatterplot5"),
      plotOutput("scatterplot6"),
    ) # end of tabPanel
    # end of data visualization panel
  ) # end of tabsetPanel
) # end of fluid page




# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$barchart2 <- renderPlot({
    
    
    covid_l <- infogears_covid_data[str_detect(infogears_covid_data$healthIssues, pattern=input$issue),]
    covid_l %>%
      group_by(mentalHealthImpact) %>%
      summarise(Count=n()) %>%
      ggplot(aes(x=mentalHealthImpact, y=Count, fill=mentalHealthImpact)) + geom_bar(stat="identity" )+
      labs(title="Number of people with mental health imapct", x="Mental health impact", y="Total number of impact", fill="Mental health")
    
  }, width = 850)
  
  #chosen health condition reactive data
  covid_updated <- reactive({
    infogears_covid_data %>%
      filter(leftHomeTimes == input$left,
             virusTest == c("positive", "negative"))
  })
  
  output$barchart1 <- renderPlot({
    
    covid_updated() %>%
      ggplot(aes(healthIssues, fill=virusTest)) +
      geom_bar(color = "white", size = 0.5, width = 0.6, alpha = 0.5) +
      facet_wrap(~factor(Person_Wellness)) +
      labs(title="Number of People Left Home Times and Their Health Condition",
           x="Health Condition",
           y="Count") +
      scale_fill_manual(values = c("green", "red"),
                        name = "Virus Test Result",
                        label = c("Negative", "Positive")) +
      scale_x_discrete(labels=c("Chronic Issues", "No Issues", "Some Issues"))
    
  }, width = 850)
  
  output$scatterplot1 <- renderPlot({
    
    
    covid_g <- infogears_covid_data[str_detect(infogears_covid_data$gender, pattern=input$gender1),]
    covid_g %>%
      group_by(leftHomeTimes, householdHeadcount) %>%
      summarise(Count=n()) %>%
      ggplot(aes(x=householdHeadcount, y=Count, fill=householdHeadcount)) + geom_point(stat="identity" )+ geom_smooth(method="lm", se=F) +
      labs(title="Relation between household members and amount of leaving home", x="Number of household members", y="Number of leaving home" , fill="Household members")
  }, width = 850)
  
  #chosen health condition reactive data
  chosen_gender_data <- reactive({
    infogears_covid_data %>%
      filter(gender == input$gender,
             healthIssues == input$physical_health_condition,
             Person_Wellness == "Some symptoms",
             virusTest == c("positive", "negative"))
  })
  
  # fact 1 output
  output$barchart <- renderPlot({
    ggplot(chosen_gender_data(), aes(virusTest, fill = virusTest)) +
      facet_wrap(~ factor(Age)) +
      scale_fill_manual(values = c("green", "red"),
                        name = "COVD19 test result",
                        label = c("Negative", "Positive")) +
      labs(title = "Testing Results Based on Physical Health Condition and Age",
           x = "Virus test result",
           y = "Count") +
      geom_bar(
        color = "white",
        size = 0.5,
        width = 0.9,
        alpha = 0.5)
  }, width = 850)
  
  
  output$geo_lefthome <- renderPlot({
    
    Covid_geo_data[complete.cases(Covid_geo_data$faceCovering),] %>%
      select(region_name, faceCovering, leftHomeTimes, gender) %>%
      filter((region_name %in% input$regionName)) %>%
      group_by(leftHomeTimes, faceCovering, gender) %>%
      summarise(count = n()) %>%
      ggplot(aes(x = leftHomeTimes, y = count, fill = as.factor(gender))) + 
      geom_bar(stat = 'identity') +
      facet_grid(.~faceCovering) +
      labs(title = "The frequency of face covering when leaving Home according to Gender", x = "Home leaving frequency",  y = "Home leaving count") +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 90)) +
      scale_fill_discrete(labels = c("Female", "Male", "Not shared", "Other"), name="Gender")
  }, width = 850)
  
  
  output$geo_pie <- renderPlot({
    
    
    total_count <- Covid_geo_data %>%
      select(gender,mentalHealthImpact, leftHomeTimes, region_name) %>%
      filter(region_name %in% input$topRegionName, gender %in% input$pie_gender,leftHomeTimes %in% input$geo_leftHome) %>%
      group_by(gender,region_name) %>%
      summarise(TotalCount = n()) 
    
    
    impact_range <- Covid_geo_data %>%
      select(gender, mentalHealthImpact, leftHomeTimes, region_name) %>%
      filter(region_name %in% input$topRegionName, gender %in% input$pie_gender,leftHomeTimes %in% input$geo_leftHome) %>%
      group_by(gender, mentalHealthImpact, region_name) %>%
      summarise(Count = n()) %>%
      arrange(desc(Count))
    
    impact_range$per <- round(impact_range$Count / total_count$TotalCount * 100)
    if(sum(impact_range$per) != 100){
      impact_range$per[3] <- impact_range$per[3] + 1
    }
    impact_range$label <- scales::percent(impact_range$per/100)
    
    impact_range %>%  ggplot()+
      geom_bar(aes(x="", y=per, fill=mentalHealthImpact), stat="identity", width = 1)+
      coord_polar("y", start=0)+
      theme_void()+
      geom_text(aes(x=1, y = cumsum(per) - per/2, label=label))+
      labs(title="The percentage of Mental Impact category") +
      scale_fill_discrete(name = "Mental Health Impact")
    
  }, width = 850)
  
  ############################################
  output$scatterplot <- renderPlot({
    data_usa%>%
      select(date,input$timing)%>%
      filter(complete.cases(date) & complete.cases(input$timing))%>%
      ggplot(aes(y = data_usa[,input$timing])) + 
      geom_point(aes(x=date),color='darkblue') +
      geom_smooth(aes(x=date),method="loess", se=F) +
      scale_x_discrete(breaks = function(x) x[seq(1, length(x), by = 4)])+
      labs(subtitle=paste0("Time period and ", input$timing, " in given date range"), 
           x="Time period", 
           y=paste0("Number range of ", input$timing), 
           title="Scatterplot")+
      theme_minimal()+
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5))
    
  }, width = 850)
  ############################################
  output$scatterplot2 <- renderPlot({
    
    
    covid_forth <- data_with_cases[str_detect(data_with_cases$continent, pattern=input$forth),]
    covid_forth %>% drop_na()
    
    
    ggplot(covid_forth, aes(x=total_deaths, y = total_cases)) + geom_point(color="blue")+ 
      scale_x_continuous(labels = scales::comma) + coord_cartesian(ylim=c(0,500), xlim=c(0, 500)) +coord_flip() +
      scale_y_continuous(labels = scales::comma)+ 
      labs(title="Relation of total deaths and total cases within a continent", x="Total deaths", y="Total cases")
  }, width = 850)
  output$scatterplot3 <- renderPlot({
    
    
    covid_first <- data_with_cases[str_detect(data_with_cases$location, pattern=input$first),]
    covid_first %>% drop_na()
    
    
    ggplot(covid_first, aes(x=total_deaths, y = total_cases)) + geom_point(color="red")+ 
      scale_x_continuous(labels = scales::comma) + coord_cartesian(ylim=c(0,500), xlim=c(0, 500)) +coord_flip() +
      scale_y_continuous(labels = scales::comma)+ 
      labs(title="Relation of total deaths and total cases within a country", x="Total deaths", y="Total cases")
  }, width = 850)
  
  output$scatterplot4 <- renderPlot({
    
    
    covid_first <- data_with_cases[str_detect(data_with_cases$continent, pattern=input$select),]
    covid_first %>% drop_na()
    
    
    ggplot(covid_first, aes(x=total_deaths, y = cardiovasc_death_rate, fill="total_deaths")) + geom_point()+ geom_smooth(method="lm", se=F)+
      scale_x_continuous(labels = scales::comma)  +
      scale_y_continuous(labels = scales::comma)+ 
      labs(title="Relation of total deaths and cardiovascular death rate within a country", x="Total deaths", y="Cardiovascular death rate", fill="")
    
  }, width = 850)
  
  
  output$scatterplot5 <- renderPlot({
    
    
    covid_first <- data_with_cases[!str_detect(data_with_cases$continent, pattern=input$fifth),]
    covid_first %>% drop_na()
    
    covid_first$date<-str_replace_all(covid_first$date, pattern="^[0-9]{2}", replacement = "")
    covid_first$date<-str_replace_all(covid_first$date, pattern="\\-", replacement = "")
    covid_first$date<-str_replace_all(covid_first$date, pattern="^[0-9]{2}", replacement = "")
    
    covid_first %>%
      group_by(input$fifth, median_age) %>%
      summarise(Count=sum(total_deaths)) %>%
      ggplot(aes(x=Count, y = median_age, fill="median_age")) + geom_point(stat="identity")+geom_smooth(method="lm", se=F)+
      scale_x_continuous(labels = scales::comma)  +
      scale_y_continuous(labels = scales::comma)+  coord_cartesian(xlim=c(0,100000), ylim=c(15, 50)) +
      labs(title="Relation of total deaths and median age within a continent", x="Total deaths", y="Cardiovascular death rate", fill="")
    
  }, width = 850)
  output$scatterplot6 <- renderPlot({
    
    
    covid_first1 <- data_with_cases[!str_detect(data_with_cases$location, pattern=input$sixth),]
    covid_first1 %>% drop_na()
    
    covid_first1$date<-str_replace_all(covid_first1$date, pattern="^[0-9]{2}", replacement = "")
    covid_first1$date<-str_replace_all(covid_first1$date, pattern="\\-", replacement = "")
    covid_first1$date<-str_replace_all(covid_first1$date, pattern="^[0-9]{2}", replacement = "")
    
    covid_first1 %>%
      group_by(input$sixth, median_age) %>%
      summarise(Count=sum(total_deaths)) %>%
      ggplot(aes(x=Count, y = median_age, fill="median_age")) + geom_point(stat="identity")+geom_smooth(method="lm", se=F)+
      scale_x_continuous(labels = scales::comma)  +
      scale_y_continuous(labels = scales::comma)+  coord_cartesian(xlim=c(0,100000), ylim=c(15, 50)) +
      labs(title="Relation of total deaths and median age within a country", x="Total deaths", y="Cardiovascular death rate", fill="")
    
  }, width = 850)
}

# Run the application 
shinyApp(ui = ui, server = server)


