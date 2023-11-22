if(!require(factoextra)) install.packages("factoextra")
if(!require(readxl)) install.packages("readxl")
if(!require(dplyr)) install.packages("dplyr")
if(!require(car)) install.packages("car")
if(!require(psych)) install.packages("psych")
if(!require(RVAideMemoire)) install.packages("RVAideMemoire")
if(!require(pacman)) install.packages("pacman")
if(!require(pacman)) install.packages("cluster")

library(factoextra)
library(cluster)
library(readxl)
library(dplyr)
library(car)
library(psych)
library(RVAideMemoire)
library(pacman)
pacman :: p_load(dplyr, ggplot2, car, rstatix, lmtest, ggpubr, ggpmisc, psych, MASS, DescTools, QuantPsyc)

data('USArrests')
dados <- USArrests

summary(dados)

p.cov <- var(scale(dados))
p.mean <- apply(dados, 2, mean)
p.mah <- mahalanobis(dados, p.mean, p.cov)
View(p.mah)

dados.p <- scale(dados)

#Modelo Hierárquico

d.eucl <- dist(dados.p, method = 'euclidean')
round(as.matrix(d.eucl)[1:5,1:5],1) 
hc.m <- hclust(d.eucl, method = 'average')

groups <- 4

fviz_dend(hc.m, cex = 0.5, k = groups, color_labels_by_k = TRUE, rect = TRUE)


#Modelo não hierárquico (kmeans)

k_means<-kmeans(dados.p, centers = groups, nstart = 1)

plot(x=dados.p[,4], y=dados.p[,3], col=k_means$cluster)
points(k_means$centers, pch=3, cex=1)

clusplot(dados.p, k_means$cluster, color = T, labels = 2, main = 'Grupos') 