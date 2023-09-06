install.packages("dplyr") #biblioteca que ajuda na manipulação e datamining
library(dplyr)
install.packages("car")#biblioteca que ajuda em análise de regressão
library(car)

#setwd para baixar os conjuntos de dados
install.packages("readxl")
library(readxl)
banco_de_dados <- read_excel("mock_data_excel.xlsx")

banco_de_dados[banco_de_dados == -999] <- NA


banco_de_dados_2 <- read.delim("MOCK_DATA.csv", header = TRUE, sep=',', dec=".")

#lista <- c()

lista2 <- c(unique(banco_de_dados_2$instrução))

# for (i in lista2) {
#   lista <- append(lista, i)
# }
# 
# print(lista)

banco_de_dados_2$instrução <- factor(banco_de_dados_2$instrução, labels=c(0,1,2,3,4,5,6,7,8,9,10,11), levels = lista2)


lista_genero <- c(unique(banco_de_dados_2$genero))
banco_de_dados_2$genero_num <- factor(banco_de_dados_2$genero, labels=c(0,1), levels = lista_genero)


shapiro.test()