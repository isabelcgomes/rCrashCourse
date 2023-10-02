if(!require(pacman)) install.packages("pacman")
library(pacman)

pacman :: p_load(dplyr, psych, car, MASS, DescTools, QUantPsyc, ggplot2)

dados <- read.csv2('./dados/banco de dados.csv', 
                   fileEncoding = 'latin1', sep=',')
colnames(dados) <- c('Estresse', 'Fuma', 'Cancer','drop1', 'drop2')
dados <- subset(dados, select = c('Estresse','Fuma', 'Cancer') )

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
# Verifica a relação linear de cada VI com cada logito da VD (logito é o log da VD)
#Manual do R

intlog <- dados$Estresse * log(dados$Estresse)

dados$intlog <- intlog

modint <- glm(Cancer ~ Fuma + Estresse + intlog,
              family = binomial(link = 'logit'),
              data = dados)