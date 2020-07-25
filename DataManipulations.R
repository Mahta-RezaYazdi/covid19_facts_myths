# import libraries
library(dplyr)
library(ggplot2)
library(readxl)
library(writexl)

# import datasets
infogears_covid_data <- read.csv("covid-07-13-2020.csv")


# data cleaning
# replace all "didNotLefts" to "didNotLeave" in lefHomeTimes
infogears_covid_data <- infogears_covid_data %>%
  mutate(leftHomeTimes = ifelse(leftHomeTimes == "didNotLeft", "didNotLeave", leftHomeTimes))

# add Person_Wellness depending on having symptoms
infogears_covid_data <- infogears_covid_data %>%
  mutate(Person_Wellness = ifelse(noSymptoms == 1, "No symptoms", "Some symptoms"))

# add Age 
# "13_17" "18_25" "26_35" "36_45" "46_55" "56_65" "66_75" "75_and_more"
infogears_covid_data$Age <-
  str_extract_all(infogears_covid_data$X.age, pattern = "[0-9]{2}.*")
infogears_covid_data$Age <- as.character(infogears_covid_data$Age)
infogears_covid_data$Age <- as.factor(infogears_covid_data$Age)
levels(infogears_covid_data$Age)

# categorical variable
# no sypmtoms, some symptoms
infogears_covid_data$Person_Wellness <-
  as.factor(infogears_covid_data$Person_Wellness)

# negative, notTested, positive
# antibodyTest

# doNotKnow, haveDirectContact
# exposureLevel

# female, male, notShared, notWantToShare, other
infogears_covid_data$gender <-
  as.factor(infogears_covid_data$gender)

# replace all "notWantToShare" to "notShared"
# infogears_covid_data <- infogears_covid_data %>%
#   mutate(gender = ifelse(gender == "notWantToShare", "notShared", gender))

# chronicIssues, noIssues, someIssues
# healthIssues

# didNotLeave, oneTime, twoTimesOrMore
# leftHomeTimes

# noImpact, significantImpact, someImpact
# mentalHealthImpact

# awaitingResults, negative, notTested, positive
# virusTest

# 0, 1
infogears_covid_data$bodyAche <-
  as.factor(infogears_covid_data$bodyAche)

# 0, 1
infogears_covid_data$diarrhea <-
  as.factor(infogears_covid_data$diarrhea)

# 0, 1
infogears_covid_data$difficultyBreathing <-
  as.factor(infogears_covid_data$difficultyBreathing)

# 0, 1
infogears_covid_data$disorientation <-
  as.factor(infogears_covid_data$disorientation)

# 0, 1
infogears_covid_data$fatigue <-
  as.factor(infogears_covid_data$fatigue)

# 0, 1
infogears_covid_data$headAche <-
  as.factor(infogears_covid_data$headAche)

# 0, 1
infogears_covid_data$irritatedEyes <-
  as.factor(infogears_covid_data$irritatedEyes)

# 0, 1
infogears_covid_data$lossOfSmell <-
  as.factor(infogears_covid_data$lossOfSmell)

# 0, 1
infogears_covid_data$persistentCough <-
  as.factor(infogears_covid_data$persistentCough)

# 0, 1
infogears_covid_data$soreThroat <-
  as.factor(infogears_covid_data$soreThroat)

# 0, 1
infogears_covid_data$temperature <-
  as.factor(infogears_covid_data$temperature)

# 0, 1
infogears_covid_data$leftForExercise <-
  as.factor(infogears_covid_data$leftForExercise)

# 0, 1
infogears_covid_data$leftForShopping <-
  as.factor(infogears_covid_data$leftForShopping)

# 0, 1
infogears_covid_data$leftForWork <-
  as.factor(infogears_covid_data$leftForWork)

 infogears_covid_data$faceCovering <-
   as.factor(infogears_covid_data$faceCovering)


# reorder levels
levels(infogears_covid_data$healthIssues) <- c("noIssues", "someIssues", "chronicIssues")
levels(infogears_covid_data$mentalHealthImpact) <- c("noImpact", "someImpace", "significantImpact")
levels(infogears_covid_data$virusTest) <- c("notTested", "awaitingResults", "negative", "positive")
# levels(infogears_covid_data$gender) <- c("female", "male", "other", "notShared")


#Saving a new dataset with changes above
write.csv(infogears_covid_data, "Covid_data")

