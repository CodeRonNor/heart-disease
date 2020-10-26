### Libraries
library(dagitty)
library(bayesianNetworks)

### Network Structure
net <- dagitty('dag {
  bb="0,0,1,1"
  ST_depression [pos="0.371,0.925"]
  ST_slope [pos="0.378,0.805"]
  age [pos="0.822,0.078"]
  chest_pain [pos="0.391,0.347"]
  cholesterol [pos="0.681,0.246"]
  coloured_arteries [pos="0.730,0.615"]
  diagnosis [pos="0.625,0.929"]
  exercise_induced_angina [pos="0.185,0.568"]
  fasting_blood_sugar [pos="0.877,0.571"]
  max_heart_rate [pos="0.122,0.079"]
  rest_blood_press [pos="0.343,0.639"]
  rest_ecg [pos="0.107,0.790"]
  sex [pos="0.563,0.145"]
  thalassemia [pos="0.215,0.291"]
  ST_depression -> diagnosis
  ST_slope -> diagnosis
  age -> cholesterol
  age -> fasting_blood_sugar
  age -> max_heart_rate
  chest_pain -> diagnosis
  chest_pain -> exercise_induced_angina
  cholesterol -> chest_pain
  cholesterol -> coloured_arteries
  cholesterol -> diagnosis
  cholesterol -> max_heart_rate
  cholesterol -> rest_blood_press
  coloured_arteries -> diagnosis
  exercise_induced_angina -> rest_ecg
  fasting_blood_sugar -> cholesterol
  fasting_blood_sugar -> diagnosis
  max_heart_rate -> rest_ecg
  rest_blood_press -> diagnosis
  rest_blood_press -> rest_ecg
  rest_ecg -> ST_depression
  rest_ecg -> ST_slope
  sex -> cholesterol
  sex -> max_heart_rate
  thalassemia -> exercise_induced_angina
  thalassemia -> max_heart_rate
  thalassemia -> rest_blood_press
  }')

plot(net)

### Data
data <- read.csv("data/processed_cleveland.csv")
colnames(data) <- c("age", "sex", "chest_pain", "rest_blood_press", 
                    "cholesterol", "fasting_blood_sugar", "rest_ecg", 
                    "max_heart_rate", "exercise_induced_angina", 
                    "ST_depression", "ST_slope", "coloured_arteries",
                    "thalassemia", "diagnosis")
head(data)

### Data Analysis

# Continuous Variables
range(data$age)
range(data$rest_blood_press)
range(data$cholesterol)
range(data$max_heart_rate)
range(data$ST_depression)

# Categorical Variables
factor(data$sex)[1]
factor(data$chest_pain)[1]
factor(data$fasting_blood_sugar)[1]
factor(data$rest_ecg)[1]
factor(data$exercise_induced_angina)[1]
factor(data$ST_slope)[1]
factor(data$coloured_arteries)[1] # Levels: ? 0.0 1.0 2.0 3.0
factor(data$thalassemia)[1] # Levels: ? 3.0 6.0 7.0
factor(data$diagnosis)[1] 

# NANs
nrow(data[which(data$coloured_arteries == '?'),]) # 4
nrow(data[which(data$thalassemia == '?'),]) # 2

# We can either remove these rows:
nrow(data) # 302
data <- data[-which(data$coloured_arteries == '?'),]
nrow(data) # 298
data <- data[-which(data$thalassemia == '?'),]
nrow(data) # 296

# Or set these to certain values
# data$coloured_arteries[which(data$coloured_arteries == '?')] <- '0.0'
# data$thalassemia[which(data$thalassemia == '?')] <- '3.0'

# Convert from character to numeric
data$thalassemia <- as.numeric(data$thalassemia)
data$coloured_arteries <- as.numeric(data$coloured_arteries)

### Test Network Structure 
impliedConditionalIndependencies(net)

### Chi-squared Test (only for categorical variables)
chisq.test(data$sex, data$age)

