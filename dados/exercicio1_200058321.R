#200058321
#Isabel Caroline Gomes Giannecchini
install.packages('readxl')
install.packages('pacman')
install.packages('psych')
library(readxl)
library(pacman)
library(psych)

pacman :: p_load(dplyr, psych, car, MASS, DescTools, QuantPsych, ggplot2)

dados <- read_excel('Atrasado.xls')
dados <- mutate(dados, across(where(is.character), as.factor))

colnames(dados) <- c('Estudante', 'Atrasado', 'Distancia','Semaforos', 'Periodo_Dummy', 'Perfil_Volante_Dummy2', 'Perfil_Volante_Dummy3' )

glimpse(dados)

table(dados$Atrasado)
summary(dados)

mod<-glm(Atrasado ~ Distancia + Semaforos + Periodo_Dummy + Perfil_Volante_Dummy2 + Perfil_Volante_Dummy3, 
         family = binomial(link = 'logit'), data = dados)

par(mar = rep(2, 4))
par(mfrow=c(4,1))
plot(mod)
vif(mod)
#Por todos os VIF serem menor do que 10, não há relação de multicolinearidade entre as variáveis

plot(dados$Atrasado, dados$Distancia)
pairs.panels(dados[2:7])

intlog <- dados$Distancia * log(dados$Distancia) 
#Eu gero uma variável de interação para avaliar se existe uma ralação entre as variáveis

#adicionar a variável intlog no banco de dados
dados$intlog <- intlog

modint <- glm(Atrasado ~ Semaforos + Distancia + Periodo_Dummy + Perfil_Volante_Dummy2 + Perfil_Volante_Dummy3 + intlog,
              family = binomial(link = 'logit'),
              data = dados)


summary(modint)

logito <- mod$linear.predictors
dados$logito <- logito


ggplot(dados, aes(logito, Distancia)) +
  geom_point(size=0.5, alpha=0.5) +
  geom_smooth(method = 'loess') +
  theme_classic()


Anova(mod, type = 'II', test= 'Wald')

summary(mod)

#obtenção das razões de chance com IC 95% (log-likelihood)

exp(cbind(OR = coef(mod), confint(mod)))  #OR = odd ratio (razões de chance)

exp(coef(mod))

exp(cbind(OR = coef(mod), confint.default(mod)))

#Perfil ao volante não é significativa porque seu P valor foi > que o nível de significância
mod2 <- glm(Atrasado ~ Semaforos + Distancia + Periodo_Dummy + Perfil_Volante_Dummy3,
            family = binomial(link = 'logit'),
            data = dados)
Anova(mod2, type = 'II', test= 'Wald')


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

ClassLog(MOD = mod, dados$Atrasado)
ClassLog(MOD = mod2, dados$Atrasado)

table(dados$Atrasado)
table(dados$Semaforos)
table(dados$Periodo_Dummy)
table(dados$Perfil_Volante_Dummy3)

