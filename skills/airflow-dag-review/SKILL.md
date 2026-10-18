---
name: airflow-dag-review
description: Analisa e explica DAGs do Apache Airflow (Airflow 2.x e 3.x) quanto a estrutura, dependências, idempotência, retries, backfill, desempenho do scheduler e boas práticas. Use quando o usuário pedir para entender, revisar, depurar ou melhorar uma DAG, operador, sensor, TaskFlow, dynamic task mapping ou código que gera DAGs automaticamente.
metadata:
  author: thiago-lemos
  version: "1.0"
  language: pt-BR
---

# Airflow DAG Review

## Passo 1: Entender antes de julgar
1. Identifique a versão do Airflow (requirements, Dockerfile, imports `airflow.sdk` (3.x) vs `airflow.decorators` (2.x)).
2. Descubra se a DAG é **escrita à mão** ou **gerada** (factory, YAML → DAG, loop). Se for gerada, analise a fábrica e um exemplo de configuração.
3. Produza o **resumo da DAG**:
   - `dag_id`, schedule, `start_date`, `catchup`, `max_active_runs`, tags, owner;
   - um diagrama Mermaid das tasks com as dependências reais;
   - para cada task: operador, o que faz, o que lê e o que escreve.

## Passo 2: Revisar com o checklist
Carregue `references/checklist.md` e avalie cada item. Reporte **apenas** os itens com problema ou dúvida, no formato:

| Severidade | Task / linha | Item | Problema | Correção sugerida |
|---|---|---|---|---|

Severidade: **Alta** (perda ou duplicação de dados, DAG quebra o scheduler), **Média** (falha difícil de operar ou recuperar), **Baixa** (estilo, legibilidade).

## Passo 3: Explicar o "porquê" Airflow
Para cada problema, explique o mecanismo do Airflow por trás em 1–2 frases. Exemplo: "o arquivo da DAG é parseado a cada ~30 s pelo scheduler, então uma chamada de API no topo do arquivo roda centenas de vezes por hora".

## Passo 4: Sugerir código
Mostre o trecho corrigido lado a lado (antes/depois), mantendo o estilo do repositório (TaskFlow ou operadores clássicos, como já estiver).

## Regras
- Não sugira migrar de padrão (por exemplo, clássico → TaskFlow) a não ser que resolva um problema concreto.
- Respeite as convenções da fábrica de DAGs do usuário: se o problema estiver na fábrica, a correção é na fábrica, não na DAG gerada.
- Se depender de configuração do ambiente (pools, executor, Composer/MWAA), diga isso e pergunte.
