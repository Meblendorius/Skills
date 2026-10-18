# Checklist de revisão de DAG

## Parsing e scheduler
- [ ] Nada pesado no topo do arquivo: sem chamadas de API/DB, `Variable.get()` fora de template, leitura de arquivos grandes ou imports pesados (pandas, spark) fora das tasks.
- [ ] `start_date` fixo (nunca `datetime.now()`), e `catchup` explícito.
- [ ] `dag_id` único e estável (mudar o id perde o histórico).
- [ ] DAGs geradas: o número de DAGs/tasks é razoável e o tempo de parse está aceitável.

## Idempotência e dados
- [ ] Cada task pode ser reexecutada sem duplicar dados (overwrite de partição, MERGE, `WRITE_TRUNCATE` na partição da data lógica).
- [ ] Usa a data lógica (`{{ ds }}`, `data_interval_start/end`) e não "agora": o backfill precisa funcionar.
- [ ] Tasks atômicas: falhar no meio não deixa estado parcial visível.
- [ ] XCom só para metadados pequenos (caminhos, contagens), nunca DataFrames ou listas grandes.

## Resiliência
- [ ] `retries` e `retry_delay` definidos (em `default_args` ou na task); `retry_exponential_backoff` quando chama APIs.
- [ ] `execution_timeout` nas tasks que podem travar.
- [ ] Sensores em `mode="reschedule"` ou deferrable, com `timeout`, para não prender slots de worker.
- [ ] Sem retry duplicado (retry no código e no Airflow ao mesmo tempo) sem motivo.
- [ ] Callbacks e alertas de falha/SLA configurados conforme o padrão do time.

## Estrutura e legibilidade
- [ ] Dependências claras (`>>`, `chain`, TaskGroups) e sem dependências implícitas por ordem de código.
- [ ] `task_id` descritivos; `doc_md` na DAG explicando propósito, dono, origem e destino.
- [ ] Lógica de negócio fora do arquivo da DAG (módulo importável e testável); a DAG só orquestra.
- [ ] Dynamic task mapping (`.expand`) em vez de loops gerando N tasks, quando o N vem de runtime.
- [ ] Connections e Variables por id, sem segredos no código.

## Recursos
- [ ] `pool` / `max_active_tasks` quando acessa sistemas com limite de concorrência.
- [ ] Operadores nativos (BigQuery, Dataflow, Dataproc, GCS) preferidos a `PythonOperator` com SDK manual, quando atendem.
- [ ] Para jobs pesados, o trabalho roda fora do worker (Dataflow, Dataproc, KubernetesPod) e não dentro dele.

## Testes
- [ ] Existe teste de import/integridade das DAGs (DagBag sem erros, sem ciclos).
- [ ] Funções de negócio têm testes unitários independentes do Airflow.
