# Kit de análise de código para engenharia de dados (Kiro)

Esta pasta (`~/.agents`) é a **fonte**. O Kiro lê de `~/.kiro/` (global) ou `.kiro/` (projeto), então rode o `sync-to-kiro.ps1` uma vez para ligar as duas.

## O que tem aqui

```
.agents/
├── skills/                                ← sob demanda (/nome ou pelo assunto do pedido)
│   ├── code-walkthrough/                  roteiro de 6 etapas: mapa → fluxo → funções → trechos difíceis → riscos → glossário
│   │   └── references/template-code-tour.md
│   ├── decision-rationale/                "por que assim?": alternativas, trade-offs, veredito (mini-ADR)
│   ├── airflow-dag-review/                resumo da DAG + checklist (idempotência, parsing, retries, sensores…)
│   │   └── references/checklist.md
│   ├── spark-dataflow-review/             grafo com shuffles + checklists de Spark e Beam/Dataflow (Python e Go)
│   │   └── references/{spark.md, beam-dataflow.md}
│   └── pipeline-code-review/              engenharia de software em 7 dimensões + Top 5 priorizado
├── steering/
│   └── code-documentation-standards.md    carrega sozinho em .py/.go: padrão de cabeçalho, docstring e tags DECISÃO/ATENÇÃO/IDEMPOTÊNCIA
├── agents/
│   └── code-explainer.md                  agente "professor" que usa todas as skills
└── sync-to-kiro.ps1                       liga tudo ao ~/.kiro
```

## Instalação (Windows)
```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\.agents\sync-to-kiro.ps1"
```
Reinicie o Kiro. Para levar ao repositório do time, copie as mesmas pastas para `<repo>/.kiro/`.

### Instalando a partir deste repositório
Sem o script, basta copiar as pastas para o Kiro:
```bash
git clone https://github.com/<usuario>/kiro-data-engineering-skills.git
mkdir -p ~/.kiro
cp -r kiro-data-engineering-skills/{skills,steering,agents} ~/.kiro/     # global
# ou: cp -r kiro-data-engineering-skills/{skills,steering,agents} <seu-projeto>/.kiro/
```

## Como usar no dia a dia
| Situação | O que digitar no Kiro |
|---|---|
| Não entendi o que a IA escreveu | `/code-walkthrough` + abra ou cite o arquivo (`#arquivo.py`) |
| Quero saber se a escolha foi boa | `/decision-rationale` no trecho |
| Revisar uma DAG | `/airflow-dag-review` |
| Job lento ou caro | `/spark-dataflow-review` |
| Code review do framework de automação | `/pipeline-code-review` |
| Sessão de estudo completa | selecione o agente **code-explainer** |

O steering funciona sozinho: sempre que o Kiro mexer em `.py`/`.go`, ele segue o padrão de comentários e termina com o roadmap da mudança.

## Observações
- O `name` de cada skill precisa ser igual ao nome da pasta (regra do Kiro).
- A `description` é o que faz a skill disparar automaticamente; ajuste as palavras ao seu vocabulário se ela não disparar.
- Se o agente não enxergar as skills globais, confira o caminho em `resources` (`skill://...`) na documentação de custom agents da sua versão do Kiro.
# Skills
