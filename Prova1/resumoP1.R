#como importar uma biblioteca

# install.packages('nome da lib')
# library(nome da lib)
if(!require(factoextra)) install.packages("factoextra")
if(!require(readxl)) install.packages("readxl")
if(!require(dplyr)) install.packages("dplyr")
if(!require(car)) install.packages("car")
if(!require(psych)) install.packages("psych")
if(!require(RVAideMemoire)) install.packages("RVAideMemoire")
if(!require(pacman)) install.packages("pacman")

library(factoextra)
library(readxl)
library(dplyr)
library(car)
library(psych)
library(RVAideMemoire)
library(pacman)
pacman :: p_load(dplyr, ggplot2, car, rstatix, lmtest, ggpubr, ggpmisc, psych, MASS, DescTools, QuantPsyc)



#ler dados

# dados <- read.csv()
# dados <- read_excel() #precisa de uma biblioteca para funcionar (readxl)


dados <- read_excel('dados/Banco de Dados __SSD 2 2023 (1).xlsx')

# Tipo de dados 

## Sujeito - Não métrico - nominal
## Genero - Não métrico - nominal
## Grau_de_Instruçao - Não métrico - ordinal
## N_Filhos - Métrico - Razão
## Idade - Métrico - Razão
## Altura - Métrico - Razão
## Salario - Métrico - Razão

summary(dados)

# Tratamento de dados

# Existem mil formas de tratar dados faltantes, por exemplo
# Outra coisa é que existem formas de transformar dados para deixá-los mais
# fáceis de tratar, por exemplo, transformar um dado de texto em numérico

lista_genero <- c(unique(dados$Genero))
dados$Genero_num <- factor(dados$Genero, labels=c(0,1), levels = lista_genero)

class(dados$Genero_num) <- as.numeric(dados$Genero_num)

lista_inst <- c(unique(dados$Grau_de_Instruçao))
length(lista_inst)
dados$Grau_de_Instruçao_num <- factor(dados$Grau_de_Instruçao, labels=c(3,1,2),
                                      levels = lista_inst)

dados$Grau_de_Instruçao_num <- as.numeric(dados$Grau_de_Instruçao_num)

#tipos de análises que podem ser realizadas

#shapiro test
# Avalia a normalidade da amostra
# H0 - A Amostra é Normal
# H1 - A amostra não é normal

#pValor < NS - Aceita H1
#pValor > NS - Aceita H0

shapiro.test(dados$Grau_de_Instruçao_num)

# Shapiro-Wilk normality test
# 
# data:  dados$Grau_de_Instruçao_num
# W = 0.74264, p-value = 6.941e-06

# P Valor < NS
# Rejeita H0
# A amostra não segue a distribuição normal
plot(dados$Grau_de_Instruçao_num)

shapiro.test(dados$Altura)

# Shapiro-Wilk normality test

# data:  dados$Altura
# W = 0.95384, p-value = 0.214

# P Valor > NS
# Aceita H0
# A amostra segue a distribuição normal
boxplot(dados$Altura)
plot(density(dados$Altura))

#Levene test
# Teste de homocedasticidade


leveneTest(dados$Salario ~ dados$Genero, center=mean)

# Levene's Test for Homogeneity of Variance (center = mean)
#       Df F value  Pr(>F)
# group  1  0.0047  0.946
#       28

# P Valor > NS
# Aceita H0
# A amostra é homocedástica (variâncias homogêneas)



leveneTest(dados$N_Filhos ~ dados$Grau_de_Instruçao, center=mean)
# Levene's Test for Homogeneity of Variance (center = mean)
#       Df F value  Pr(>F)  
# group  2  4.3529 0.02299 *
#       27                  
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# P Valor < NS
# rejeita H0
# A amostra não é homocedástica (variâncias heterogêneas)

# se p valor < NS significa que é muito difícil que a alteração nas variâncias
# tenha acontecido de forma aleatória, então a amostra não seria homocedástica

# Teste T 
# Avalia se a tendência central de uma amostra está de acordo com o esperado

t.test(dados$Altura, mu = 163)

#H0 -> a média dos dados é igual a 163
#H1 -> a média dos dados é DIFERENTE de 163

# Teste T unicaudal
# Avalia se a média é maior ou menor que o valor escolhido

t.test(dados$Altura, mu = 163, alternative = "greater")

# data:  dados$Altura
# t = 2.6609, df = 29, p-value = 0.006284
# alternative hypothesis: true mean is greater than 163
# 95 percent confidence interval:
#   164.9639      Inf
# sample estimates:
#   mean of x 
# 168.4333

#sim, é maior, por isso, pvalor < NS, porque H1 é valida então rejeitamos H0

t.test(dados$Altura, mu = 163, alternative = "less")

# data:  dados$Altura
# t = 2.6609, df = 29, p-value = 0.9937
# alternative hypothesis: true mean is less than 163
# 95 percent confidence interval:
#   -Inf 171.9028
# sample estimates:
#   mean of x 
# 168.4333

#não, é maior, por isso, pvalor > NS, porque H0 é valida então aceitamos H0


mean(dados$Altura)
# > mean(dados$Altura)
# [1] 168.4333

#como, nesse caso, a média é 168, diferente de 163, p valor < NS então aceitamos a H1 que a altura média é diferente de 163

# One Sample t-test
# 
# data:  dados$Altura
# t = 2.6609, df = 29, p-value = 0.01257
# alternative hypothesis: true mean is not equal to 163
# 95 percent confidence interval:
#   164.2572 172.6095
# sample estimates:
#   mean of x 
# 168.4333 


# 95 percent confidence interval:
#   164.2572 172.6095

# Intervalo de confiança de 95% significa que a chance de a média estar entre 
# esses dois valores é de 95%
# Avaliando o gráfico de densidade, faz total sentido, já que a concentração de
# amostras entre esses dois valores é altíssima

table(dados$Genero)
# Me mostra a frequência de cada categoria

n_class <- nclass.Sturges(dados$Salario)
#divide meu conjunto de dados contínuos em categorias, grupinhos

table(cut(dados$Salario, seq(0, n_class, l=(n_class+1))))
# me mostra a frequência de cada categoria criada. em l eu coloco um número a
# mais que a quantidade de categorías para considerar as extremidades

plot(density(table(cut(dados$Salario, seq(0, n_class, l=(n_class+1))))))

summary(dados)
# entrega um resumo dos dados por coluna

describe(dados)
# entrega um resumo diferente dos dados, também por coluna

describeBy(dados, group = dados$Genero)
# entrega um resumo diferente dos dados, também por coluna, agrupado por
# determinada característica

byf.shapiro(Salario ~ Genero, dados)

# Shapiro Test dividido por grupos
# Shapiro-Wilk normality tests
# 
# data:  Salario by Genero 
# 
# W p-value
# F 0.9525  0.5655
# M 0.9507  0.5354

# P Valor > NS
# Aceita H0
# A amostra segue a distribuição normal

leveneTest(Salario ~ Genero, dados, center=mean)
# Levene's Test for Homogeneity of Variance (center = mean)
#       Df F value Pr(>F)
# group  1  0.0047  0.946
#       28 

# P Valor > NS
# Aceita H0
# A amostra é homocedástica (variâncias homogêneas)



# Modelo Linear
mod <- lm(Salario ~ Idade, dados)

# Regressão linear para avaliar qual a relação entre as duas variáveis
# A regressão linear só vale para dados métricos

shapiro.test(mod$residuals)
# avalia a normalidade de resíduos
# p valor < NS - não há normalidade
# p valor > NS - há normalidade

summary(rstandard(mod))
# isso me mostra que o ponto de máximo e de mínimo do resíduo do modelo
# não ultrapassam -3 e +3


bptest(mod)
# Breusch-Pagan - verifica a homocedasticidade DO MODELO
# regressão => breusch-pagan
# dados separados => levene
# p valor < NS - não há homocedasticidade
# p valor > NS - há homocedasticidade

durbinWatsonTest(mod)
# verifica se os resíduos são ou não independentes
# se os resíduos são INDEPENDENTES entre si, pvalor > NS, autocorrelação = 0
# se os resíduos são dependentes entre si, pvalor < NS, autocorrelação != 0

summary(mod)
#hipótese nula: b1=b2=b3=...=bx=0 -> modelo não é significativa
#hipótese alternativa: b1!=b2!=b3!=...!=bx!=0 -> modelo é significativo
#se pvalor < NS -> a minha hipótese alternativa indica que uma determinada variável pode influenciar a outra variável
#meu r² indica o quanto minha variável independente explica minha variável dependente em níveis percentuais
#r² ajustado é o ajuste do meu r² para corrigir algumas questões do modelo
#meu r² maior só é melhor se eu estou avaliando a população inteira

# Baseado no pvalor, meu modelo é significativo (pvalor < NS)


ggplot(data = dados, mapping = aes(x = Idade, y = Salario))+
  geom_point()+theme_classic()+
  geom_smooth(method = 'lm', col = "red")


# Regressão Logística
# Funciona para classificação binária com base em variáveis independentes métricas

mod<-glm(Genero_num ~ N_Filhos + Salario,
         family = binomial(link = 'logit'), data = dados)

plot(mod, which = 5)

summary(stdres(mod))

pairs.panels(dados[2:5])
# Correlação de pearson
# Verifica multicolinearidade (r>0.9 (0.8))
# quando a multicolinearidade é próxima de 1, significa que as variáveis são iguais.
# uma multicolinearidade alta (entretanto menor que 0.9) significa que uma variável tem bastante influência sobre a outra

vif(mod)
#fator de variância de inflação
#multicolinearidade: VIF>10
#Aparece o resultado das variáveis independentes
#Se o resultado for maior que 10, a variável é 'igual'



intlog <- dados$Salario * log(dados$Salario)

dados$intlog <- intlog

modint <- glm(Genero_num ~ N_Filhos + Salario + intlog,
              family = binomial(link = 'logit'),
              data = dados)

summary(modint)

logito <- mod$linear.predictors
dados$logito <- logito


ggplot(dados, aes(logito, Salario)) +
  geom_point(size=0.5, alpha=0.5) +
  geom_smooth(method = 'loess') +
  theme_classic()

Anova(mod, type = 'II', test= 'Wald')

#obtenção das razões de chance com IC 95% (log-likelihood)

exp(cbind(OR = coef(mod), confint(mod)))  #OR = odd ratio (razões de chance)

exp(coef(mod))

exp(cbind(OR = coef(mod), confint.default(mod)))

# Esse resultado me diz que quem tem mais filhos tem 1.06 x mais chances de ser mulher

mod2 <- glm(Genero_num ~ N_Filhos,
            family = binomial(link = 'logit'),
            data = dados)
summary(mod2)
Anova(mod2, type = 'II', test= 'Wald')
exp(cbind(OR=coef(mod2), confint(mod2)))

PseudoR2(mod, which = 'Nagelkerke') 
PseudoR2(mod2, which = 'Nagelkerke')

AIC(mod, mod2)
BIC(mod, mod2)

#comparação de modelos
## AIC e BIC (quanto menor melhor)

#na teoria, o menor valor representa o melhor modelo, entretanto, o modelo 2 é 100% enviesado


mod3 <- glm(Genero_num ~ N_Filhos+Altura+Idade,
            family = binomial(link = 'logit'),
            data = dados)
summary(mod3)
Anova(mod3, type = 'II', test= 'Wald')
exp(cbind(OR=coef(mod3), confint(mod3)))

PseudoR2(mod, which = 'Nagelkerke') 
PseudoR2(mod3, which = 'Nagelkerke')

AIC(mod, mod3)
BIC(mod, mod3)

# O menor valor nos dois resultou o modelo 1

ClassLog(MOD = mod, dados$Genero_num)
ClassLog(mod3, dados$Genero_num)
# Variável dependente
# Do grupo que respondeu, 8 pessoas que disseram ser mulheres, realmente
# eram, enquanto que 8 pessoas que disseram que são homens, são.

table(dados$Genero_num)

table(dados$Genero_num, dados$N_Filhos)
# 8 mulheres não tem nenhum filho, 3 tem 1, 3 tem 2, nenhuma tem 3 e uma tem 4
# 7 homens não tem filhos, 4 tem 1, 3 tem 2, 1 tem 3 e nenhum tem 4


# Custerização

# Agrupamento por meio de características semelhantes

dados$Genero_num <- as.numeric(dados$Genero_num)
dados$Grau_de_Instruçao_num <- as.numeric(dados$Grau_de_Instruçao_num)

fact <- data.frame(dados[4:9])

p.cov <- var(scale(fact))
p.cov <- var(fact)


p.mean <- apply(fact, 2, mean)
p.mah <- mahalanobis(fact, p.mean, p.cov)

fact.r <- subset(fact, select = -Altura )

fact.p <- scale(fact.r)

d.eucl <- dist(fact.p, method = 'euclidean')

round(as.matrix(d.eucl)[1:5,1:5],1)


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
cor(d.eucl, cophenetic(hc.m))

#DENDOGRAMA

fviz_dend(hc.m, cex = 0.5)

#qual a distância ideal?
#Por exemplo, nesse caso a distância 4 me entrega dois grupos onde um tem uma porrada de indivíduos, o outro tem excessões
#talvez essa não seja uma boa distância então

# A melhor distância é aquela que cria uma quantidade parcimoniosa de grupos com alta homogeneidade e heterogêneos entre si
