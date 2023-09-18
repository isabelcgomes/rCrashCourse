install.packages("pacman")
library(pacman)
pacman :: p_load(dplyr, ggplot2, car, rstatix, lmtest, ggpubr, ggmisc, psych)
library(readxl)

dados <- read.csv("dados/banco de dados 4.csv", sep=';', dec=',')

mod <- lm(Vendas ~ Publicidade, dados )
par(mfrow = c(2,2))
plot(mod)

shapiro.test(mod$residuals)#teste de normalidade

summary(rstandard(mod)) #isso me mostra que o ponto de máximo e de mínimo não ultrapassam -3 e +3

bptest(mod)#breusch-pagan - verifica a homocedasticidade do modelo
#regressão => breusch-pagan
#dados separados => levene (homogeneidade)

durbinWatsonTest(mod) #verifica se os resíduos são ou não independentes
#se os resíduos são independentes entre si, pvalor > NS, autocorrelação = 0
#se resíduos dependentes entre si, pvalor < NS, autocorrelação != 0

summary(mod) 
#hipótese nula: b1=b2=b3=...=bx=0 -> modelo não é significativa
#hipótese alternativa: b1!=b2!=b3!=...!=bx!=0 -> modelo é significativo
#se pvalor < NS -> a minha hipótese alternativa indica que uma determinada variável pode influenciar a outra variável
#meu r² indica o quanto minha variável independente explica minha variável dependente em níveis percentuais
#r² ajustado é o ajuste do meu r² para corrigir algumas questões do modelo
#meu r² maior só é melhor se eu estou avaliando a população inteira





ggplot(data = dados, mapping = aes(x = Publicidade, y = Vendas))+
      geom_point()+theme_classic()+
      geom_smooth(method = 'lm', col = "red")
