if(!require(dplyr)) install("dplyr")
library(dplyr)
library(car)
library(readxl)

dados <- read_excel("C:/Users/Isabel Giannecchini/Desktop/SSD/Segunda Aula/dados.xlsx")

#testes de normalidade
shapiro.test(dados$Altura) #existem testes shapiro diferentes, o que muda entre eles é o tamanho da amostra. O R é inteligente o suficiente para saber que teste usar
shapiro.test(dados$Salario)

graus_de_instrucao <- unique(dados$Grau_de_Instruçao)
len_graus_de_instrucao <- seq.int(0, length(graus_de_instrucao)-1, 1)

dados$Grau_de_Instruçao_num <- factor(dados$Grau_de_Instruçao, labels = c(len_graus_de_instrucao), levels = graus_de_instrucao)

class(dados$Grau_de_Instruçao_num) = 'Numeric'
shapiro.test(dados$Grau_de_Instruçao_num)


#Teste T para uma amostra
t.test(dados$Altura, mu = 167)
# por padrão é bicaudal, para analisar uma das caudas, é necessário adicionar o parâmetro: alternative com um dos valores ("greater" ou "less")
t.test(dados$Altura, mu = 167, alternative = "greater") #avalia se a média amostral é maior que a média testada



#Boxplot: gráfico que permite a visualização da média, da distribuição dos dados e do desvio da minha amostra, bem como outliers
boxplot(dados$Altura, ylab = "Altura (cm)")