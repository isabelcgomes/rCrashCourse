#Regressão Logística Multnomial

install.packages('readxl')
install.packages('pacman')
install.packages('psych')
install.packages('mlogit')
install.packages('dfidx')
install.packages('nnet')

library(mlogit)
library(dfidx)
library(nnet)
library(pacman)
library(readxl)
library(readxl)
library(psych)
library(car)

pacman :: p_load(dplyr, psych, car, MASS, DescTools, QuantPsych, ggplot2)

dados <- read_excel('AtrasadoMultinomial.xls')
dados <- mutate(dados, across(where(is.character), as.factor))
colnames(dados) <- c('Estudante', 'Atrasado', 'Distancia','Semaforos')

summary(dados)

#Checagem dos pressupostos

#1. Variável dependente nominal (categorias mutuamente exclusivas) 
#2. Independência das observações (não tem medidas repetidas)
#3. Ausência de multicolinearidade

#gráfico de Poison

psych::pairs.panels(dados[2:4])

#VIF só pode acontecer em uma REGRESSÃO LINEAR
#Podemos então criar uma regressão linear para fazer essa análise

m <- lm(Atrasado ~ Distancia + Semaforos, data = dados) 
#lm = linear model
#as.numeric = transformo minha variável caegórica em numérica

car::vif(m) #Fator de variância de Inflação
#todos os resultados tem que ser menor do que 10 para garantir que não há colinearidade entre as variáveis

#Testar pressupostos da ligística multinomial
# 4. Independência de alternativas irrelevantes (teste Hausman-McFadden)

#testa o impacto do modelo excluindo os elementos que não são da categoria de referência


#iia = independência alternativa irrelevante
#modelo completo, intercepto igual a 1, formato wide, categoria de referência Não Atrasado
modiia <- mlogit::mlogit(Atrasado ~ 1|Distancia + Semaforos, data = dados, shape = 'wide', refLevel = '0')

modiia2 <- mlogit::mlogit(Atrasado ~ 1|Distancia + Semaforos, data = dados, shape = 'wide', refLevel = '0', alt.subset = c('0', '1'))

modiia3 <- mlogit::mlogit(Atrasado ~ 1|Distancia + Semaforos, data = dados, shape = 'wide', refLevel = '0', alt.subset = c('0', '2'))

mlogit::hmftest(modiia,modiia2)
mlogit::hmftest(modiia,modiia3)

#hipótese alternativa: rejeita IIA

#H0 existe independência das alternativas irrelevantes
#H1 não existe independência das alternativas irrelevantes

#Construção do modelo e do modelo nulo

mod <- multinom(Atrasado ~ Distancia + Semaforos, data = dados, model=TRUE)

mod0 <- multinom(Atrasado ~ 1, data = dados, model = TRUE)

# Ajuste do modelo 
anova(mod, mod0)

#H0 se o modelo construído é igual ao modelo nulo, significa que o modelo é inútil
#H1 se o modelo construído é diferente do modelo nulo, perfeito melhor dos casos


DescTools::PseudoR2(mod, which = 'Nagelkerke')
DescTools::PseudoR2(mod0, which = 'Nagelkerke')

car::Anova(mod, type = 'II', test='wald')
#p=1 (maior que NS, aceita H0)

#pv < NS significativo
#Ambas as variáveis são significativas, então mantém as duas

#Efeitos Específicos
summary(mod)

#compara a categoria de referência com HC e outros

#Obtenção dos valores de p - por Wald (pacote lmtest)

exp(coef(mod)) #maior que 0, menor que 1, as pessoas preferem votar no outro candidato
#menor que 0, as pessoas afirmam que não votariam nela
#maior que 1, as pessoas preferem votar nesse candidato do que no candidato da categoria de referência
exp(confint(mod))


tab <- table(Observado = dados$Atrasado, Previsto=predict(mod))

tab


