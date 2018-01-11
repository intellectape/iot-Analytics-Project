# Project 4:
# UNITY ID: abhardw2
# Name: Aditya Bhardwaj

#=============================================================================================================================#
# Loading the required libraries
#=============================================================================================================================#
require(dbscan)
require(factoextra)
require(rgl)
#=============================================================================================================================#
# Loading the data
#=============================================================================================================================#
setwd('/Users/ADITYA/data/NCState/iot/project/clustering')
dataset = read.csv("BHARDWAJ ADITYA.csv", header = FALSE, sep = ",")
hcDataset <- dataset
kmeansDataset <- dataset
dbscanDataset <- dataset
#=============================================================================================================================#

#=============================================================================================================================#
# Task 1 - Hierarchical clustering
#=============================================================================================================================#
# Task 1.1
#=============================================================================================================================#
distanceList <- dist(hcDataset)
#=============================================================================================================================#
# Dendrogram
#=============================================================================================================================#
hCluster <- hclust(distanceList)
plot(hCluster$height, xlab = "Data point", ylab = "Heights", main = "Hierarchical Clustering Distance plot")
plot(hCluster, xlab="Data points", main = "Hierarchical Clustering Dendogram")
#=============================================================================================================================#

#=============================================================================================================================#
# Task 1.2
#=============================================================================================================================#
rect.hclust(hCluster, k = 2, border = 2:4) 
hCluster.cut <- cutree(hCluster, k = 2)
#=============================================================================================================================#

#=============================================================================================================================#
# Task 1.3
#=============================================================================================================================#
plot3d(hcDataset, col = hCluster.cut)
legend3d("topright", legend=paste("Cluster ",c(1, 2, 3)), col=c(1,2, 3), pch=20)
#=============================================================================================================================#

#=============================================================================================================================#

#=============================================================================================================================#
# Task 2 - K-Means clustering
#=============================================================================================================================#
# Task 2.1
#=============================================================================================================================#
set.seed(123)
k.max <- 15
wss <- sapply(2:k.max, function(k){kmeans(kmeansDataset, k, nstart=50,iter.max = 15 )$tot.withinss})

k <- 2
for(i in wss){
  print(paste(k, i, sep = " : "))
  k <- k + 1
}
#=============================================================================================================================#

#=============================================================================================================================#
# Task 2.2
#=============================================================================================================================#
plot(2:k.max, wss, type="b", pch = 20, frame = FALSE, xlab="Number of clusters K", ylab="Total within-clusters sum of squares")

optimalK <- 3 #After observing the Elbow curve.
#=============================================================================================================================#

#=============================================================================================================================#
# Task 2.3
#=============================================================================================================================#
kmeansCluster <- kmeans(kmeansDataset, optimalK)
kmeansDataset <- data.frame(kmeansDataset, kmeansCluster$cluster)
plot3d(kmeansDataset, col = kmeansCluster$cluster)
legend3d("topright", legend=paste("Cluster ",c(1,2,3)), col=c(1,2,3), pch=20)
#=============================================================================================================================#

#=============================================================================================================================#
# Task 3 - DB Scan
#=============================================================================================================================#

#=============================================================================================================================#
# Task 3.1
#=============================================================================================================================#

# Function copied from StackOverflow
cluster_color <- function(cluster) {
  for(i in 1:length(cluster)){
    cluster[i] <- cluster[i] + 1
  }
  return(cluster) 
}

#Elbow method
kNNdistplot(dbscanDataset, k =  3)
abline(h = 9, lty = 2)
e <- 9
minpts <- 3

#DBScan cluster
dbscanCluster <- dbscan(dbscanDataset, eps = e, minPts = minpts)
dbscanCluster$cluster <- cluster_color(dbscanCluster$cluster)
n_clust <- sort(unique(dbscanCluster$cluster))
plot3d(dbscanDataset, col=dbscanCluster$cluster, size=10)
legend3d("topright", legend=paste("Cluster ",n_clust-1), col=n_clust, pch=20)
#=============================================================================================================================#

#=============================================================================================================================#
# Task 3.2
#=============================================================================================================================#
kNNdistplot(dbscanDataset, k =  4)
abline(h = 11, lty = 2)
e <- 11
minpts <- 4

#DBScan cluster
dbscanCluster <- dbscan(dbscanDataset, eps = e, minPts = minpts)
dbscanCluster$cluster <- cluster_color(dbscanCluster$cluster)
n_clust <- sort(unique(dbscanCluster$cluster))
plot3d(dbscanDataset, col=dbscanCluster$cluster, size=10)
legend3d("topright", legend=paste("Cluster ",n_clust-1), col=n_clust, pch=20)
#=============================================================================================================================#

#=============================================================================================================================#
# MIN points = 5
#=============================================================================================================================#
kNNdistplot(dbscanDataset, k =  5)
abline(h = 10, lty = 2)
e <- 10
minpts <- 5

#DBScan cluster
dbscanCluster <- dbscan(dbscanDataset, eps = e, minPts = minpts)
dbscanCluster$cluster <- cluster_color(dbscanCluster$cluster)
n_clust <- sort(unique(dbscanCluster$cluster))
plot3d(dbscanDataset, col=dbscanCluster$cluster, size=10)
legend3d("topright", legend=paste("Cluster ",n_clust-1), col=n_clust, pch=20)
#=============================================================================================================================#


#=============================================================================================================================#
# MIN points = 6
#=============================================================================================================================#
kNNdistplot(dbscanDataset, k =  6)
abline(h = 12, lty = 2)
e <- 12
minpts <- 6

#DBScan cluster
dbscanCluster <- dbscan(dbscanDataset, eps = e, minPts = minpts)
dbscanCluster$cluster <- cluster_color(dbscanCluster$cluster)
n_clust <- sort(unique(dbscanCluster$cluster))
plot3d(dbscanDataset, col=dbscanCluster$cluster, size=10)
legend3d("topright", legend=paste("Cluster ",n_clust-1), col=n_clust, pch=20)
#=============================================================================================================================#

#=============================================================================================================================#
# MIN points = 7
#=============================================================================================================================#
kNNdistplot(dbscanDataset, k =  7)
abline(h = 13, lty = 2)
e <- 13
minpts <- 7

#DBScan cluster
dbscanCluster <- dbscan(dbscanDataset, eps = e, minPts = minpts)
dbscanCluster$cluster <- cluster_color(dbscanCluster$cluster)
n_clust <- sort(unique(dbscanCluster$cluster))
plot3d(dbscanDataset, col=dbscanCluster$cluster, size=10)
legend3d("topright", legend=paste("Cluster ",n_clust-1), col=n_clust, pch=20)
#=============================================================================================================================#

#=============================================================================================================================#
# MIN points = 8
#=============================================================================================================================#
kNNdistplot(dbscanDataset, k =  8)
abline(h = 15, lty = 2)
e <- 15
minpts <- 8

#DBScan cluster
dbscanCluster <- dbscan(dbscanDataset, eps = e, minPts = minpts)
dbscanCluster$cluster <- cluster_color(dbscanCluster$cluster)
n_clust <- sort(unique(dbscanCluster$cluster))
plot3d(dbscanDataset, col=dbscanCluster$cluster, size=10)
legend3d("topright", legend=paste("Cluster ",n_clust-1), col=n_clust, pch=20)
#=============================================================================================================================#

#=============================================================================================================================#
# MIN points = 9
#=============================================================================================================================#
kNNdistplot(dbscanDataset, k =  9)
abline(h = 17, lty = 2)
e <- 17
minpts <- 9

#DBScan cluster
dbscanCluster <- dbscan(dbscanDataset, eps = e, minPts = minpts)
dbscanCluster$cluster <- cluster_color(dbscanCluster$cluster)
n_clust <- sort(unique(dbscanCluster$cluster))
plot3d(dbscanDataset, col=dbscanCluster$cluster, size=10)
legend3d("topright", legend=paste("Cluster ",n_clust-1), col=n_clust, pch=20)
#=============================================================================================================================#

#=============================================================================================================================#
# MIN points = 10
#=============================================================================================================================#
kNNdistplot(dbscanDataset, k =  10)
abline(h = 17, lty = 2)
e <- 17
minpts <- 10

#DBScan cluster
dbscanCluster <- dbscan(dbscanDataset, eps = e, minPts = minpts)
dbscanCluster$cluster <- cluster_color(dbscanCluster$cluster)
n_clust <- sort(unique(dbscanCluster$cluster))
plot3d(dbscanDataset, col=dbscanCluster$cluster, size=10)
legend3d("topright", legend=paste("Cluster ",n_clust-1), col=n_clust, pch=20)
#=============================================================================================================================#