---
inclusion: fileMatch
fileMatchPattern: ["**/*.py", "**/*.go"]
---

# Padrão de documentação de código (obrigatório ao escrever ou alterar código)

Quem lê este código precisa entender **o que** cada parte faz e **por que** foi feita assim, sem depender de quem escreveu (humano ou IA). Siga estas regras sempre que criar ou modificar arquivos Python ou Go.

## 1. Cabeçalho de módulo (todo arquivo novo ou alterado de forma significativa)

Python:
```python
"""<Uma frase: o que este módulo faz.>

Contexto:
    <Onde ele se encaixa no pipeline: quem chama, o que vem antes e depois.>

Fluxo:
    1. <etapa> -> 2. <etapa> -> 3. <etapa>

Entradas: <origem dos dados ou config>
Saídas:   <destino / efeitos colaterais>
"""
```

Go (comentário de pacote, em `doc.go` ou no topo do arquivo principal):
```go
// Package <nome> <faz o quê>.
//
// Contexto: <onde se encaixa>.
// Fluxo: <etapa> -> <etapa> -> <etapa>.
package nome
```

## 2. Docstrings / comentários de função

- **Python:** estilo Google, com type hints na assinatura.
  ```python
  def load_partition(table: str, ds: str) -> int:
      """Carrega a partição `ds` na tabela de destino de forma idempotente.

      Args:
          table: Tabela no formato `projeto.dataset.tabela`.
          ds: Data lógica no formato YYYY-MM-DD.

      Returns:
          Número de linhas escritas.

      Raises:
          SchemaMismatchError: Se o schema da origem divergir do contrato.
      """
  ```
- **Go:** comentário iniciando pelo nome do identificador (godoc), para tudo que for exportado.
  ```go
  // LoadPartition carrega a partição ds na tabela de forma idempotente
  // e retorna o número de linhas escritas.
  func LoadPartition(ctx context.Context, table, ds string) (int64, error)
  ```
- Funções privadas triviais não precisam de docstring; funções privadas com lógica não óbvia precisam.

## 3. Comentários no corpo: o PORQUÊ, não o quê

- ❌ `# itera sobre os arquivos`
- ✅ `# Processa em lotes de 500 porque a API do BigQuery limita 1000 linhas por insert`

Use estas tags padronizadas (em maiúsculas, para facilitar a busca):
- `# DECISÃO: <escolha> porque <motivo>; alternativa descartada: <X> (<motivo>)`: toda escolha não óbvia de abordagem, biblioteca, modo de escrita ou estratégia de retry.
- `# ATENÇÃO: <armadilha ou efeito colateral importante>`
- `# TODO(<autor>): <o que falta>`, só com dono.
- `# IDEMPOTÊNCIA: <como a reexecução é segura>`: em toda escrita em destino de dados.

Em Go, use `//` com as mesmas tags.

## 4. Ao terminar uma alteração

No resumo da resposta ao usuário, inclua sempre:
1. **Roadmap da mudança:** lista de arquivos alterados com uma linha de "o que e por quê" cada.
2. **Decisões tomadas:** as tags `DECISÃO` adicionadas, resumidas.
3. **Como testar:** comando ou passo concreto.

## 5. O que NÃO fazer
- Não comentar o óbvio nem repetir o nome da função em prosa.
- Não deixar comentário desatualizado: ao mudar o código, atualize o comentário.
- Não deixar código comentado "para depois"; o git guarda o histórico.
