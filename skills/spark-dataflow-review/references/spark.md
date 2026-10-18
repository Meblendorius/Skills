# Checklist: Spark

## Corretude
- [ ] Escrita idempotente: `overwrite` com `partitionOverwriteMode=dynamic`, MERGE (Delta/Iceberg) ou escrita por partição de data. Nada de `append` cego em reprocessamento.
- [ ] Joins com chave correta e tipo correto (inner/left); verificar se duplicam linhas (chave não única no lado direito).
- [ ] Nulos tratados nas chaves de join e agregações.
- [ ] Sem dependência de ordem de linhas sem `orderBy` explícito.

## Estabilidade
- [ ] Sem `collect()`, `toPandas()` ou `count()` desnecessários sobre dados grandes.
- [ ] Skew: chaves muito frequentes em join ou groupBy → AQE skew join, salting ou separar a chave quente.
- [ ] UDFs Python substituídas por funções nativas (`pyspark.sql.functions`) ou pandas UDF.
- [ ] Sem loops Python que disparam um job por iteração (`for d in datas: df.filter(...).write`).

## Performance e custo
- [ ] Filtros e seleção de colunas cedo (predicate/projection pushdown); formato colunar (Parquet, Delta, Iceberg).
- [ ] Broadcast join quando um lado é pequeno (< algumas centenas de MB); conferir `spark.sql.autoBroadcastJoinThreshold`.
- [ ] AQE ligado (`spark.sql.adaptive.enabled`), padrão no Spark 3.2+.
- [ ] `repartition` só quando necessário; `coalesce` para reduzir arquivos na escrita; evitar milhares de arquivos pequenos.
- [ ] `cache`/`persist` apenas em DataFrames reutilizados mais de uma vez, com `unpersist` depois.
- [ ] Particionamento de saída por coluna de baixa cardinalidade (data), não por id.

## Legibilidade
- [ ] Transformações quebradas em funções nomeadas `def transform_x(df) -> DataFrame` e testáveis.
- [ ] Schema explícito na leitura (`StructType`) em vez de inferência, para dados de produção.
- [ ] Configurações de sessão centralizadas, não espalhadas pelo código.
