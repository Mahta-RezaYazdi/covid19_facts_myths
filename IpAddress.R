library(iptools)

Covid_data <- read.csv("Covid_data.csv")
IP_data <- read.csv("IP2LOCATION-LITE-DB3.CSV")
colnames(IP_data) <- c("ip_from", "ip_to", "country_code", "country_name","region_name","city_name")

Covid_data$ip_class <- ip_classify(Covid_data$ip)
Covid_data$ip_numeric <- ip_to_numeric(Covid_data$ip)

#Getting IP ranges for only US
IP_data <- IP_data %>%
  select(ip_from, ip_to, country_code, country_name, region_name, city_name) %>%
  filter(country_code %in% "US")
Covid_data_sub <- Covid_data[complete.cases(Covid_data$ip_class),]


Covid_data_sub <- Covid_data_sub %>%
  group_by(ip_numeric) %>%
  arrange(ip_numeric)


#Function to find the IP address location with the two datasets we have


get_Region_and_City <- function(ip){
  
  location <-  IP_data %>%
    select(ip_from, ip_to, region_name, city_name) %>%
    filter(ip_from <= ip & ip_to >= ip)
  location <- location[,c(3,4)]
  
  if(nrow(location != 0))(
    return(location)
  )
  return(data.frame( region_name = "NotComplete",
                     city_name = "NotComplete"))
}

add_Region_and_City <- function(data){
  n <- length(data)
  lction <- data.frame( region_name = character(),
                        city_name = character())
  for (i in 1:n) {
    lction <- rbind(lction, get_Region_and_City(data[i]))
  }
  
  return(lction)
}
  
loc1 <- add_Region_and_City(Covid_data_sub$ip_numeric[1:1000])
loc2 <- add_Region_and_City(Covid_data_sub$ip_numeric[1001 : 5000])
x <- Covid_data_sub$ip_numeric[5000]
IP_data <- IP_data[IP_data$ip_from >= x,]
loc5 <- add_Region_and_City(Covid_data_sub$ip_numeric[10001:18000])
loc6 <- add_Region_and_City(Covid_data_sub$ip_numeric[25000:28000])


GeoLocations <- rbind(loc1,loc2, loc5, loc6)
newData <- Covid_data_sub[c(1:1000,1001 : 5000,10001:18000,25000:28000), ]


newData <- newData %>%
  select(createdAt, faceCovering, gender,healthIssues, mentalHealthImpact,leftHomeTimes,ip_numeric)

newData <- c(newData, GeoLocations)


write.csv(newData, "Country_Region.csv")

newData <- read.csv("Country_Region.csv")

newData <- newData %>%
  mutate(faceCovering = ifelse(faceCovering == "Always", faceCovering,
                          ifelse(faceCovering == "Sometimes", faceCovering,
                                 ifelse(faceCovering == "Never", faceCovering, NA))),
         leftHomeTimes = ifelse(leftHomeTimes == "didNotLeave", "Didn't leave",
                                ifelse(leftHomeTimes == "oneTime", "Left Once",
                                       ifelse(leftHomeTimes == "twoTimesOrMore", "Left Twice/More", leftHomeTimes ))),
         mentalHealthImpact = ifelse(mentalHealthImpact == "significantImpact", "Significant Impact",
                                     ifelse(mentalHealthImpact == "someImpact", "Some Impact",
                                            ifelse(mentalHealthImpact == "noImpact", "No Impact", mentalHealthImpact ))))



newData <- newData[complete.cases(newData$region_name),]


write.csv(newData, "Country_Region.csv")
  
  
  
  
  
  
  
  
  
  
  