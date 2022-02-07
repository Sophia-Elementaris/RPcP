---
layout: chapter
author: "Guilherme Moreira"
title: "Como abordar um problema"
katex: True
---

Digamos que alguém te pergunte:

> "Qual a soma de todos os números abaixo de 10 que são multiplos de 3 ou 5?
>
> Ora, essa é fácil: $$3 + 5 + 6 + 9 = 23$$

E se o limite fosse $$100$$? Ou $$1000$$? Ou até mesmo $$10^{10}$$? Quando o limite é maior, se torna inviável somar *na mão* todas os números que satisfazem essas condições{% sidenote "condicoes" "condicoes" "Esse é o primeiro problema do [Projeto Euler](https://projecteuler.net), um site com vários desafios matemáticos que são desenvolvidos para serem resolvidos usando programação. Alguns deles, como o que vamos trabalhar nesse capítulo, são bem simples." %}.

Então, temos duas opções: procuramos um método matemático mais elegente, ou usamos computadores *(que são extremamente bons em fazer cálculos)* para nos ajudar.

Começaremos pelo segundo método. Afinal, o título do livro é *Resolvendo problemas com Python*, e não *Resolvendo problemas com matemática*.

## O algoritmo

O algoritmo que usaremos é extremamente simples. Na verdade, é exatamente o mesmo que usamos no exemplo inicial, com números menores que 10. São algumas etapas simples:

```python
def soma_div_3_5(limite: int) -> int
    numero = 1
    soma = 0
    while numero <= limite:
        if (numero % 3 == 0 or 
            numero % 5 == 0):
            soma += numero

        numero += 1

    return soma
```

Como podemos observar, as etapas do algoritmo podem ser perfeitamente mapeadas no código{% sidenote "código" "codigo" "Caso algum leitor não tenha tanta familiaridade com Python, o operador `%` representa o resto inteiro da divisão entre dois números." %}.

Se executarmos a função com o limite igual a 10, obtemos uma resposta diferente: 33. Isso se deve ao fato de que o limite está incluso no cálculo, já que repetimos até o **número** ser maior ou igual ao **limite**. Por isso, temos que executar a função com o limite igual a 9.

```python
soma_div_3_5(9) == 23
```

Bom, agora que sabemos que o algoritmo funciona, podemos testar com outros números.

```python
soma_div_3_5(99) == 2318
soma_div_3_5(999) == 233168
soma_div_3_5(10**10 - 1) == ?
```

Bom, o algoritmo funciona perfeitamente para os dois primeiros casos, mas demora muito para calcular quando o limite é $$10^{10} - 1$$.

> Como assim demora muito para calcular? Computadores não são extrememante bons em aritmética?

Sim, computadores são bons em aritmética. Mesmo assim, $$10^{10} - 1$$ é um número muito grande, e até mesmo computadores não conseguem percorrer todos os números inferiores à ele rapidamente.

Além disso, Python não é exatamente uma linguagem rápida{% sidenote "rápida" "rapida" "É devagar mesmo quando comparada com outras linguagens interpretadas, como Javascript. Isso se deve ao fato de não ter um compilador JIT, como existe para Javascript. Contudo, existem implementações alternativas do Python, como o PyPy, que possuem compilador JIT e, por isso, são muito mais performáticas que o CPython padrão. Não se preocupe se você não entendeu nada disso, é somente um complemento para leitores mais interessados e experientes." %}, então já estamos em uma pequena desvantagem. Contudo, mesmo se esse algoritmo fosse implementado em uma linguagem mais rápida, como C, C++ ou go, ele não seria capaz de executar essa função para limites aribitrariamente grandes.

> Então é isso? Não temos como saber a resposta para $$10^{10} - 1$$

Mas é claro que temos! Existem algumas alternativas viáveis para resolver esse problema:

1. Otimizar o algoritmo, mas sem mudar a estrutura fundamental do mesmo.
1. Mudar a linguagem de programação para outra mais performática.
1. Procurar outro algoritmo mais eficiente.

Deixo como exercício ao leitor as duas primeiras opções e focarei na terceira.

## Mais eficiência?

Primeiro, temos que entender o porquê do algoritmo anterior ser tão devagar. Para calcular a soma, ele percorrer todos os números até o limite e ccheca, individualmente, se eles são divisíveis por 3 ou 5.

Para limites pequenos, como 99 ou 999, isso não é um problema. Mas para limites muito grandes, como $$10^{10} - 1$$, é perceptível a demora para percorrer todos esses números{% sidenote "números" "numeros" "Para os leitores com alguma experiência com análise de complexidade de algoritmos, vale lembrar que a complexidade do operador `%` é $$O(n^2)$$" %}.

Portanto, precisamos achar outro algoritmo, alguma maneira de fazer esse cálculo sem percorrer todos os números menores que o limite.

Mas qual seria esse algoritmo?

Primeiro, temos que observar com mais atenção o problema, usando uma perspectiva mais matemática{% sidenote "matematica" "matematica" "Não se assute com isso. Programação e matemática andam juntos, e saber disso é essencial para otimizar algoritmos que você escreve" %}.

Vamos utilizar um exemplo mais simples para entender o que pode ser feito. Digamos que queiramos calcular a soma de todos os números divisíveis por 3 abaixo de 1000, ou seja:

$$
3 + 6 + 9 + 12 + \dots + 996 + 999
$$

Podemos colocar o 3 em evidência, obtendo então:

$$
3 \cdot (1 + 2 + 3 + 4 + \dots + 332 + 333)
$$

A expressão dentro dos parênteses é uma simples soma de progressão aritmética. *Johan Gauss* pode nos ajudar, então. Ele descobriu{% sidenote "descobriu" "descobriu" "Com 10 anos de idade!!" %} como calcular a soma de uma progressão nesse formato. A demonstração é relativamente simples, então deixo como exercício ao leitor.

$$
1 + 2 + 3 + \dots + (n - 1) + n = \frac{n(n+1)}{2}
$$

Então, podemos simplesmente reescrever

$$
3 \cdot (1 + 2 + 3 + 4 + \dots + 332 + 333) \\[2ex]
= 3 \cdot \frac{333(333+1)}{2} \\[2ex]
= 3 \cdot \frac{333 \cdot 334}{2}
$$

Pronto! Agora não precisamos percorrer todos os números para achar a soma de todos os que são divisíveis por 3. Podemos fazer a mesma coisa com o 5.

$$
5 + 10 + 15 + \dots + 995 \\[2ex]
= 5 \cdot (1 + 2 + 3 + \dots + 199 ) \\[2ex]
= 5 \cdot \frac{995 \cdot 996}{2}
$$

Observe que o último número agora é 995, e não 999. Isso se deve ao fato que 995 é o último número divisível por 5 menor que 1000. Então, 199 deve ser o útimo número da nossa progressão aritmética, já que $$\frac{995}{5} = 199$$.

Também podemos descobrir o último número da progressão dividindo o limite, nesse caso 999, pelo número em questão, 5, e desprezando todas as casas decimais. Essa é uma propriedade básica da divisão, então não confie cegamente em mim e tente entender isso de maneira intuitiva.

Agora basta somar os resultados obtidos acima que temos nossa resposta, certo? Errado! Existem números em comum nas duas sequências, como 15, 30, ..., e eles seriam somados duas vezes, e isso influenciaria no nosso resultado final.

Então temos que subtrair todos os números em comum. Esses números são, na verdade, todos os múltiplos do MMC de 3 e 5, que é 15.

Armados com esse conhecimento, podemos começar a escrever o código do nosso novo algoritmo.

Primeiro, definimos uma função que nos dá a soma de todos os números divisíveis por $$n$$ abaixo de um certo $$k$$.

```python
def soma_div_por(n: int, k: int) -> int:
    p = k // n
    return n * (p * (p + 1) / 2)
```

O operador `//` é usado para efetuar uma divisão e desprezar as casas decimais do resultado, então $$p$$ é o último termo da progressão aritmética. A expressão ao lado do `return` é a soma da progressão aritmética, usando a fórmula mostrada acima, multiplicada pelo número em questão. Exatamente como vimos nos exemplos anteriores.

Então, para descobrir a soma dos números divisíveis por 3 e 5, podemos definir uma nova função.

```python
def soma_div_3_5(limite: int) -> int:
    return (soma_div_por(3, limite) +
            soma_div_por(5, limite) -
            soma_div_por(15, limite))
```

Esse novo algoritmo é capaz de processar o limite $$10^{10} - 1$$ em 0.05 segundos na minha máquina, então é um sucesso!

## Estilo

O primeiro algoritmo, mesmo sendo devagar, funciona relativamente bem com limites pequenos. Contudo, ele não está escrito de maneira *pythonica*, ou seja, não utiliza as ferramentas que a linguagem nos dá. A função abaixo utiliza essas ferramentas, e funciona de maneira idêntica ao primeiro algoritmo.

```python
def soma_div_3_5(limite: int) -> int:
    return sum([x for x in range(limite + 1)
               if (x % 3 == 0 or
                   x % 5 == 0))
``` 

Não há nadad de errado em usar ou escrever a função da maneira inicial, mas conseguir entender código usando os idiomas do Python é essencial para trabalhar em conjunto com outros programadores. Afinal, Python é uma linguagem elegante, e é sempre bom escrever código elegane.
