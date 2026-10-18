---
name: spark-dataflow-review
description: Explica e revisa jobs de processamento distribuído em Apache Spark (PySpark, Spark SQL) e Apache Beam/Google Dataflow (SDK Python e Go). Use quando o usuário quiser entender o plano de execução, as transformações, ou revisar performance, custo, particionamento, shuffles, skew, joins, windowing, watermarks, triggers e corretude de um pipeline batch ou streaming.
metadata:
  author: thiago-lemos
  version: "1.0"
  language: pt-BR
---

# Spark & Dataflow Review

## Passo 1: Identificar o motor e o modo
- **Spark** (PySpark, Scala, SQL) ou **Beam** (Python ou Go SDK, rodando no Dataflow)?
- **Batch** ou **streaming**?
- Onde roda (Dataproc, Databricks, Dataflow, local) e com que volume aproximado? Se não souber, pergunte; o volume muda o veredito.

Depois carregue a referência certa:
- Spark → `references/spark.md`
- Beam/Dataflow → `references/beam-dataflow.md`

## Passo 2: Explicar o pipeline como um grafo
1. Liste as etapas na ordem lógica: leitura → transformações → escrita.
2. Desenhe um Mermaid `flowchart LR` e marque **onde há shuffle** (Spark: `groupBy`, `join`, `distinct`, `repartition`, `orderBy`; Beam: `GroupByKey`, `CoGroupByKey`, `Combine.perKey`) com o rótulo `🔀 shuffle`.
3. Para cada etapa, diga em linguagem simples o que acontece com as linhas: filtra, expande, agrega, junta.
4. Explique o que é **lazy** (Spark: só executa na action; Beam: o grafo é construído e só roda em `run()`).

## Passo 3: Revisar
Avalie com o checklist da referência carregada. Reporte no formato:

| Severidade | Onde | Problema | Impacto (tempo, custo, corretude) | Sugestão |
|---|---|---|---|---|

Priorize nesta ordem: **corretude** (duplicidade, dados perdidos por watermark, não determinismo) > **estabilidade** (OOM, skew) > **custo e tempo**.

## Passo 4: Explicar o mecanismo
Para cada achado, explique o **porquê** em termos de execução distribuída. Exemplo: "o `collect()` traz todas as linhas para o driver, que tem pouca memória; com 50 M de linhas isso causa OOM".

## Regras
- Não recomende `cache()`, `repartition()` ou broadcast sem justificar com o padrão de reuso ou o tamanho dos dados.
- Prefira funções nativas a UDFs Python; quando a UDF for necessária, sugira pandas UDF.
- No Go SDK, considere as limitações próprias (registro de funções e tipos com `register`, menos transforms prontos do que o Python) antes de sugerir algo que só existe no Python SDK.
- Se a análise precisa do plano real, peça ao usuário `df.explain("formatted")` (Spark) ou o job graph / métricas de etapa do Dataflow.
