#Regressão Logística Multnomial

install.packages('pacman')
library(pacman)

dados <- read.csv('dados/MOCK_DATA.csv', stringsAsFactors = TRUE,  fileEncoding = 'latin1' )

summary(dados)

levels(dados$Voto)
#eu só calculo a categoria de referência da minha variável categórica
#O primeiro resultado de Levels é a minha referência

levels(dados$Etnia)

#também é possível trocar a minha referência
dados$Etnia <- relevel(dados$Etnia, ref = "Ford")
levels(dados$Etnia)

#Checagem dos pressupostos

#1. Variável dependente nominal (categorias mutuamente exclusivas) 
#2. Independência das observações (não tem medidas repetidas)
#3. Ausência de multicolinearidade

#gráfico de Poison

psych::pairs.panels(dados[3:5])

#VIF só pode acontecer em uma REGRESSÃO LINEAR
#Podemos então criar uma regressão linear para fazer essa análise

m <- lm(as.numeric(Voto) ~ Etnia + ConfPol + LibEcon, data = dados) 
#lm = linear model
#as.numeric = transformo minha variável caegórica em numérica

car::vif(m) #Fator de variância de Inflação
#todos os resultados tem que ser menor do que 10 para garantir que não há colinearidade entre as variáveis

#Testar pressupostos da ligística multinomial
# 4. Independência de alternativas irrelevantes (teste Hausman-McFadden)

#testa o impacto do modelo excluindo os elementos que não são da categoria de referência

install.packages('mlogit')
library(mlogit)

install.packages('dfidx')
library(dfidx)

install.packages('nnet')
library(nnet)


levels(dados$Voto)

unique(dados$Voto)

#iia = independência alternativa irrelevante
#modelo completo, intercepto igual a 1, formato wide, categoria de referência Donald Trump
modiia <- mlogit::mlogit(Voto ~ 1|Etnia + ConfPol + LibEcon, data = dados, shape = 'wide', refLevel = 'Amalle')

modiia2 <- mlogit::mlogit(Voto ~ 1|Etnia + ConfPol + LibEcon, data = dados, shape = 'wide', refLevel = 'Amalle', alt.subset = c('Amalle', 'Lisette'))

modiia3 <- mlogit::mlogit(Voto ~ 1|Etnia + ConfPol + LibEcon, data = dados, shape = 'wide', refLevel = 'Amalle', alt.subset = c('Amalle', 'Others'))

mlogit::hmftest(modiia,modiia2)
mlogit::hmftest(modiia,modiia3)

#hipótese alternativa: rejeita IIA

#H0 existe independência das alternativas irrelevantes
#H1 não existe independência das alternativas irrelevantes

#Construção do modelo e do modelo nulo

mod <- multinom(Voto ~ ConfPol + LibEcon + Etnia, data = dados, model=TRUE)

mod0 <- multinom(Voto ~ 1, data = dados, model = TRUE)

# Ajuste do modelo 
anova(mod, mod0)

#H0 se o modelo construído é igual ao modelo nulo, significa que o modelo é inútil
#H1 se o modelo construído é diferente do modelo nulo, perfeito melhor dos casos


DescTools::PseudoR2(mod, which = 'Nagelkerke')
DescTools::PseudoR2(mod0, which = 'Nagelkerke')

car::Anova(mod, type = 'II', test='wald')

#pv < NS significativo
#pv > NS não significativo - aceita H0

#Efeitos Específicos
summary(mod)

#compara a categoria de refeência com HC e outros

#Obtenção dos valores de p - por Wald (pacote lmtest)

lmtest::coeftest(mod) #se o sinal é negativo a relação é inversamente proporcional, se for positivo, a tendência aumenta com o aumento daquela variável

exp(coef(mod)) #maior que 0, menor que 1, as pessoas preferem votar no outro candidato
#menor que 0, as pessoas afirmam que não votariam nela
#maior que 1, as pessoas preferem votar nesse candidato do que no candidato da categoria de referência
exp(confint(mod))

mod2 <- multinom(Voto ~ LibEcon + Etnia, data = dados, model=TRUE) #modelo sem a variável não significativa
car::Anova(mod2, type = 'II', test='wald')
summary(mod2)
lmtest::coeftest(mod2) #se o sinal é negativo a relação é inversamente proporcional, se for positivo, a tendência aumenta com o aumento daquela variável


AIC(mod, mod2)
BIC(mod, mod2)
#esses dois são pmétodos para avaliar parcimônia, eu escolho sempre os de menor valor

#Tabela de classificação, método de saber se o modleo está acertando
tab <- table(Observado = dados$Voto, Previsto=predict(mod2))

tab


