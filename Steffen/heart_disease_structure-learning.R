library(devtools)
library(dagitty)

# first create and plot the network we ourselves set up
net <- dagitty(paste('dag {
  bb="0,0,1,1"
  oldpeak [pos="0.371,0.925"]',  # ST_depression
  'slope [pos="0.378,0.805"]',   # ST_slope
  'age [pos="0.822,0.078"]',
  'cp [pos="0.391,0.347"]',       # chest_pain
  'chol [pos="0.681,0.246"]',     # cholesterol
  'ca [pos="0.730,0.615"]',       # coloured_arteries
  'num [pos="0.625,0.929"]',      # diagnosis
  'exang [pos="0.185,0.568"]',    # exercise_induced_angina
  'fbs [pos="0.877,0.571"]',      # fasting_blood_sugar
  'thalach [pos="0.122,0.079"]',  # max_heart_rate
  'trestbps [pos="0.343,0.639"]', # rest_blood_press
  'restecg [pos="0.107,0.790"]',  # rest_ecg
  'sex [pos="0.563,0.145"]',
  'thal [pos="0.215,0.291"]',     # thalassemia
  'oldpeak -> num
  slope -> num
  age -> chol
  age -> fbs
  age -> thalach
  cp -> num
  cp -> exang
  chol -> cp
  chol -> ca
  chol -> num
  chol -> thalach
  chol -> trestbps
  ca -> num
  exang -> restecg
  fbs -> chol
  fbs -> num
  thalach -> restecg
  trestbps -> num
  trestbps -> restecg
  restecg -> oldpeak
  restecg -> slope
  sex -> chol
  sex -> thalach
  thal -> exang
  thal -> thalach
  thal -> trestbps
  }'))
plot(net)
hd <- read.csv("Data/heart_disease_dataset.csv")
head(hd)


## Structure learning
# Now, we perform some structure learning,
# starting with 'naive structure learning'

# install.packages("bnlearn") # Install the packages, if you haven't yet
library(bnlearn)
hd <- read.csv("Data/heart_disease_dataset.csv")
fit <- pc.stable(hd) # pc.stable results in an error. Will be fixed by converting every numerical varibale to a factor

hd$age <- factor(hd$age)
hd$sex <- factor(hd$sex)
hd$cp <- factor(hd$cp)
hd$trestbps <- factor(hd$trestbps)
hd$chol <- factor(hd$chol)
hd$fbs <- factor(hd$fbs)
hd$restecg <- factor(hd$restecg)
hd$thalach <- factor(hd$thalach)
hd$exang <- factor(hd$exang)
hd$slope <- factor(hd$slope)
hd$ca <- factor(hd$ca)
hd$thal <- factor(hd$thal)
hd$num <- factor(hd$num)
fit <- pc.stable(hd)
plot(fit)  # the network contains no edges, which is kind of expected
# let's inspect the fit object
fit


## Data preprocessing for structure learning
hd <- read.csv("Data/heart_disease_dataset.csv")
colnames(hd) <- c("age", "sex", "chest_pain", "rest_blood_press",
                  "cholesterol", "fasting_blood_sugar", "rest_ecg",
                  "max_heart_rate", "ex_ind_angina", "ST_depression",
                  "ST_slope", "col_arteries", "thalassemia", "diagnosis")

# fix the age factor
s <- rep("20-34", nrow(hd))  # there are no cases with <20 in the dataset
s[hd$age >= 35 & hd$age < 50] <- "35-49"
s[hd$age >= 50 & hd$age < 66] <- "50-65"
s[hd$age > 65] <- ">65"
hd$age <- as.factor(s)

# fix the resting_blood_pressure factor
s <- rep("<100", nrow(hd))
s[hd$rest_blood_press >= 100 & hd$rest_blood_press < 125] <- "100-124"
s[hd$rest_blood_press >= 125 & hd$rest_blood_press < 150] <- "125-149"
s[hd$rest_blood_press >= 150 & hd$rest_blood_press < 175] <- "150-174"
s[hd$rest_blood_press >= 175 & hd$rest_blood_press < 200] <- "175-199"
s[hd$rest_blood_press >= 200] <- ">=200"
hd$rest_blood_press <- as.factor(s)

# fix the colesterol factor
s <- rep("<200", nrow(hd))
s[hd$cholesterol >= 100 & hd$cholesterol < 200] <- "100-199"
s[hd$cholesterol >= 200 & hd$cholesterol < 300] <- "200-299"
s[hd$cholesterol >= 300 & hd$cholesterol < 400] <- "300-399"
s[hd$cholesterol >= 400 & hd$cholesterol < 500] <- "400-499"
s[hd$cholesterol >= 500] <- ">500"
hd$cholesterol <- as.factor(s)

# fix the max_heart_rate factor
s <- rep("<100", nrow(hd))
s[hd$max_heart_rate >= 100 & hd$max_heart_rate < 125] <- "100-124"
s[hd$max_heart_rate >= 125 & hd$max_heart_rate < 150] <- "125-149"
s[hd$max_heart_rate >= 150 & hd$max_heart_rate < 175] <- "150-174"
s[hd$max_heart_rate >= 175 & hd$max_heart_rate < 200] <- "175-199"
s[hd$max_heart_rate >= 200] <- ">=200"
hd$max_heart_rate <- as.factor(s)


s <- rep("<2", nrow(hd))
s[hd$ST_depression >= 2 & hd$ST_depression <= 4] <- "2-4"
s[hd$ST_depression > 4] <- ">=4"
hd$ST_depression <- as.factor(s)

hd$sex <- factor(hd$sex)
hd$chest_pain <- factor(hd$chest_pain)
hd$fasting_blood_sugar <- factor(hd$fasting_blood_sugar)
hd$rest_ecg <- factor(hd$rest_ecg)
hd$ex_ind_angina <- factor(hd$ex_ind_angina)
hd$ST_slope <- factor(hd$ST_slope)
hd$col_arteries <- factor(hd$col_arteries)
hd$thalassemia <- factor(hd$thalassemia)
hd$diagnosis <- factor(hd$diagnosis)

fit <- pc.stable(hd)
plot(fit)
fit

length(unique(hd$diagnosis))




