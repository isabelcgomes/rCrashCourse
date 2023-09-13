install.packages("dplyr")
library(dplyr)

install.packages("car")
library(car)

install.packages("readxl")
library(readxl)

dados <- read_excel("Banco de Dados __SSD 2 2023 (1).xlsx")

len_graus_de_instrucao <- seq.int(0, length(graus_de_instrucao)-1, 1)

dados$Genero_num <- factor(dados$Genero, labels = c(seq.int(0, length(unique(dados$Genero))-1, 1)), levels = c(unique(dados$Genero)))
dados$Instrucao_num <- factor(dados$Grau_de_Instruçao, labels = c(seq.int(0, length(unique(dados$Grau_de_Instruçao))-1, 1)), levels = c(unique(dados$Grau_de_Instruçao)))

class(dados$Instrucao_num) = 'Numeric'


#normalidade
#se o p-valor for maior que significância rejeita a H0 
#H0 é a hipótese de diz que os dados apresentam uma distribuição normal


shapiro.test(dados$Altura)
shapiro.test(dados$Salario)

#DataViz
boxplot(dados$Altura, ylab="Altura (cm)")

t.test(dados$Altura)

summary(dados$Altura)

#Frequências
#Absoluta: trata sobre quantidades
#Relativa: trata sobre porcentagens

table(dados$Genero)
table(dados$Grau_de_Instruçao)

table(dados$Grau_de_Instruçao, dados$Genero)

prop.table(table(dados$Grau_de_Instruçao, dados$Genero))

prop.table(table(dados$Grau_de_Instruçao, dados$N_Filhos))

#Método de Sturges
#Serve para categorizar dados contínuos
range(dados$Salario) #os salários estão variando entre 1 e 5.8
nclass.Sturges(dados$Salario) #quantdiade de classes nas quais se podem dividir os dados

sturges_cut <- table(cut(dados$Salario, seq(0,6, l=7)))

dados$Salario_disc<- factor(dados$Salario, labels = cut(dados$Salario, seq(0,6, l=7)), levels = c(unique(dados$Salario))) #classes+1 para considerar as extremidades

sturges_cut <- cut(dados$Salario, seq(0,6, l=7))
sturge_levels <-(levels(sturges_cut))


sturges_levels_divided <- c(cbind(lower = as.numeric( sub("\\((.+),.*", "\\1", sturge_levels) ),
      upper = as.numeric( sub("[^,]*,([^]]*)\\]", "\\1", sturge_levels) )))
sturges_upper <- cbind(upper = as.numeric( sub("[^,]*,([^]]*)\\]", "\\1", sturge_levels) ))
sturges_levels_divided

dados <- drop(dados$Salario_disc)

sturges_upper[1]

list <- c()


for (salario in dados$Salario){
  
  if (salario <= sturges_upper[1]){
    list <- append(list, sturges_upper[1])
    
  }
  else if (salario <= sturges_upper[2]){
    list <- append(list, sturges_upper[2])
    
  }
  else if (salario <= sturges_upper[3]){
    list <- append(list, sturges_upper[3])
    
  }
  else if (salario <= sturges_upper[4]){
    list <- append(list, sturges_upper[4])
    
  }
  else if (salario <= sturges_upper[5]){
    list <- append(list, sturges_upper[5])
    
  }
  else if (salario <= sturges_upper[6]){
    list <- append(list, sturges_upper[6])
    
  }
}



dados$Salario_disc <- list

list

install.packages("psych")
library(psych)

describe(dados$Salario)

describeBy(dados$Salario, group = dados$Genero)


#hipóteses
#nula: as variâncias são homogêneas
#alternativa: as variâncias não são homogêneas


