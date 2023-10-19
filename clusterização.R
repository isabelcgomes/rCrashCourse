#Clusterização
#Agrupamentos por proximidade e características semelhantes
#

install.packages('factoextra')
library(factorextra)
#Passo a passo:
# Análise de variáveis e dos objetos a serem agrupados
# Seleção do critério de semelhança
# Seleção do algoritmo de agrupamento
# Definição do número de agrupamento
# Interpretação e validação dos agrupamentos

dados <- data('USArrests')


#Dá nomes às categorias
#As variáveis tem que ser relevantes para a pesquisa, por isso, tiramos
#categorias que não me ajudam a resolver o problema

fact <- data.frame(factbook[,2:11], row.names = factbook$GROCERY)

#Criar o primeiro grupo de variáveis estruturais
estrut <- data.frame(fact[,1:5])
#Criar o primeiro grupo de variáveis promocionais
promo <- data.frame(fact[6:10])

#Esse banco de dados foi tirado de um artigo bem antigo, o nome estruturais e
#promocionais é do artigo, não tem muita coisa a ver com o método em si,
#mas com o artigo

#Detecção de variáveis atípicas: promo calculando a distância (Mahalonobs,
# euclidiana, manhattan, canberra, binária, minkowiski...)
?dist
# Standardize first: selecionar variáveis relevantes
# As variáveis discrepantes tem que ser removidas do modelo 

p.cov <- var(scale(promo))
p.cov <- var(promo)

p.mean <- apply(promo,2,mean)
p.mah <- mahalanobis(promo, p.mean, p.cov)

remover <- c('CANNED_HA', 'EGGS')

promo.r <- promo[!(row.names(promo) %in% remover),]

#analisando a variância
#variáveis com escalas diferentes e variâncias diferntes podem distorcer a análise - promo r e o banco sem as variáveis atípicas, 2 signif um dimensao 2

#seleção de critérios de agrupamento (simiçaridade e dissimilaricade)

promo.p <- scale(promo.r)

#Calculando distância euclidiana
d.eucl <- dist(promo.p, method = 'euclidean')

#vizualizando a distância euclidiana para as quatro primeiras categorias
round(as.matrix(d.eucl)[1:4,1:4],1)

#Método hierárquico da variância mínima de ward ou distância média
# Hierárquico (aglomerativo/divisível)
# Não hierárquico
res.hc <- hclust(d = d.eucl, method = 'ward.D2')

#Matriz cofonética
res.coph <- cophonetic(res.hc)

#Correlação entre a distância cofonética e a distância original
cor(d.eucl, res.coph)

#comparando o método de ligação média - distância média
hc.m <- hclust(d.eucl, method = 'average')

#Correlação entre a distância cofonética (com base no método da ligação média) e a distância original
cor(d.eucl, cophonetic(hc.m))


#DENDOGRAMA

fviz_dend(hc.m, cex = 0.5)

#qual a distância ideal?
#Por exemplo, nesse caso a distância 6 me entrega dois grupos onde um tem uma porrada de indivíduos, o outro tem excessões
#talvez essa não seja uma boa distância então

#Avaliar


