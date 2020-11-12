### Install Packages
# install.packages('e1071', dependencies=TRUE)
# TODO

### Libraries
library(dagitty)
library(bayesianNetworks)
library(bnlearn)
library(lavaan)
library(pROC)

### Options
options(digits=2)

### Network Structure
net <- dagitty('dag {
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
ST_slope -> ST_depression
age -> chest_pain
age -> cholesterol
age -> exercise_induced_angina
age -> fasting_blood_sugar
age -> max_heart_rate
age -> rest_blood_press
age -> rest_ecg
age -> coloured_arteries
chest_pain -> cholesterol
chest_pain -> diagnosis
chest_pain -> max_heart_rate
chest_pain -> rest_blood_press
chest_pain -> rest_ecg
chest_pain -> coloured_arteries
cholesterol -> coloured_arteries
coloured_arteries -> diagnosis
exercise_induced_angina -> cholesterol
exercise_induced_angina -> max_heart_rate
exercise_induced_angina -> rest_blood_press
exercise_induced_angina -> rest_ecg
exercise_induced_angina -> chest_pain
exercise_induced_angina -> ST_slope
fasting_blood_sugar -> diagnosis
fasting_blood_sugar -> ST_depression
fasting_blood_sugar -> coloured_arteries
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
sex -> exercise_induced_angina
thalassemia -> chest_pain
thalassemia -> exercise_induced_angina
thalassemia -> max_heart_rate
thalassemia -> rest_blood_press
thalassemia -> rest_ecg
thalassemia -> ST_slope
}
')

plot(net)

### Data
data <- read.csv("data/processed_cleveland.csv", header = FALSE)
colnames(data) <- c("age", "sex", "chest_pain", "rest_blood_press", 
                    "cholesterol", "fasting_blood_sugar", "rest_ecg", 
                    "max_heart_rate", "exercise_induced_angina", 
                    "ST_depression", "ST_slope", "coloured_arteries",
                    "thalassemia", "diagnosis")
head(data)

### Data Inspection

# Plots
plot(data$age)

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

### Preprocessing

# NANs
nrow(data[which(data$coloured_arteries == '?'),]) # 4
nrow(data[which(data$thalassemia == '?'),]) # 2

# Set these to values that occur most in the dataset 
counts_thal <- table(data$thalassemia)
barplot(counts_thal) # The most occuring value is 3.0

counts_col <- table(data$coloured_arteries)
barplot(counts_col) # The most occuring value is 0.0

data$coloured_arteries[which(data$coloured_arteries == '?')] <- '0.0'
data$thalassemia[which(data$thalassemia == '?')] <- '3.0'

# Convert to numeric
data$thalassemia <- as.numeric(data$thalassemia)
data$coloured_arteries <- as.numeric(data$coloured_arteries)
data$diagnosis <- as.numeric(data$diagnosis)

### Dealing with different types of data

# Convert continuous data to ordered categorical data
data$age <- as.numeric(cut(data$age, 5))
data$rest_blood_press <- as.numeric(cut(data$rest_blood_press, c(90, 120, 140, 200), labels = c(1,2,3)))
data$cholesterol <- as.numeric(cut(data$cholesterol, c(100, 200, 300, 600), labels = c(1,2,3)))
data$max_heart_rate <- as.numeric(cut(data$max_heart_rate, c(50, 110, 140, 175, 210), labels = c(1,2,3,4)))
data$ST_depression <- as.numeric(cut(data$ST_depression, c(-0.1, 0.0, 2, 6.5), labels = c(0,1,2)))
head(data)

# Bin diagnosis
data$diagnosis[which(data$diagnosis > 0)] <- 1 

### Test Network Structure 
impliedConditionalIndependencies(net)

# Chi-squared Test (only for categorical variables)
localTests(net, data, type="cis.chisq")

### Edge Coefficients
for( x in names(net) ){
  # print(x)
  px <- dagitty::parents(net, x)
  # print(px)
  for( y in px ){
    tst <- ci.test( x, y,setdiff(px,y), data=data )
    print(paste(y,'->',x, tst$effect, tst$p.value ) )
  }
}

### Split train and test Data
train_index <- sample(1:nrow(data), 0.8 * nrow(data))
test_index <- setdiff(1:nrow(data), train_index)

train_data = data[train_index,]
test_data = data[test_index,]

### Fit model

# Convert model to bnlearn
net_bn <- model2network(toString(net,"bnlearn")) 

# Fit on data
fit <- bn.fit(net_bn, train_data); fit

# Predict 
preds <- predict(fit, node= 'diagnosis', data = test_data, method = "bayes-lw", n = 10000); 

### Analysis

# Check range
range(preds)

# Round values
preds = round(preds)

# ROC & AUC
png("plots/roc.png")
plot(roc(preds, test_data$diagnosis))
dev.off()
auc(preds, test_data$diagnosis)

# Confusion Matrix
cm <- confusionMatrix(data = factor(preds), reference = factor(test_data$diagnosis)); cm
png("plots/confusion_matrix.png")
ggplot(data = as.data.frame(cm$table), aes(Reference, Prediction, fill= Freq)) +
  geom_tile() + geom_text(aes(label=Freq)) +
  scale_fill_gradient(low="white", high="#B4261A") +
  labs(x = "Ground Truth",y = "Prediction", fill="Frequency", title = "Bayesian Network Predictions") +
  scale_x_discrete(labels=c("No Heart Disease", "Heart Disease")) +
  scale_y_discrete(labels=c("No Heart Disease", "Heart Disease")) +
  theme_bw()
dev.off() 
