####################################
# Data Professor                   #
# http://youtube.com/dataprofessor #
# http://github.com/dataprofessor  #
####################################

# Importing libraries
library(RCurl) # for downloading the iris CSV file
library(randomForest)
library(caret)

# Importing the Iris data set
iris <- read.csv(text = getURL("https://simplonline-v3-prod.s3.eu-west-3.amazonaws.com/media/file/csv/a5707984-9111-4d36-9da9-4ab5d35162cd.csv") )

# Performs stratified random split of the data set
target<- iris[,c("squareMeters","numberOfRooms","cityCode","isNewBuilt","price")]
print(target)
#TrainIndex <- createDataPartition(target$price, list = FALSE)

Train <- target # Training Set
#Test <- target[-TrainIndex,] # Test Set

write.csv(Train, "train.csv")
#write.csv(Test, "test.csv")

Train <- read.csv("train.csv", header = TRUE)
Train <- Train[,-1]

# Building Random forest model

model <- randomForest(price ~ ., data = Train, ntree = 500, mtry = 5, importance = TRUE)

# Save model to RDS file
saveRDS(model, "model.rds")
