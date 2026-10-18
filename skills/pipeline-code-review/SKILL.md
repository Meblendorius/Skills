---
name: pipeline-code-review
description: Revisão de engenharia de software para código Python e Go que automatiza pipelines de dados (bibliotecas internas, frameworks de ingestão, geradores de DAG, CLIs, integrações com GCP/BigQuery/GCS). Use quando o usuário pedir code review, refatoração, avaliação de arquitetura, testabilidade, tratamento de erros, logging, configuração, contratos de dados ou qualidade de código gerado por IA nesse contexto.
metadata:
  author: thiago-lemos
  version: "1.0"
  language: pt-BR
---

# Pipeline Code Review: engenharia de software para automação de dados

Contexto: o usuário mantém um código Python que automatiza a criação e gestão de pipelines, além de serviços em Go/Python. O foco é **manutenibilidade e operação**, não beleza acadêmica.

## Passo 1: Mapa de arquitetura (curto)
- Camadas encontradas: entrada (CLI/API/DAG) → orquestração → regras de negócio → acesso a sistemas externos (GCS, BigQuery, APIs).
- Um Mermaid `flowchart TD` com módulos e dependências. Destaque dependências circulares ou camadas "pulando" outras.
- De onde vem a configuração (YAML, env, Airflow Variables, Secret Manager).

## Passo 2: Revisar em 7 dimensões
Para cada dimensão, dê uma nota 🟢 ok / 🟡 atenção / 🔴 problema e os achados com `arquivo:linha`.

1. **Separação de responsabilidades:** funções fazem uma coisa? I/O separado da lógica pura (para testar sem GCP)? A DAG só orquestra?
2. **Configuração vs código:** nada de nomes de bucket, projeto, dataset ou segredo fixo no código; config validada na entrada (pydantic/dataclass em Python, struct + validação em Go).
3. **Erros e resiliência:** exceções específicas e não `except Exception: pass`; em Go, todo `err` tratado ou propagado com contexto (`fmt.Errorf("...: %w", err)`); retries com backoff só onde faz sentido e sem duplicar o retry do Airflow.
4. **Observabilidade:** logs estruturados com contexto (pipeline, run_id, partição, contagens); sem `print`; métricas de linhas lidas/escritas.
5. **Dados e contratos:** schema esperado explícito; validação antes de escrever no destino; tratamento de PII; idempotência na escrita.
6. **Testabilidade:** existem testes? dá para testar a lógica sem rede (injeção de dependência simples, fakes)? fixtures pequenas de dados?
7. **Simplicidade:** abstrações justificadas? Código de IA costuma criar classes, factories e camadas "para o futuro". Aponte o que pode virar uma função. Aponte também duplicação real.

## Passo 3: Priorizar
Feche com uma lista **Top 5** ordenada por impacto/esforço:

| # | Mudança | Impacto | Esforço | Risco de mudar |
|---|---|---|---|---|

## Passo 4: Exemplos de correção
Para os itens 🔴, mostre antes/depois com código no estilo do repositório (type hints em Python, idiomático em Go).

## Regras
- **Princípios com moderação:** SOLID, DRY e afins são meios, não fins. Não sugira padrão de projeto sem um problema concreto que ele resolva.
- **Consistência acima de preferência:** se o repositório tem um padrão, siga-o e só aponte quando ele causa problema.
- **Não reescreva tudo:** sugira mudanças incrementais e seguras, com testes antes de refatorar.
- Em Python, considere `ruff`, `mypy`/`pyright` e `pytest`; em Go, `go vet`, `staticcheck`/`golangci-lint` e testes table-driven.
