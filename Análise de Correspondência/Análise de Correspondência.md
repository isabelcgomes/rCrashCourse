# Análise de Correspondência

É uma técnica exploratória de análise que tema intenção de trabalhar com variáveis que apresentam dados categóricos e se deseja investigar possíveis associações.

*Exemplo:*
Coportamento do consumo descrito pela preferência por determinados tipos de estabelecimentos:
- Faixa de idade dos consumidores
- País de origem
- Setor de atuação
- Faixa de lucratividade de uma empresa de capital aberto

As técnicas de análise de correspondência são métodos de representação de linhas e colunas de tabelas cruzadas de dados como coordenadas de um gráfico, chamados de mapa perceptual, a partir da qual podem ser observados ou interpretados similaridades e diferenças de comportamento entre variáveis e entre categorias.

Essa técnica investiga a significância da similaridade construindo mapas de percepção, que nada mais são do que mapas de dispersão.
*Como curiosidade:* A técnica foi descoberta em 1984 por um matemático chamado Bemzecri na *Teoria de análise de correspondência*

Análise de correspondência estuda a associação de duas ou mais variáveis categóricas bem como a intensidade de associação a partir de uma tabela cruzada de dados, conhecida na matemática como tabela de contingência. Na qual são dispostas as frequências absolutas utilizadas.

Imaginem que um banco de dados seja composto por duas variáveis categóricas. Em que o primeiro possui i categorias e a segunda possua j categorias.

Logo, a partir desse banco de dados, é possível definir uma matriz X0, por sua vez chamada de matriz de contingência (cross tabulation) onde são dispostas todas as frequências absulutas de dados.

O objetivo principal dessa matriz é estudar a existência de associação estatisticamente significante partindo do teste Chi<sup>2</sup>. 


Tal que, ao simularmos no R ou no Python, Chi<sup>2</sup> nos dará a somatória da razão entre os resíduos ao quadrado e a frequência esperada de cada célula

A partir de um teste de hipóteses podemos inferir que a associação é estatísticamente significante ou não

H0 a associação não é estatísticamente significante.
H1 a associação é estatísticamente significante (a associação não se dá de forma aleatória)

A medida que o Chi<sup>2</sup> aumenta e a medida de N aumenta, pode-se prejudicar a associação que possa existir na tabela cross section.

Na matemática, tal problema pode ser superado quando se faz o uso da inércia principal total de uma tabela de contingência. (Inércia = Chi<sup>2</sup>/N).

O tipo mais comum de decomposição inercial principal são a determinação dos autovalores (vetores). 

A Análise de correspondência simples Permite investigar a associação entre somente duas variáveis categóricas. 

Já a análise de correspondência múltipla permite identificar a relação entre mais de duas variáveis categóricas (Jean Paul Resengre).

A Análise de correspondência simples é chamada de __Anacorr__

A análise de correspondência múltipla é chamada de __MCA__


A diferença entre agrupamentos e correspondência é que nos agrupamentos eu usava dados métricos, na correspondência eu uso dados categóricos, apenas avalio a similaridade entre as variáveis

---------------------------------------------------------------

Atividade: Descobrir o perfil de investimento com base em onde esse cara tá aplicando o dinheiro.