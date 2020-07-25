# import libraries
library(dplyr)
library(ggplot2)
library(readxl)

# import datasets
infogears_covid_data <- read_excel("covid-06-27-2020.xlsx")


# data cleaning
# replace all "didNotLefts" to "didNotLeave" in lefHomeTimes
infogears_covid_data <- infogears_covid_data %>%
  mutate(leftHomeTimes = ifelse(leftHomeTimes == "didNotLeft", "didNotLeave", leftHomeTimes))

# replace all "notWantToShare" to "notShared"
infogears_covid_data <- infogears_covid_data %>%
  mutate(gender = ifelse(gender == "notWantToShare", "notShared", gender))

# add Person_Wellness depending on having symptoms
infogears_covid_data <- infogears_covid_data %>%
  mutate(Person_Wellness = ifelse(noSymptoms == 1, "No symptoms", "Some symptoms"))


# categorical variable
# no sypmtoms, some symptoms
infogears_covid_data$Person_Wellness <-
  as.factor(infogears_covid_data$Person_Wellness)

# negative, notTested, positive
infogears_covid_data$antibodyTest <-
  as.factor(infogears_covid_data$antibodyTest)

# doNotKnow, haveDirectContact
infogears_covid_data$exposureLevel <-
  as.factor(infogears_covid_data$exposureLevel)

# female, male, notShared, notWantToShare, other
infogears_covid_data$gender <-
  as.factor(infogears_covid_data$gender)

# chronicIssues, noIssues, someIssues
infogears_covid_data$healthIssues <-
  as.factor(infogears_covid_data$healthIssues)

# didNotLeave, oneTime, twoTimesOrMore
infogears_covid_data$leftHomeTimes <-
  as.factor(infogears_covid_data$leftHomeTimes)

# noImpact, significantImpact, someImpact
infogears_covid_data$mentalHealthImpact <-
  as.factor(infogears_covid_data$mentalHealthImpact)

# awaitingResults, negative, notTested, positive
infogears_covid_data$virusTest <-
  as.factor(infogears_covid_data$virusTest)

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

# infogears_covid_data$faceCovering <-
#   as.factor(infogears_covid_data$faceCovering)


# reorder levels
levels(infogears_covid_data$healthIssues) <- c("noIssues", "someIssues", "chronicIssues")
levels(infogears_covid_data$mentalHealthImpact) <- c("noImpact", "someImpace", "significantImpact")
levels(infogears_covid_data$virusTest) <- c("notTested", "awaitingResults", "negative", "positive")
levels(infogears_covid_data$gender) <- c("female", "male", "other", "notShared")

