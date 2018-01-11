# Project 5:
# UNITY ID: abhardw2
# Name: Aditya Bhardwaj

#=============================================================================================================================#
# Loading the required libraries
# https://www.analyticsvidhya.com/blog/2017/09/creating-visualizing-neural-network-in-r/
# https://www.r-bloggers.com/using-neural-networks-for-credit-scoring-a-simple-example/
# https://datascienceplus.com/fitting-neural-network-in-r/
#=============================================================================================================================#
require(neuralnet)
library(boot)
library(plyr)
library(MASS)

bxplt <- function(metrics) {
  dframe <- data.frame(X1 = metrics)
  boxplot(dframe)
}

removeOutliers.fun <- function(dataset) {
  apply(dataset,2,function(x) sum(is.na(x)))
  FileData <- dataset
  maxs <- apply(FileData, 2, max)
  mins <- apply(FileData, 2, min)
  result <- data.matrix(as.data.frame(scale(FileData, center = mins, scale = maxs - mins)))
  FileData <- data.frame(FileData)
  FileData <- result
  return(FileData)
}

#=============================================================================================================================#
# Loading the data
#=============================================================================================================================#
setwd('/Users/ADITYA/data/NCState/iot/project/ann')
dataset <- read.csv("BHARDWAJ ADITYA.csv", header = TRUE)

datasetNew <- removeOutliers.fun(dataset)
#=============================================================================================================================#

dataset1 <- datasetNew[1:500,]
dataset2 <- datasetNew[501:1000,]
dataset3 <- datasetNew[1001:1500,]
dataset4 <- datasetNew[1501:2000,]
dataset5 <- datasetNew[2001:2500,]
dataset6 <- datasetNew[2501:3000,]
dataset7 <- datasetNew[3001:3500,]
dataset8 <- datasetNew[3501:4000,]
dataset9 <- datasetNew[4001:4500,]
dataset10 <- datasetNew[4501:5000,]
#=============================================================================================================================#

mse <- list()
rmse <- list()
sse <- list()
r2 <- list()
yHat <- list()

set.seed(300)


#=============================================================================================================================#
# PART 1: Code for calculating required parameters.
#=============================================================================================================================#
calcVals <- function(testingData, predictedData, number) {
  mse.NNet <- mean((testingData - predictedData)^2)
  rmse.NNet <- sqrt(mse.NNet)
  sse.NNet <- sum((testingData - predictedData)^2)
  R2 <- 1 - (sum((testingData - predictedData )^2)/sum((testingData - mean(testingData))^2))
  y_yHat <- sum(testingData - predictedData)
  myret <- c(paste("MSE:",mse.NNet, sep = " "), paste("SSE:", sse.NNet, sep = " "), paste("RMSE:", rmse.NNet, sep = " "), paste("R^2:", R2, sep = " "), paste("Error:", y_yHat, sep = " "))
  return(myret)
}

#=============================================================================================================================#



#=============================================================================================================================#
# Function to evaluate Neural network for all the iterations
#=============================================================================================================================#
neural.fun <- function(training, testing, layer, number) {
  #NN <- neuralnet(V6 ~ V1 + V2 + V3 + V4 + V5 , trainData, hidden = 1 , linear.output = T )
  #NN <- neuralnet(Y ~ X1 + X2 + X3 + X4 + X5, training, hidden = layer, lifesign = "minimal", linear.output = FALSE, threshold = 0.2)
  NN <- neuralnet(Y ~ X1 + X2 + X3 + X4 + X5, data  = training, hidden = layer,stepmax=1e6)
  plot(NN, rep = "best")
  #plot(NN)
  results <- compute(NN, testing[,1:5])
  prob <- results$net.result * ( max(dataset$Y) - min(dataset$Y) ) + min(dataset$Y)
  testData_new <- (testing$Y) * ( max(dataset$Y) - min(dataset$Y) ) + min(dataset$Y)
  calcVals(testData_new, prob, number)
}
#=============================================================================================================================#

#=============================================================================================================================#
# Function to run for all the iterations of K-folds method
#=============================================================================================================================#
checking.fun <- function(layers) {
  mylist <- list()
  for (i in 1:10){
    if (i == 1) {
      trainData <- rbind(dataset2, dataset3, dataset4, dataset5, dataset6, dataset7, dataset8, dataset9, dataset10)
      testData <- data.frame(dataset1)
      retval <- neural.fun(trainData, testData, layers, i)
      print(retval)
    }
    if (i == 2) {
      trainData <- rbind(dataset1, dataset3, dataset4, dataset5, dataset6, dataset7, dataset8, dataset9, dataset10)
      testData <- data.frame(dataset2)
      retval <- neural.fun(trainData, testData, layers, i)
      print(retval)
    }
    if (i == 3) {
      trainData <- rbind(dataset1, dataset2, dataset4, dataset5, dataset6, dataset7, dataset8, dataset9, dataset10)
      testData <- data.frame(dataset3)
      retval <- neural.fun(trainData, testData, layers, i)
      print(retval)
    }
    if (i == 4) {
      trainData <- rbind(dataset1, dataset2, dataset3, dataset5, dataset6, dataset7, dataset8, dataset9, dataset10)
      testData <- data.frame(dataset4)
      retval <- neural.fun(trainData, testData, layers, i)
      print(retval)
    }
    if (i == 5) {
      trainData <- rbind(dataset1, dataset2, dataset3, dataset4, dataset6, dataset7, dataset8, dataset9, dataset10)
      testData <- data.frame(dataset5)
      retval <- neural.fun(trainData, testData, layers, i)
      print(retval)
    }
    if (i == 6) {
      trainData <- rbind(dataset1, dataset2, dataset3, dataset4, dataset5, dataset7, dataset8, dataset9, dataset10)
      testData <- data.frame(dataset6)
      retval <- neural.fun(trainData, testData, layers, i)
      print(retval)
    }
    if (i == 7) {
      trainData <- rbind(dataset1, dataset2, dataset3, dataset4, dataset5, dataset6, dataset8, dataset9, dataset10)
      testData <- data.frame(dataset7)
      retval <- neural.fun(trainData, testData, layers, i)
      print(retval)
    }
    if (i == 8) {
      trainData <- rbind(dataset1, dataset2, dataset3, dataset4, dataset5, dataset6, dataset7, dataset9, dataset10)
      testData <- data.frame(dataset8)
      retval <- neural.fun(trainData, testData, layers, i)
      print(retval)
    }
    if (i == 9) {
      trainData <- rbind(dataset1, dataset2, dataset3, dataset4, dataset5, dataset6, dataset7, dataset8, dataset10)
      testData <- data.frame(dataset9)
      retval <- neural.fun(trainData, testData, layers, i)
      print(retval)
    }
    if (i == 10) {
      trainData <- rbind(dataset1, dataset2, dataset3, dataset4, dataset5, dataset6, dataset7, dataset8, dataset9)
      testData <- data.frame(dataset10)
      retval <- neural.fun(trainData, testData, layers, i)
      print(retval)
    }
    
  }
}

#=============================================================================================================================#
# PART 1: ANN
#=============================================================================================================================#
# Running for the First part
checking.fun(c(2, 1))
#=============================================================================================================================#

#=============================================================================================================================#
# PART 2: ANN
#=============================================================================================================================#
# Running Model on Various Hidden Layers and neurons
checking.fun(c(3, 1))

checking.fun(c(2, 2))

checking.fun(c(2, 1, 2))

checking.fun(c(3, 3, 1))

checking.fun(c(3, 2, 1))

checking.fun((c(4, 2)))
#=============================================================================================================================#

#=============================================================================================================================#
# EXTRA CREDIT: MultiVariate Regression
#=============================================================================================================================#
multivariate.fun <- function(dataset) {
  multivariate.mod <- lm(dataset$Y ~ dataset$X1+dataset$X4+dataset$X5, data = dataset)
  #print(multivariate.mod)
  res <- resid(multivariate.mod)
  fit <- fitted(multivariate.mod)
  print(summary(multivariate.mod))
  error <- dataset$Y - fit
  MSE <- mean(error^2)
  RMSE <- sqrt(MSE)
  SSE <- sum(error^2)
  print(paste("RMSE:", RMSE, sep = " "))
  print(paste("MSE:", MSE, sep = " "))
  print(paste("SSE:", SSE, sep = " "))
  #qqnorm(res)
  #qqline(res, col = 'red')
  #hist(res, main="Histogram of Residual Analysis")
  #plot(multivariate.mod)
}

multivariate.fun(dataset)
#=============================================================================================================================#
