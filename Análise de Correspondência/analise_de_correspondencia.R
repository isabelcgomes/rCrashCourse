#Análise de Correspondência, MCA

if(!require(FactoMineR)) install.packages("FactoMineR")
if(!require(factoextra)) install.packages("factoextra")
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(ggplot2)) install.packages("ggplot2")
if(!require(readxl)) install.packages("readxl")

library(FactoMineR)
library(factoextra)
library(tidyverse)
library(ggplot2)
library(readxl)

data(package = "FactoMineR")
data("hobbies")

#Definição da Análise de Matriz de Correspondência Múltipla
res_mca <- MCA(dados, graph = TRUE)

fviz_screeplot(res_mca, addlabels = TRUE, ylim = c(0,4))



test <- MCA(hobbies, graph = TRUE)
fviz_screeplot(test, addlabels = TRUE, ylim = c(0,4))
#Scree Plot 
# Me dá informações sobre a inércia do modelo (porcentagem de inércia explicado por cada dimensão (atributo))
# A inércia nada mais é do que a variância do modelo

fviz_screeplot(test, choice = "mca.cor", repel=TRUE, ggtheme = theme_minimal()) + labs(title = "MCA_var")

# Gráfico de categorias

fviz_mca_var(test, col.val = "black", shape.var = 1, repel=TRUE)

hobbies_mca <- MCA(hobbies, quanti.sup = 23, graph=TRUE)
fviz_mca_biplot(hobbies_mca, geom.ind = 'nome', repel=TRUE)
fviz_screeplot(hobbies_mca,addlabels = TRUE, ylim = c(0,4))

fviz_mca_var(hobbies_mca, choice = "mca.cor", repel=TRUE,
             ggtheme = theme_minimal()) + labs(title = "MCA_var")

fviz_cos2(hobbies_mca, choices ='var', shape.var = 1, repel = TRUE)

fviz_contrib(hobbies_mca, choice = 'var', axes=1:2, top=23, 
             ggtheme = theme_minimal())

hobbies %>% select(1:18) %>% names()

fviz_mca_biplot(hobbies_mca, geom.ind = 'none', habillage = 'Cinema', addEllipses = TRUE, 
                palette = c('green', 'blue'), title = '', legend.title = 'publisher', mean.point=FALSE, repel =TRUE)

