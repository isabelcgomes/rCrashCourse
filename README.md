# Note
Codes and studies about R language based on projects on decision support

In this repository you will find:
- All the codes wrote in classroom
- Organized codes with comments
- README files with all the theory behind the codes and statistical aproaches

_Important!! The entire content of this repository is written in portuguese_

# Noções Básicas de estatística

O que é a hipótese nula?

Hipótese Nula é o nome que se dá de uma situação na qual a distribuição dos meus dados se mantém mesmo quando eu aplico uma mudança nas condições. Em termos práticos, isto é dizer que o meu teste não gera diferença na minha distribuição. É o que acontece quando um grupo controle e um grupo experimental não apresentam diferenças. 

Na teoria, isso é o que acontece quando o p-valor de um teste de diferença estatística é maior do que o nível de significância que eu preciso ter para validar a minha hipótese alternativa.

Dessa forma:

_se pv > NS eu aceito a hipótese nula_

Hipótese alternativa é o que eu quero testar.

Quando eu aceito a hipótese alternativa, eu quero dizer que o meu experimento gera uma mudança na minha população, isso é, a minha população, após a mudança das condições, não apresenta a mesma distribuição que tem minha população no grupo controle. 

Para avaliar isso, eu verifico se o p-valor dos meus testes é menor do que o meu nível de significância.

Dessa forma:

_se pv < NS eu rejeito a hipótese nula_

Exemplo:

|Hipótese Nula | Hipótese Alternativa| p-valor | Nível de significância| Resutado|
|--------------|---------------------|---------|-----------------------|---------|
|A distribuição dos meus dados é normal|A distribuição dos meus dados não é normal | 0,04|95%| Rejeito a hipótese nula|

Nesse exemplo, eu rejeito a hipótese nula porque meu p-valor é menor que meu nível de significância. O nível de significância pode variar de acordo com o tipo de experimento que eu tenho. Um exemplo é um experimento na área de medicina, nesse caso, o meu nível de significância deve ser muito maior para rejeitar uma hipótese nula.

Ainda no meu exemplo, rejeitar a hipótese nula significa dizer que a mudança que eu fiz no meu ambiente alterou a distribuição dos meus dados.

As hipóteses podem ser utilizadas para várias coisas, normalidade, homogeneidade, independência das variáveis...

# Testes estatísticos

## Teste de Levene

[Wikipédia, Teste de Levene](https://pt.wikipedia.org/wiki/Teste_de_Levene)

Estatística inferencial usada para avaliar a igualdade de variâncias de uma variável calculada para dois ou mais grupos. Isso é, a homogeneidade de um grupo de dados. O teste de Levene avalia se as variâncias das populações das quais diferentes amostras são extraídas são iguais. 

Se o valor-p resultante do teste de Levene for menor que o nível de significância adotado, é improvável que as diferenças obtidas nas variâncias amostrais tenham ocorrido com base na amostragem aleatória. Assim, a hipótese nula (variâncias iguais) é rejeitada e conclui-se que há diferença entre as variâncias na população (heterocedástica).

## Teste T

Quando eu penso em um Teste T para avaliar uma amostra com variância homogênea

# Referências

Livro Faveiro - Análise de dados (em SPSS)

Econometria Básica Gujarati