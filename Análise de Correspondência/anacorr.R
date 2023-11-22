# 200058321
# Isabel Giannecchini

# Análise de Correspondência 
# Montar e pesquisar

# Imports

if(!require(FactoMineR)) install.packages("FactoMineR")  
if(!require(factoextra)) install.packages("factoextra") 
if(!require(tidyverse)) install.packages("tidyverse") 
if(!require(ggplot2)) install.packages("ggplot2")
if(!require(readr)) install.packages("readr")  

library(FactoMineR)  
library(factoextra) 
library(tidyverse) 
library(ggplot2)
library(readr)  

#Dados

dados <- read.csv("dados/dados_anacorr.csv")
dados <- dados[,c("SEX", "ACTIVITY.LEVEL", "MBTI", "POSTURE")]


# Simples (Anacor)

ca <- table(dados$POSTURE, dados$MBTI)
res.ca <- CA(ca)


# Multiple MCA

res_mca <- MCA(dados, graph = FALSE) #mesmo gráfico plotado por fviz_mca_var

fviz_screeplot(res_mca, addlabels = TRUE)

fviz_mca_var(res_mca, choice = 'mca.cor', repel = TRUE, ggtheme = theme_minimal()) + labs(title =  "MCA - Variáveis")

fviz_mca_var(res_mca, col.var = 'black', shape.var = 1, repel = TRUE)

fviz_cos2(res_mca, choice='var', axes= 3:4) + labs(x =  "", y= "", title="")


fviz_contrib(res_mca, choice='var', axes=3:4) + labs(x =  "", y= "Contribuições (%)", title="")

fviz_mca_biplot(res_mca,
                geom.ind = 'point',
                habillage = 3, 
                addEllipses = TRUE, 
                col.var = "black",
                title = '',
                legend.title = 'Personalidades',
                mean.point = FALSE, 
                repel = TRUE)
