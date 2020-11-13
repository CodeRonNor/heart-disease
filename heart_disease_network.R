### Install Packages
# install.packages('remotes', dependencies = TRUE)
# install.packages('bnlearn', dependencies=TRUE)
# install.packages('pROC', dependencies=TRUE)
# install.packages('ggplot2', dependencies=TRUE)
# install.packages('caret', dependencies=TRUE)
# install.packages("dagitty", dependencies = TRUE)
# remotes::install_github("jtextor/bayesianNetworks")

### Libraries
library(dagitty)
library(bayesianNetworks)
library(bnlearn)
library(pROC)
library(ggplot2)
library(caret)

### Options
options(digits=2)

### Network Structures
old_net <- dagitty('dag {
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

pruned_net <- dagitty('dag {
bb="-5.198,-4.944,6.567,7.657"
ST_depression [pos="-3.579,-4.576"]
ST_slope [pos="-4.217,-1.331"]
age [pos="2.272,0.152"]
chest_pain [pos="-0.885,-0.152"]
cholesterol [pos="1.525,3.714"]
coloured_arteries [pos="1.210,-2.529"]
diagnosis [pos="-1.711,-3.396"]
exercise_induced_angina [pos="-4.263,1.062"]
fasting_blood_sugar [pos="3.897,-2.776"]
max_heart_rate [pos="-2.097,-1.628"]
rest_blood_press [pos="5.587,-0.105"]
rest_ecg [pos="4.512,2.476"]
sex [pos="-0.695,2.591"]
thalassemia [pos="-2.788,1.952"]
ST_depression -> diagnosis [beta=" 0.13 "]
ST_slope -> ST_depression [beta=" 0.54 "]
ST_slope -> diagnosis [beta=" 0.15 "]
age -> cholesterol [beta=" 0.13 "]
age -> coloured_arteries [beta=" 0.34 "]
age -> fasting_blood_sugar [beta=" 0.12 "]
age -> max_heart_rate [beta=" -0.34 "]
age -> rest_blood_press [beta=" 0.27 "]
age -> rest_ecg [beta=" 0.14 "]
chest_pain -> coloured_arteries [beta=" 0.23 "]
chest_pain -> diagnosis [beta=" 0.29 "]
chest_pain -> max_heart_rate [beta=" -0.19 "]
coloured_arteries -> diagnosis [beta=" 0.36 "]
exercise_induced_angina -> chest_pain [beta=" 0.33 "]
exercise_induced_angina -> max_heart_rate [beta=" -0.23 "]
fasting_blood_sugar -> coloured_arteries [beta=" 0.12 "]
max_heart_rate -> ST_depression [beta=" -0.17 "]
max_heart_rate -> ST_slope [beta=" -0.28 "]
max_heart_rate -> diagnosis [beta=" -0.15 "]
sex -> cholesterol [beta=" -0.15 "]
thalassemia -> ST_slope [beta=" 0.23 "]
thalassemia -> chest_pain [beta=" 0.16 "]
thalassemia -> exercise_induced_angina [beta=" 0.33 "]
}
')

### Save Network Plots
png('plots/old_net.png', width = 750, height = 750)
plot(old_net)
dev.off()
png('plots/net.png', width = 750, height = 750)
plot(net)
dev.off()
png('plots/pruned_net.png', width = 750, height = 750)
plot(pruned_net, show.coefficients=TRUE)
dev.off()

### Data
data <- read.csv("data/processed_cleveland.csv", header = FALSE)
colnames(data) <- c("age", "sex", "chest_pain", "rest_blood_press", 
                    "cholesterol", "fasting_blood_sugar", "rest_ecg", 
                    "max_heart_rate", "exercise_induced_angina", 
                    "ST_depression", "ST_slope", "coloured_arteries",
                    "thalassemia", "diagnosis")
head(data)

### Data Inspection

# Continuous variables
range(data$age)
range(data$rest_blood_press)
range(data$cholesterol)
range(data$max_heart_rate)
range(data$ST_depression)

# Categorical variables
factor(data$sex)[1]
factor(data$chest_pain)[1]
factor(data$fasting_blood_sugar)[1]
factor(data$rest_ecg)[1]
factor(data$exercise_induced_angina)[1]
factor(data$ST_slope)[1]
factor(data$coloured_arteries)[1] 
factor(data$thalassemia)[1] 
factor(data$diagnosis)[1] 

### Preprocessing

# NANs
nrow(data[which(data$coloured_arteries == '?'),])
nrow(data[which(data$thalassemia == '?'),])

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

### Dealing with Different Types of Data

# Convert continuous data to categorical data
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

# Chi-squared Test 
localTests(net, data, type="cis.chisq", max.conditioning.variables = 4)

### Edge Coefficients
edges = ""
for( x in names(net) ){
  px <- dagitty::parents(net, x)
  for( y in px ){
    tst <- ci.test( x, y,setdiff(px,y), data=data )
    
    # Print edges
    print(paste(y,'->',x, tst$statistic, tst$p.value ) )
    
    # Determine edges to make the pruned net
    # if(tst$p.value < 0.05){
    # edges <- paste(edges,y,'->',x, '[beta = "',round(tst$statistic, digits = 2),'"]\n')
    # }
  }
}
cat(edges)

### Cross Validation
k = 10
folds = createFolds(data$sex, k = k)
all_preds <- NULL
all_labels <- NULL
for (test_index in folds) {
  # Split data into test and train
  train_index <- setdiff(1:nrow(data), test_index)
  test_data = data[test_index,]
  train_data = data[train_index,]
  
  # Convert model to bnlearn
  net_bn <- model2network(toString(net,"bnlearn")) 
  
  # Fit on data
  fit <- bn.fit(net_bn, train_data); fit
  
  # Predict 
  preds <- predict(fit, node= 'diagnosis', data = test_data, method = "bayes-lw", n = 10000) 
  
  # Save all data
  all_preds <- c(all_preds, preds)
  all_labels <- c(all_labels, test_data$diagnosis)
}

### Analysis

# Check range
range(all_preds)

# Round values
all_preds = round(all_preds)

# ROC & AUC
png("plots/net_roc.png")
plot(roc(all_preds, all_labels))
dev.off()
auc(all_preds, all_labels)

# Confusion Matrix
cm <- confusionMatrix(data = factor(all_preds), reference = factor(all_labels)); cm
png("plots/net_confusion_matrix.png", width = 650)
ggplot(data = as.data.frame(cm$table), aes(sort(Reference,decreasing = T), Prediction, fill= Freq)) +
  geom_tile() + geom_text(aes(label=Freq), size = 7) +
  scale_fill_gradient(low="white", high="#B4261A") +
  labs(x = "Ground Truth",y = "Prediction", fill="Frequency", title = "Bayesian Network Predictions", size=8) +
  scale_x_discrete(labels=c("Heart Disease", "No Heart Disease")) +
  scale_y_discrete(labels=c("No Heart Disease", "Heart Disease")) +
  theme_bw(base_size = 15)
dev.off()

