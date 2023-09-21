# Isabel Caroline Gomes Giannecchini
# 200058321

#Importação das bibliotecas(todas elas já estavam instaladas)
library(car)
library(dplyr)
library(pacman)
pacman :: p_load(dplyr, ggplot2, car, rstatix, lmtest, ggpubr, ggmisc, psych)
library(readxl)

################################################################################
#                                                                              #
#                            Regressão simples                                 #
#                                                                              #
################################################################################


#Importação dos dados e criação do modelo de regressão linear
dados <- read.csv("Banco de Dados 11.csv", sep=';', dec=',')
mod <- lm(Vendas ~ Publicidade, dados )

#Gráficos de análise do conjunto de dados
par(mfrow = c(2,2))
plot(mod)

# 1. Gráfico Residuals VS. FIltered
#   - Analisa linearidade (a linha de tendência indica a linearidade entre as 
#     variáveis)
#   - quanto mais horizontal mais linear as variáveis
#   - Se fez um triângulo, é garantia que não tem linearidade no modelo 
# 
# 2. Gráfico Normal QQ
#   - Resíduos normalizados pelos resíduos teóricos
#   - Caso tenhamos uma distribuição normal, os pontos devem estar na linha de
#     tendência
# 
# 3. Gráfico Scale-Location
#   - Avalia a homocedasticidade do modelo
#   - Quanto mais horizontal mais homocedástico
# 
# 4. Gráfico Residuals vs leverage
#   - Avalia a presença de outliers e pontos de alavancagem
#   - Se passa de -3 a 3 é um sinal de outliers ou pontos de alavancagem

#Testes Estatísticos:

shapiro.test(mod$residuals)
#Teste Shapiro, é um teste de normalidade, ele avalia se a distribuição de um
#conjunto de dados se aproxima de uma distribuição normal.

#Resultado:

#Shapiro-Wilk normality test
#data:  mod$residuals
#W = 0.99193, p-value = 0.3856

#Como o p-valor é maior que o nível de significância (0,05), a distribuição é normal

summary(rstandard(mod))
#Teste para obtenção dos resíduos padronizados
#Se meus valores máximo e mínimo estão entre -3 e 3, isso significa que 
#os meus dados estão dentro de 6sigma (6 desvios padrão) de "distância" da minha
#linha de tendência central, indicando que não há outliers no meu modelo

# Resultados:

# Min.        1st Qu.     Median       Mean     3rd Qu.     Max. 
# -2.1981347 -0.7064734  0.0392186 -0.0000075  0.6828619  2.3753897 

#Como os valores máximo e mínimo estão dentro do intervalo entre -3 e 3, pode-se
#dizer que os meus dados estão dentro do intervalo de 6 desvios padrão e não há
#outliers no modelo 


bptest(mod)
#breusch-pagan - verifica a homocedasticidade do modelo
#um modelo homocedástico indica uma variância constante nos erros.
#para que um teste de ANOVA, por exemplo, tenha validade, é necessário que 
#as variâncias sejam comuns, ou seja, o modelo tem que ser homocedástico, por
#isso, verifica-se a homocedasticidade do modelo por meio de Breusch-Pagan
#outro ponto importante é que esse teste não funciona para dados em 
#distribuições não normais, por isso o teste shapiro é realizado antes

#regressão => breusch-pagan
#dados separados => levene (homogeneidade)


# Resultados:

# studentized Breusch-Pagan test
# 
# data:  mod
# BP = 1.4245, df = 1, p-value = 0.2327

# Nesse caso, o p valor também é maior do que 0,05, que é nosso nível de 
# significância, nesse caso, o modelo é homocedástico

durbinWatsonTest(mod)
#Verifica a relação entre duas variáveis, isto é se são ou não independentes
#Se o valor D-WStatistic está mais próximo de 2, os resíduos são independentes
#Outra forma de analisar é pelo p-valor, 
#se os resíduos são independentes entre si, pvalor > NS, autocorrelação = 0
#se resíduos dependentes entre si, pvalor < NS, autocorrelação != 0

# Resultados:

# lag Autocorrelation D-W Statistic p-value
# 1     -0.01039454       1.98891   0.912
# Alternative hypothesis: rho != 0

# Como p-valor é maior que 0,05, a autocorrelação é 0 e os dados são independentes


summary(mod) 
#Resumo do modelo

#hipótese nula: b1=b2=b3=...=bx=0 -> modelo não é significativa
#(uma variável não influencia na outra)
#hipótese alternativa: b1!=b2!=b3!=...!=bx!=0 -> modelo é significativo
#(uma variável influencia na outra)
#se pvalor < NS -> a minha hipótese alternativa indica que uma determinada
#variável pode influenciar a outra variável
#meu r² indica o quanto minha variável independente explica minha variável
#dependente em níveis percentuais
#r² ajustado é o ajuste do meu r² para corrigir algumas questões do modelo
#meu r² maior só é melhor se eu estou avaliando a população inteira
# 
# Call:
#   lm(formula = Vendas ~ Publicidade, data = dados)
# 
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -131.840  -42.283    2.344   40.945  142.455 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 125.17951    7.43140   16.84   <2e-16 ***
#   Publicidade   0.10495    0.01021   10.28   <2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 60.14 on 185 degrees of freedom
# Multiple R-squared:  0.3634,	Adjusted R-squared:   0.36 
# F-statistic: 105.6 on 1 and 185 DF,  p-value: < 2.2e-16


#Gráfico de dispersão com linha de tendência central
ggplot(data = dados, mapping = aes(x = Publicidade, y = Vendas))+
  geom_point()+theme_classic()+
  geom_smooth(method = 'lm', col = "red")
#Esse gráfico me mostra qual a distribuição dos dados e qual a linha
#de tendência
# Onde:
# - Dados: é o nome do meu conjunto de dados
# - Aes: define o rótulo dos meus eixos
# - Geom_point: define o meu conjunto de pontos
# - Geom_smooth: define qual será o método da minha curva de regressão
#   (nesse caso: lm (linear) e eu pintei da cor vermelha)

################################################################################
#                                                                              #
#                            Regressão múltipla                                #
#                                                                              #
################################################################################
dados2 <- read.csv("Banco de Dados 12.csv", sep=';', dec=',')
View(dados2)

mod2 <- lm(Notas ~ Tempo_Rev+Tempo_Sono, dados2 )
par(mfrow = c(2,2))
plot(mod2)

shapiro.test(mod$residuals)
#Resultados:
 
# Shapiro-Wilk normality test
# 
# data:  mod$residuals
# W = 0.99193, p-value = 0.3856

#Como o p-valor é maior que o nível de significância (0,05), a distribuição é normal

summary(rstandard(mod2))
#Resultados:
# Min.    1st Qu.     Median       Mean    3rd Qu.       Max. 
# -2.9693035 -0.7338720 -0.0079448 -0.0009045  0.6220131  2.6209702

#Como os valores máximo e mínimo estão dentro do intervalo entre -3 e 3, pode-se
#dizer que os meus dados estão dentro do intervalo de 6 desvios padrão e não há
#outliers no modelo 

bptest(mod2)
#Resultados:
# studentized Breusch-Pagan test
# 
# data:  mod2
# BP = 1.9771, df = 2, p-value = 0.3721

# Nesse caso, o p valor também é maior do que 0,05, que é nosso nível de 
# significância, nesse caso, o modelo é homocedástico


durbinWatsonTest(mod2)
#Resultados:
# lag Autocorrelation D-W Statistic p-value
# 1      0.08871924      1.811357   0.206
# Alternative hypothesis: rho != 0

# Como p-valor é maior que 0,05, a autocorrelação é 0 e os dados são independentes

summary(mod2)

#Resumo do modelo:

# Call:
#   lm(formula = Notas ~ Tempo_Rev + Tempo_Sono, data = dados2)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -4.9348 -1.2260 -0.0133  1.0402  4.3810 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 0.117173   0.614517   0.191    0.849    
# Tempo_Rev   0.099101   0.009905  10.005  < 2e-16 ***
#   Tempo_Sono  0.350658   0.087098   4.026 8.09e-05 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 1.686 on 197 degrees of freedom
# Multiple R-squared:  0.4075,	Adjusted R-squared:  0.4014 
# F-statistic: 67.73 on 2 and 197 DF,  p-value: < 2.2e-16


# Gráfico de dispersão que relaciona as três variaveis
install.packages("scatterplot3d")
library(scatterplot3d)

par(mfrow = c(1,1))

graph <- scatterplot3d(dados2$Notas ~
                       dados2$Tempo_Rev + dados2$Tempo_Sono,
                       pch = 16, angle = 30, color = "black", box = FALSE,
                       xlab="Tempo de revisão", ylab="Tempo de sono", zlab="Notas")
# Esse gráfico é uma representação visual de como as variáveis independentes: 
# tempo de sono e tempo de revisão, afetam o comportamento da variável 
# dependente notas.
