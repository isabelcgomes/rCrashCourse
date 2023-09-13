library(dplyr)
library(car)
install.packages("RVAideMemoire")
library(RVAideMemoire)
library(readxl)
library(psych)

dados <- read.csv("C:/Users/Isabel Giannecchini/Desktop/SSD/rCrashCourse/Terceira Aula/banco de dados 2.csv", sep=';', dec=',')
dados1 <- read.csv("C:/Users/Isabel Giannecchini/Desktop/SSD/rCrashCourse/Terceira Aula/banco de dados 3.csv", sep=';', dec=',')