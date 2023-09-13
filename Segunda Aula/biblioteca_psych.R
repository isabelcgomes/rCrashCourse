install.packages('psych')
library(psych) #biblioteca bastante utilizada na bioestatística e na psicometria
library(readxl)
library(dplyr)
library(car)

?psych

dados <- read_excel('dados.xlsx')
View(dados)

glimpse(dados)


#frequências absolutas
#frequências é quantas vezes um "cara" se repete
table(dados$Genero)
table(dados$Grau_de_Instruçao)

#frequências relativas
#percentual
prop.table(table(dados$Genero))
prop.table(table(dados$Grau_de_Instruçao))

#Variáveis Contínuas

range(dados$Altura) #amplitude dos meus dados

#avaliar a quantidade adequada de categorias em uma determinada variável contínua
nclass.Sturges(dados$Salario)

table(cut(dados$Salario, seq(0,6,l=7)))#eu sempre coloco um número a mais do que minha quantidade de categorias porque eu tenho que considerar as extremidades

#média, mediana, quartis e valores minimo e máximo de uma amostra
summary(dados$N_Filhos)

describe(dados$Salario)#me gera algumas coisas, média, desvio, erro e mediana da minha amostra

describeBy(dados$Salario, group = dados$Genero) #descreve por grupos
describeBy(dados$Salario, group = dados$Genero: dados$Grau_de_Instruçao_num) #descreve por grupos