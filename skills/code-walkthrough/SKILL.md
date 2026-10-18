---
name: code-walkthrough
description: Roteiro padronizado para analisar e explicar código (Python, Go, DAGs Airflow, jobs Spark/Dataflow), em especial código gerado por IA. Use quando o usuário pedir para explicar, entender, mapear, documentar ou "fazer um tour" por um arquivo, módulo, função ou PR, ou disser que não entendeu o que a IA escreveu. Produz um mapa geral, fluxo de dados, explicação função a função, riscos e glossário.
metadata:
  author: thiago-lemos
  version: "1.0"
  language: pt-BR
---

# Code Walkthrough: roteiro de análise de código

Objetivo: fazer o usuário **entender** o código, do geral para o específico, sempre no mesmo formato. O usuário é engenheiro de plataforma de dados (Python, Go, Airflow, Spark, Dataflow/Beam). Explique em português, sem jargão desnecessário, e defina termos na primeira vez que aparecerem.

## Regras gerais

- **Do geral para o específico.** Nunca comece pela linha 1. Comece pelo "para que isso existe".
- **Leia antes de explicar.** Abra os arquivos citados, os imports locais e quem chama o código (procure usos). Não suponha o comportamento de uma função pelo nome.
- **Separe fato de inferência.** Use "o código faz X" para o que está escrito e "provavelmente X porque…" para o que é dedução.
- **Cite a localização** (`arquivo.py:42`) em toda afirmação relevante.
- **Escopo grande?** Se forem mais de ~5 arquivos ou mais de ~800 linhas, faça primeiro só a Etapa 1 e pergunte qual parte aprofundar.

## As 6 etapas (siga nesta ordem)

### Etapa 1: Mapa geral (o "roadmap")
- **Propósito** em 1–2 frases: que problema de negócio ou de dados isso resolve?
- **Pontos de entrada:** `main`, CLI, definição de DAG, `@task`, handler, `pipeline.Run`, `spark-submit`…
- **Peças principais:** lista dos arquivos, classes e funções com uma linha de papel cada.
- **Diagrama Mermaid** (`flowchart LR`) mostrando entrada → etapas → saída, com os nomes reais das funções.

### Etapa 2: Fluxo de dados
- **Origem:** de onde o dado vem (bucket, tabela, tópico, API), em que formato e com que volume aproximado, se der para inferir.
- **Transformações** em sequência, com o nome da função responsável por cada uma.
- **Destino:** onde o dado é escrito e em que modo (append, overwrite, merge/upsert).
- **Configuração:** o que vem de fora (variáveis, Airflow Variables/Connections, YAML, flags) e o que está fixo no código.

### Etapa 3: Função por função
Para cada função ou bloco relevante, use exatamente este formato:

```
#### `nome_da_funcao(params)` (arquivo.py:linha)
- **O que faz:** uma frase.
- **Entrada → Saída:** tipos e formato.
- **Efeitos colaterais:** I/O, escrita, chamadas de rede, estado global (ou "nenhum").
- **Como faz:** passos numerados, em linguagem simples.
- **Por que assim:** a razão provável da abordagem (para aprofundar, use a skill decision-rationale).
```
Pule getters triviais e agrupe funções auxiliares parecidas.

### Etapa 4: Trechos difíceis
Escolha os 1–3 trechos mais confusos (comprehensions aninhadas, closures, goroutines/channels, UDFs, windowing, retries manuais, regex) e explique **linha a linha**, com um exemplo concreto de entrada e saída.

### Etapa 5: Riscos e pontos de atenção
Tabela com as colunas `Severidade | Onde | Problema | Sugestão`. Procure em especial:
- falta de idempotência (rodar duas vezes duplica ou corrompe dados);
- erros engolidos (`except: pass`, `_ = err` em Go);
- segredos ou caminhos fixos no código;
- operações que não escalam (`collect()`, loops sobre DataFrame, leitura inteira em memória);
- ausência de testes ou de logs úteis.

### Etapa 6: Glossário e próximos passos
- Termos de domínio e de tecnologia usados no código, com uma linha cada.
- 2–3 sugestões do que o usuário pode ler ou testar para fixar o entendimento.

## Formato de saída

Use o modelo em `references/template-code-tour.md`. Quando o usuário pedir para salvar, grave como `CODE_TOUR.md` (ou `docs/code-tour/<modulo>.md`) ao lado do código analisado.

## Encerramento

Termine sempre com: "Qual trecho você quer que eu aprofunde, ou quer que eu explique o porquê de alguma decisão?"
