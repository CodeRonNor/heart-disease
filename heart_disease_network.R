library(devtools)
library(dagitty)

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

data <- read.csv("Data/heart_disease_dataset.csv")
head(data)
