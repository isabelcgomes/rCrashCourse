library(dplyr)
library(car)
library(readxl)
library(psych)

dados <- read.csv("banco de dados 2.csv", sep = ';', dec = ',')

leveneTest(dados$Nota_Hist ~ dados$Posicao_Sala, center = mean) #teste de homogeneidade com centro em relação à média
#por padrão o LeveneTest utiliza como medida de tendência central a mediana
#o que é homogeneidade?
#um modelo é bom quando tem alto nível de homogeneidade (homocedástico - variância constante)
#na variância constante é observado que os dados se aproximam da reta
#p valor maior ou menor que 0.05
#se maior, a amostra não é homogênea, se menor a amostra é homogênea


