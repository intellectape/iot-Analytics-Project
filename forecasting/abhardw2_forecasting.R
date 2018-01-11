# Project 3:
# UNITY ID: abhardw2
# Name: Aditya Bhardwaj
require(forecast)
require(hydroGOF)
require(smooth)
require(Mcomp)
require(TTR)

#=============================================================================================================================#
# Loading the data
#=============================================================================================================================#
setwd("/Users/ADITYA/data/NCState/iot/project/forecasting/")

dataset <- read.csv('BHARDWAJ ADITYA_1.csv', header = TRUE)
dataset <- ts(dataset)
#=============================================================================================================================#

#=============================================================================================================================#
# Dividing the data into training and testing
#=============================================================================================================================#
trainSize <- floor(nrow(dataset) * 0.75)
testSize <- nrow(dataset) - trainSize
trainData <- ts(dataset[1:trainSize], start = 1, end = trainSize)
testData <- ts(dataset[(trainSize + 1):length(dataset)], start = trainSize + 1, end = length(dataset))
#=============================================================================================================================#

#plot.ts(trainData,col="lightblue", xlim=c(1,2000), ylab="Dataset")
#lines(testData,col="orange")
#legend("bottomright",legend=c("Training Set","Testing Set"),lty=1:1, cex=0.7, box.lty=0, horiz=TRUE,col=c("lightblue","orange"))

#=============================================================================================================================#
# Simple Moving Average Model
#=============================================================================================================================#

#=============================================================================================================================#
# 1.1 Apply the simple moving average model, to the training data set, for a given m.
# In this case I am taking m = 3
#=============================================================================================================================#
predictedData <- sma(trainData, 3)  
predictedData <- fitted(predictedData)

#=============================================================================================================================#
# 1.2 Calculate the error, i.e., the difference between the predicted and original value in the 
#     training data set, and compute the the root mean squared error (RMSE).
#=============================================================================================================================#
calculatedRmse <- rmse(trainData, predictedData)
#=============================================================================================================================#

#=============================================================================================================================#
# Plotting the graph for a given value of m; m = 3
#=============================================================================================================================#
plot.ts(trainData, col = 'blue', ylab = "Values", main = paste("Training Data vs Fitted Data for Simple Moving Average Model at M =", 3, sep = " "))
lines(predictedData, col='red')
legend("topright",legend=c("Training Data", "Fitted Values"),lty=1:1, cex=0.8, box.lty=0, horiz=TRUE,col=c("blue","red"))
#=============================================================================================================================#

#=============================================================================================================================#
# 1.3 Repeat above two steps by varying m and calculate the RMSE.
#=============================================================================================================================#
n <- 100
mat.ma <- matrix(ncol=2, nrow=n)

# Running for simultaneous values
for (m in 1:100){
  predictedData <- sma(trainData, m)  
  predictedData <- fitted(predictedData)
  calculatedRmse <- rmse(trainData, predictedData)
  mat.ma[m,] <- c(m, calculatedRmse)
}
#=============================================================================================================================#

#=============================================================================================================================#
# Plotting RMSE values for Moving Average
#=============================================================================================================================#
plot(mat.ma, type = 'o', col = "lightblue", main= "RMSE values for Simple Moving Average", xlab = 'm', ylab = "RMSE")
#=============================================================================================================================#
# Plotting Time Series for the best RMSE found for the 
#=============================================================================================================================#
sma.predictedData <- sma(trainData, 2)
sma.predictedData <- fitted(sma.predictedData)

plot.ts(trainData, col = 'blue', ylab = "Values", main = paste("Training Data vs Fitted Data for Simple Moving Average Model at M =", 2, sep = " "))
lines(sma.predictedData, col='red')
legend("topright",legend=c("Training Data", "Fitted Values"),lty=1:1, cex=0.8, box.lty=0, horiz=TRUE,col=c("blue","red"))
#=============================================================================================================================#

#=============================================================================================================================#

#=============================================================================================================================#
# Exponential Moving Average Model
#=============================================================================================================================#
ema.fun <- function(trainData, alpha) {
  fittedVector <- c()
  fittedVector <- c(fittedVector, trainData[1])
  
  for( i in 2:length(trainData)){
    expSmooth <- alpha * trainData[i-1] + (1-alpha) * fittedVector[i-1]
    fittedVector <- c(fittedVector, expSmooth)
  }
  returnTS <- ts(fittedVector)
  return(returnTS)
}
#=============================================================================================================================#

#=============================================================================================================================#
#
#=============================================================================================================================#
predictedData <- ema.fun(trainData, 0.45)  
rmse.ema.predictedData <- rmse(trainData, predictedData)
print(paste(paste("RMSE value for Exponential Smoothing Model at alpha=", 0.45, sep = " "), rmse.ema.predictedData, sep = " : " ))
plot.ts(trainData, col = 'blue', ylab = "Values", main = paste("Training Data vs Fitted Data for Exponential Smoothing Model at Alpha =", 0.45, sep = " "))
lines(predictedData, col='red')
legend("topright",legend=c("Training Data", "Fitted Values"),lty=1:1, cex=0.8, box.lty=0, horiz=TRUE,col=c("blue","red"))
#=============================================================================================================================#

#=============================================================================================================================#
#
#=============================================================================================================================#
n <- 100
mat.ema <- matrix(ncol=2, nrow=n)

for (m in 1:100) {
  nm <- m/100
  predictedData <- ema.fun(trainData, nm)  
  calculatedRmse <- rmse(trainData, predictedData)
  mat.ema[m,] <- c(m, calculatedRmse)
}

#=============================================================================================================================#
#
#=============================================================================================================================#
plot(mat.ema, type = 'o', col = "lightblue", main= "RMSE values for Exponential Smoothing Model", xlab = 'm', ylab = "RMSE")
#=============================================================================================================================#

#=============================================================================================================================#
#
#=============================================================================================================================#
ema.predictedData <- ema.fun(trainData, 0.62)

plot.ts(trainData, col = 'blue', ylab = "Values", main = paste("Training Data vs Fitted Data for Exponential Smoothing Model at Alpha =", 0.62, sep = " "))
lines(ema.predictedData, col='red')
legend("topright",legend=c("Training Data", "Fitted Values"),lty=1:1, cex=0.7, box.lty=0, horiz=TRUE,col=c("blue","red"))
#=============================================================================================================================#



#=============================================================================================================================#
# AR(p) Model
#=============================================================================================================================#

#=============================================================================================================================#
# 3.2 Select p by plotting the partial autocorelation function.
#=============================================================================================================================#
pacf(trainData)
p <- 2
#=============================================================================================================================#

#=============================================================================================================================#
# 3.1 Apply the autoregressive algorithm AR(p) to the training data set for a given value p.
#=============================================================================================================================#
ar.mod <- auto.arima(trainData, d = 0, max.q = 0, max.p = 5)
fit.ar <- fitted(ar.mod)

rmse.ar <- rmse(trainData, fit.ar)

print(paste(paste("RMSE value for AR(p) model at p =", 5, sep = " "), rmse.ar, sep = " : " ))

plot.ts(trainData, col = 'blue', ylab = "Values", main = paste("Training Data vs Fitted Data for AR(p) Model at P =", 5, sep = " "))
lines(fit.ar, col='red')
legend("topright",legend=c("Training Data", "Fitted Values"),lty=1:1, cex=0.8, box.lty=0, horiz=TRUE,col=c("blue","red"))
#=============================================================================================================================#

#=============================================================================================================================#
# 3.3 Estimate the parameters of the AR(p) model. Provide RMSE value and a plot the predicted values against the original values.
#=============================================================================================================================#
ar.mod <- auto.arima(trainData, d = 0, max.q = 0, max.p = p)
fit.ar <- fitted(ar.mod)
rmse.ar <- rmse(trainData, fit.ar)

print(paste(paste("RMSE value for AR(p) model at p =", p, sep = " "), rmse.ar, sep = " : " ))

plot.ts(trainData, col = 'blue', ylab = "Values", main = paste("Training Data vs Fitted Data for AR(p) Model at P =", 2, sep = " "))
lines(fit.ar, col='red')
legend("topright",legend=c("Training Data", "Fitted Values"),lty=1:1, cex=0.8, box.lty=0, horiz=TRUE,col=c("blue","red"))
#=============================================================================================================================#

#=============================================================================================================================#
# Part 4: Run all three models on the test data, and chose the best one.
#=============================================================================================================================#
comparisonMat <- matrix(ncol=2, nrow=3)

#=============================================================================================================================#
# Simple Moving Average Model
#=============================================================================================================================#
sma.predictedTestData <- sma(testData, 2)
sma.predictedTestData <- fitted(sma.predictedTestData)
fit.sma.predictedTestData <- ts(sma.predictedTestData, start = trainSize + 1,end = length(dataset))
comparisonMat[1,] <- c("Simple Moving Average",rmse(testData, fit.sma.predictedTestData))
plot.ts(testData, col = 'blue', ylab = "Values", main = paste("Testing Data vs Fitted Data for Simple Moving Average Model at M =", 2, sep = " "))
lines(fit.sma.predictedTestData, col='red')
legend("topright",legend=c("Testing Data", "Fitted Values"), lty=1:1, cex=0.7, box.lty=0, horiz=TRUE,col=c("blue","red"))
#=============================================================================================================================#

#=============================================================================================================================#
# Exponential Smoothing Model
#=============================================================================================================================#
ema.predictedTestData <- ema.fun(testData, 0.62)
fit.ema.predictedTestData <- ts(ema.predictedTestData, start = trainSize + 1,end = length(dataset))
comparisonMat[2,] <- c("Exponential Smoothing",rmse(testData, fit.ema.predictedTestData))
plot.ts(testData, col = 'blue', ylab = "Values", main = paste("Testing Data vs Fitted Data for Exponential Smoothing Model at Alpha =", 0.62, sep = " "))
lines(fit.ema.predictedTestData, col='red')
legend("topright",legend=c("Testing Data", "Fitted Values"), lty=1:1, cex=0.7, box.lty=0, horiz=TRUE, col=c("blue","red"))
#=============================================================================================================================#

#=============================================================================================================================#
# AR(p) Model
#=============================================================================================================================#
ar.mod <- auto.arima(testData, d = 0, max.q = 0, max.p = p)
fit.ar.predictedTestData = fitted(ar.mod, start = trainSize + 1,end = length(dataset))
comparisonMat[3,] <- c("AR(p) Model",rmse(testData, fit.ar.predictedTestData))

print(paste(paste("RMSE value for AR(p) model at p =", p, sep = " "), comparisonMat[3,2], sep = " : " ))

plot.ts(testData, col = 'blue', ylab = "Values", main = paste("Training Data vs Fitted Data for AR(p) Model at P =", 2, sep = " "))
lines(fit.ar.predictedTestData, col='red')
legend("topright",legend=c("Training Data", "Fitted Values"), lty=1:1, cex=0.7, box.lty=0, horiz=TRUE,col=c("blue","red"))

#=============================================================================================================================#

#=============================================================================================================================#
# Plotting the graph to show the RMSE values for all models.
#=============================================================================================================================#
plot(y = comparisonMat[,2], x = 1:3, xlab = "Models", ylab = "RMSE", xaxt = 'n', main = "RMSE Comparison for three models", type = 'o')
axis(1, at = seq(1, 3, by = 1),labels = comparisonMat[,1], las = 1)
#=============================================================================================================================#


#=============================================================================================================================#
# END CODE
#=============================================================================================================================#
