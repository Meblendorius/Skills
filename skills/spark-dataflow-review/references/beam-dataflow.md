# Checklist: Apache Beam / Google Dataflow (Python e Go)

## Conceitos para explicar ao usuário
- **PCollection:** coleção distribuída e imutável; **PTransform:** etapa; **DoFn:** função por elemento.
- **Fusion:** o Dataflow junta etapas consecutivas num mesmo estágio. Isso é bom para performance, mas um `ParDo` que expande muito (fan-out) pode limitar o paralelismo. Um `Reshuffle` quebra a fusão.
- **Windowing / watermark / trigger** (streaming): a janela define como agrupar no tempo; o watermark é a estimativa de "até quando os dados já chegaram"; o trigger define quando emitir o resultado; o allowed lateness define o que fazer com dados atrasados.

## Corretude
- [ ] DoFns determinísticos e sem estado global mutável; o Dataflow pode reprocessar bundles (retries).
- [ ] Efeitos colaterais externos (API, DB) idempotentes, porque podem rodar mais de uma vez.
- [ ] Streaming: janela, trigger, `allowed_lateness` e accumulation mode coerentes com o requisito. Dados atrasados descartados sem querer é um erro comum.
- [ ] Timestamps de evento atribuídos corretamente (`TimestampedValue` / `WithTimestamps`) e não o tempo de processamento por acidente.
- [ ] Escrita no BigQuery: método (`STORAGE_WRITE_API`, `FILE_LOADS`, streaming inserts) adequado; dedup / exactly-once quando necessário.

## Estabilidade e performance
- [ ] `CombinePerKey` / `CombineGlobally` em vez de `GroupByKey` + soma manual (o combine faz combinação parcial antes do shuffle).
- [ ] Hot keys: chaves muito frequentes → `with_hot_key_fanout` (Python) ou distribuição manual.
- [ ] Recursos caros (clientes, conexões, modelos) criados em `setup()` (Python) / `Setup` (Go) e não em `process()`.
- [ ] Side inputs pequenos; side input grande deve virar join (`CoGroupByKey`).
- [ ] Batching de chamadas externas (`GroupIntoBatches`, `BatchElements`).
- [ ] Opções do Dataflow revisadas: tipo de máquina, autoscaling (`max_num_workers`), Dataflow Prime/Runner v2, região próxima dos dados.

## Go SDK: atenção especial
- [ ] Funções e tipos de DoFn registrados (`register.FunctionXxY`, `register.DoFnXxY`, `register.Emitter`), senão o job falha no worker.
- [ ] `beam.Init()` chamado no início do `main`.
- [ ] Erros retornados pelo DoFn (assinatura com `error`) e não engolidos com `log` apenas.
- [ ] Transforms disponíveis no Go são menos numerosas que no Python; IOs cross-language exigem expansion service.

## Legibilidade
- [ ] Composite transforms nomeadas (`class ParseEvents(beam.PTransform)` / funções `func ParseEvents(s beam.Scope, ...)`) agrupando etapas relacionadas.
- [ ] Rótulos únicos e descritivos em cada `|` / `beam.ParDo(s.Scope("..."), ...)`; eles aparecem no job graph do Dataflow.
- [ ] Testes com `TestPipeline` + `assert_that` (Python) ou `ptest` / `passert` (Go).
