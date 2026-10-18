---
name: decision-rationale
description: Explica POR QUE o código foi escrito de determinado jeito, quais alternativas existiam e os trade-offs de cada uma, em formato de ADR enxuto. Use quando o usuário perguntar "por que assim?", "esse era o melhor caminho?", "qual a alternativa?", quiser avaliar uma escolha feita pela IA (Kiro) ou documentar decisões técnicas de pipelines, DAGs, jobs Spark/Dataflow ou automações Python/Go.
metadata:
  author: thiago-lemos
  version: "1.0"
  language: pt-BR
---

# Decision Rationale: o porquê de cada escolha

O código mostra **o quê**. Esta skill reconstrói o **porquê** e avalia, com honestidade, se foi a melhor escolha. Código gerado por IA costuma funcionar mas nem sempre é a opção certa para o contexto. Diga isso quando for o caso.

## Passo 1: Identificar as decisões
Leia o trecho e liste as **decisões não óbvias**, ou seja, pontos onde havia mais de um caminho razoável. Exemplos comuns no stack do usuário:
- biblioteca ou abordagem: pandas vs PySpark vs SQL no BigQuery; Beam Python vs Go;
- orquestração: PythonOperator vs operador nativo vs KubernetesPodOperator; TaskFlow vs operadores clássicos; dynamic task mapping vs loop gerando tasks;
- modo de escrita: append vs overwrite de partição vs MERGE;
- tratamento de erro: retry no código vs retry do Airflow; falhar rápido vs seguir com o parcial;
- estrutura: classe vs funções; herança vs composição; config em YAML vs constantes;
- performance: broadcast join, repartition/coalesce, cache, batch size, concorrência (goroutines, ThreadPool).

Ignore escolhas triviais (nome de variável, ordem de imports).

## Passo 2: Para cada decisão, montar o mini-ADR

```
### Decisão: <título curto> (arquivo:linha)
**Contexto:** que problema o trecho resolve e que restrições aparecem (volume, SLA, custo, time).
**O que foi feito:** a escolha atual, em 1–2 frases.
**Alternativas consideradas:**
| Opção | Prós | Contras | Quando seria melhor |
|---|---|---|---|
| Atual: … | … | … | … |
| B: … | … | … | … |
| C: … | … | … | … |
**Veredito:** ✅ boa escolha | ⚠️ aceitável com ressalvas | ❌ trocaria
**Por quê:** justificativa ligada ao contexto (não a "boas práticas" genéricas).
**Se for trocar:** o que mudar e qual o impacto (testes, backfill, custo).
```

## Passo 3: Critérios para julgar (nesta ordem de peso)
1. **Corretude e idempotência:** reexecutar ou reprocessar é seguro?
2. **Operabilidade:** dá para entender a falha pelos logs? dá para fazer backfill?
3. **Simplicidade:** a solução mais simples que atende? (evite abstração "porque sim")
4. **Custo e performance** no volume real: pergunte o volume se não souber.
5. **Consistência com o resto do repositório:** seguir o padrão existente tem valor próprio.

## Regras
- **Não invente intenção.** Se não houver evidência (comentário, commit, doc), diga "intenção provável".
- **Seja concreto:** "broadcast evita o shuffle da tabela de 2 TB", não "melhora performance".
- **Admita empate:** se duas opções são equivalentes no contexto, diga isso.
- **Peça contexto** quando o veredito depender dele (volume, frequência, SLA, quem mantém).

## Saída opcional
Se o usuário pedir para registrar, gere `docs/decisions/NNNN-<titulo>.md` com o mini-ADR, ou um comentário `# DECISÃO:` curto no código, apontando para o ADR.
