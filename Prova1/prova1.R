#Prova 1


# Packages

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

# Dados
data('USArrests')
dados <- USArrests

summary(dados)

#     Murder          Assault         UrbanPop          Rape      
# Min.   : 0.800   Min.   : 45.0   Min.   :32.00   Min.   : 7.30  
# 1st Qu.: 4.075   1st Qu.:109.0   1st Qu.:54.50   1st Qu.:15.07  
# Median : 7.250   Median :159.0   Median :66.00   Median :20.10  
# Mean   : 7.788   Mean   :170.8   Mean   :65.54   Mean   :21.23  
# 3rd Qu.:11.250   3rd Qu.:249.0   3rd Qu.:77.75   3rd Qu.:26.18  
# Max.   :17.400   Max.   :337.0   Max.   :91.00   Max.   :46.00  

# Entendendo um pouco melhor os dados. Eu vou precisar colocá-los em uma mesma
# escala porque estamos tratando com distâncias. Não quero que uma variável que
# com um valor médio maior tenha mais influência na minha clusterização em
# detrimento de uma outra variável com um valor médio menor que possa explicar
# melhor meu modelo

#modelo hierárquico (dendograma)

?var
# Matriz de covariâncias, como duas variáveis se relacionam, mas padronizado
p.cov <- var(scale(dados))

p.mean <- apply(dados, 2, mean)

?mahalanobis
p.mah <- mahalanobis(dados, p.mean, p.cov)

View(p.mah)

# Como não tem nenhuma variável com uma relação de variáncias distoante, 
# não irei retirar nenhuma coluna do meu dataset

# Conforme comentei antes, colocando todos os dados na mesma escala
dados.p <- scale(dados)


# Avaliando os dados por meio da distância euclideana, eu poderia utilizar
# outras, na verdade, "euclidean", "maximum", "manhattan", "canberra",
# "binary", "minkowski", "pearson", "spearman" or "kendall"
# Vou fazer a análise tanto com a distância euclideana quanto com a distância
# de manhattan.

?dist
d.eucl <- dist(dados.p, method = 'euclidean')
d.manh <- dist(dados.p, method = 'manhattan')


#Conferindo as distâncias de Manhattan
round(as.matrix(d.manh)[1:5,1:5],1) 
#Método hierárquico da variância mínima de ward ou distância média
res.hc <- hclust(d = d.manh, method = 'ward.D2')
#Matriz cofonética
res.coph <- cophenetic(res.hc)
#Correlação entre a distância cofonética e a distância original
cor(d.manh, res.coph)
#comparando o método de ligação média - distância média
hc.m <- hclust(d.manh, method = 'average')
#Correlação entre a distância cofenética (com base no método da ligação média)
#e a distância original
cor(d.manh, cophenetic(hc.m))

# Dendograma Distância de Manhattan
fviz_dend(hc.m, cex = 0.5, k = 4, color_labels_by_k = TRUE, rect = TRUE)



# Mesma coisa para distância de Euclideana
round(as.matrix(d.eucl)[1:5,1:5],1) 
res.hc <- hclust(d = d.eucl, method = 'ward.D2')
res.coph <- cophenetic(res.hc)
cor(d.eucl, res.coph)
hc.m <- hclust(d.eucl, method = 'average')
cor(d.eucl, cophenetic(hc.m))

#DENDOGRAMA Distãncia Euclideana

groups <- 4

fviz_dend(hc.m, cex = 0.5, k = groups, color_labels_by_k = TRUE, rect = TRUE)


# Sobre as distâncias, não muda muita coisa, o que varia é o método utilizado
# para gerar os resultados, dependendo do tipo de dados que se tenha é interes-
# sante utilizar uma ou outra distância. No caso desse problema, permaneço
# com a distância euclideana.

# qual a altura ideal para "cortar" o dendograma?
# Por exemplo, nesse caso a altura 3 me entrega dois grupos onde um tem uma
# porrada de indivíduos, o outro tem excessões
# talvez essa não seja uma boa altura então

# A melhor altura é aquela que cria uma quantidade parcimoniosa de grupos com
# alta homogeneidade e heterogêneos entre si


#modelo não hierárquico (kmeans)

k_means<-kmeans(dados.p, centers = groups, nstart = 1)

plot(x=dados.p[,4], y=dados.p[,3], col=k_means$cluster)
points(k_means$centers, pch=3, cex=1)

# O modelo não hierárquico não vai criar relações de "altura" entre os grupos
# A divisão dos grupos será realizada com base, nesse caso, entre as médias
# dos componentes desse grupo

# Utilizei a mesma quantidade de grupos tanto para a clusterização hierárquica
# quanto não hierárquica

clusplot(dados.p, k_means$cluster, color = T, labels = 2, main = 'Grupos')

# O gráfico clusplot vai me mostrar como o modelo separou os grupos com base
# nos componentes que ele criou para a avaliação e quais os componentes de cada
# grupo. Eu achei interessante porque mostra de forma mais clara o que foi
# agrupado junto, da mesma forma que o dendograma fez
 
