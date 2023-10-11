if(!require(pacman)) install.packages("pacman")
library(pacman)

library(readxl)

library(dplyr)

pacman :: p_load(dplyr, psych, car, MASS, DescTools, QUantPsyc, ggplot2)

dados <- read_excel('dados/Dados.xls', string2factors())
colnames(dados) <- c('Estresse', 'Fuma', 'Cancer')

dados <- mutate(dados, across(where(is.character), as.factor))

View(dados)
glimpse(dados)

table(dados$Cancer)
summary(dados)



plot(dados$Estresse, dados$Cancer)

levels(dados$Cancer)
levels(dados$Fuma)

mod<-glm(Cancer ~ Estresse + Fuma,
         family = binomial(link = 'logit'), data = dados)

plot(mod, which = 5)

summary(stdres(mod))

pairs.panels(dados)#Correlação de pearson
# Verifica multicolinearidade (r>0.9 (0.8))
# Não existe cosenso no meio científico quando se trata de multicolinearidade.
#Há autores que dizem que é uma falha grava e há autores que dizem que não é
#uma falha at all
#As variáveis estresse e cancer são diferentes, porque r é menor que 0.9 

vif(mod) #fator de variância de inflação
#multicolinearidade: VIF>10
#Aparece o resultado das variáveis independentes
#Se o resultado for maior que 10, a variável é 'igual'

#5. Relação linear entre cada V.I. contínua e o logito da V.D.

#Box-Tidwell
#Pressuposto da regressão logística
#Verifica a relação linear de cada VI com cada logito da
#VD (logito é o log da VD)
#Manual do R

intlog <- dados$Estresse * log(dados$Estresse) 
#Eu gero uma variável de interação para avaliar se existe uma ralação entre as variáveis

#adicionar a variável intlog no banco de dados
dados$intlog <- intlog

modint <- glm(Cancer ~ Fuma + Estresse + intlog,
              family = binomial(link = 'logit'),
              data = dados)
#modelo de interação: variável contínua dependente e seu log.
#Se a variável não for significativa, o teste foi atendido
#Só existe relação linear se a variável interação logaritmica (intlog) não for significativa.
#Se pvalor de intlog > NS, aceita H0, então intlog não é significativa

summary(modint)

#Existem outras formas de verificar essa relação

logito <- mod$linear.predictors
dados$logito <- logito

#outra forma de calcular o logitto:
#prob <- predict(mod, type = 'response')
#logito2 <- log(prob/(1-prob))

ggplot(dados, aes(logito, Estresse)) +
  geom_point(size=0.5, alpha=0.5) +
  geom_smooth(method = 'loess') +
  theme_classic()

#esse gráfico fica parecendo polinomial entretanto isso é um corte bem pequeno do gráfico.
#no todo, a distribuição é linear, sabemos disso pelo teste BoxTidwell(linha 49)

#Anova, efeito geral, o efeito global daquele ocnjunto de dados
Anova(mod, type = 'II', test= 'Wald')
#existem vários tipos de teste de anova
#de acordo com o teste, a variável "Estresse" não é relevante para o meu modelo
#Está utilizando como referência o valor 'Sim'

#Efeitos específicos:

summary(mod)

#obtenção das razões de chance com IC 95% (log-likelihood)

exp(cbind(OR = coef(mod), confint(mod)))  #OR = odd ratio (razões de chance)

exp(coef(mod))

exp(cbind(OR = coef(mod), confint.default(mod)))

# RESULTADO:
#                 OR      2.5 %     97.5 %
# (Intercept) 0.08243251 0.01363206  0.4984661
# Estresse    1.03242673 0.98998883  1.0766838
# FumaSim     8.71502396 2.22854349 34.0812926

# Esse valor de 8.71502396 me indica que a pessoa que fuma tem 8,71x mais
# chance de desenvolver cancer do que uma pessoa que não fuma

# Mesma coisa isso aqui 1.03242673 que indica que quanto maior o estresse da
# pessoa, maior a chance dela de ter câncer. Nesse caso, o estresse não é uma 
# variável significativa por causa do resultado de seu pvalor que foi maior que 
# o nível de significância e, portanto, aceita a H0 e o estresse 
# não é significativo

mod2 <- glm(Cancer ~ Fuma,
              family = binomial(link = 'logit'),
              data = dados)
Anova(mod2, type = 'II', test= 'Wald')

#Aceito H1, Fumar é estatisticamente significativo

summary(mod2)

exp(cbind(OR=coef(mod2), confint(mod2)))

# Pseudo R²
# O maior R² provavelmente é o maior modelo, mas isso não é afirmável. 
# Não existe R² em uma regressão logística
PseudoR2(mod, which = 'Nagelkerke') 
PseudoR2(mod2, which = 'Nagelkerke')


#comparação de modelos
## AIC e BIC (quanto menor melhor)

AIC(mod, mod2)
BIC(mod, mod2)
# princípio da parcimônia, vai no modelo mais simples
# nesse caso é o mod2 porque tem menos variáveis

#podemos comparar modelos usando ANOVA
anova(mod2, mod, test='Chisq') 

ClassLog(MOD = mod, dados$Cancer)
ClassLog(mod2, dados$Cancer)

table(dados$Cancer)

table(dados$Cancer, dados$Fuma)
