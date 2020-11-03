library(devtools)
library(dagitty)
library( bayesianNetworks )
library(lavaan)
#setwd("~/Documents/Artificial Intelligence/Master/1. Year/1. Semester/Bayesian Networks/heart-disease")


g <- dagitty('dag {
bb="0,0,1,1"
ST_depression [pos="0.711,0.156"]
ST_slope [pos="0.713,0.501"]
age [pos="0.068,0.464"]
chest_pain [pos="0.324,0.253"]
cholesterol [pos="0.526,0.625"]
coloured_arteries [pos="0.709,0.717"]
diagnosis [pos="0.961,0.424"]
exercise_induced_angina [pos="0.320,0.611"]
fasting_blood_sugar [pos="0.534,0.843"]
max_heart_rate [pos="0.530,0.232"]
rest_blood_press [pos="0.526,0.410"]
rest_ecg [pos="0.526,0.064"]
sex [pos="0.068,0.230"]
thalassemia [pos="0.068,0.716"]
ST_depression -> diagnosis
ST_slope -> diagnosis
age -> chest_pain
age -> cholesterol
age -> exercise_induced_angina
age -> fasting_blood_sugar
age -> max_heart_rate
age -> rest_blood_press
age -> rest_ecg
chest_pain -> cholesterol
chest_pain -> diagnosis
chest_pain -> max_heart_rate
chest_pain -> rest_blood_press
chest_pain -> rest_ecg
cholesterol -> coloured_arteries
cholesterol -> diagnosis
coloured_arteries -> diagnosis
exercise_induced_angina -> cholesterol
exercise_induced_angina -> max_heart_rate
exercise_induced_angina -> rest_blood_press
exercise_induced_angina -> rest_ecg
fasting_blood_sugar -> diagnosis
max_heart_rate -> ST_depression
max_heart_rate -> ST_slope
max_heart_rate -> diagnosis
rest_blood_press -> ST_depression
rest_blood_press -> ST_slope
rest_blood_press -> coloured_arteries
rest_blood_press -> diagnosis
rest_ecg -> ST_depression
rest_ecg -> ST_slope
sex -> chest_pain
sex -> cholesterol
sex -> fasting_blood_sugar
sex -> max_heart_rate
sex -> rest_blood_press
sex -> rest_ecg
thalassemia -> chest_pain
thalassemia -> exercise_induced_angina
thalassemia -> max_heart_rate
thalassemia -> rest_blood_press
thalassemia -> rest_ecg
}
')

plot(g)

paths(g, "age", "diagnosis")

d <- read.csv("data/processed_cleveland.csv", header=F, sep=',')

impliedConditionalIndependencies( g )
