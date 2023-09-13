library(dplyr)
library(car)
install.packages("RVAideMemoire")
library(RVAideMemoire)
library(readxl)
library(psych)

dados <- read.csv("../Terceira Aula/banco de dados 2.csv", sep=';', dec=',')
dados1 <- read.csv("../Terceira Aula/banco de dados 3.csv", sep=';', dec=',')

#Estamos considerando a Posição na sala como variável independente
#e as notas como uma variável dependente

byf.shapiro(Nota_Biol ~ Posicao_Sala, dados)
byf.shapiro(Nota_Hist ~ Posicao_Sala, dados)
byf.shapiro(Nota_Fis ~ Posicao_Sala, dados)

leveneTest(Nota_Biol ~ Posicao_Sala, dados, center=mean)
leveneTest(Nota_Hist ~ Posicao_Sala, dados, center=mean)
leveneTest(Nota_Fis ~ Posicao_Sala, dados, center=mean)

#Teste T
#no teste T, o parâmetro var equal é a variação do grupo
#Se a variação é homogênea, TRUE, se é não homogênea, é falso

t.test(Nota_Biol ~ Posicao_Sala, dados, var.equal = TRUE)
t.test(Nota_Hist ~ Posicao_Sala, dados, var.equal = FALSE)
t.test(Nota_Fis ~ Posicao_Sala, dados, var.equal = FALSE)

par(mfrow=c(1,3)) #isso aqui é para estilizar a imagem
#Colocar os gráficos em uma linha e em três colunas diferentes
boxplot(Nota_Biol ~ Posicao_Sala, data = dados, ylim = c(0,10), ylab = "Notas Biologia", xlab = "Posição na Sala")
boxplot(Nota_Hist ~ Posicao_Sala, data = dados, ylim = c(0,10), ylab = "Notas História", xlab = "Posição na Sala")
boxplot(Nota_Fis ~ Posicao_Sala, data = dados, ylim = c(0,10), ylab = "Notas Física", xlab = "Posição na Sala")

#Gráfico não é mecanismo de confiabilidade final