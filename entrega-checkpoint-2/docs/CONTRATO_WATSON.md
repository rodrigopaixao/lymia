# Contrato Watson Assistant -> Node-RED

O Watson decide a conversa. Quando for necessário consultar o banco, ele deve preencher variáveis em `user_defined`.

## Variáveis

| Variável | Exemplo | Descrição |
| --- | --- | --- |
| `acao_consulta` | `notas` | Ação imediata para o Node-RED executar. |
| `acao_pendente` | `faltas` | Ação que aguarda CPF/RM quando o aluno ainda não está identificado. |
| `cpf` | `52998224725` | CPF do aluno. |
| `rm` | `RM1001` ou `1001` | RM do aluno. |

## Ações aceitas

- `identificar_aluno`
- `perfil`
- `rm`
- `curso`
- `notas`
- `materias`
- `faltas`
- `turnos`

## Contexto mantido

Depois que o aluno é identificado, o Node-RED mantém o aluno em contexto por conversa do Telegram. Assim, perguntas como `minhas notas` ou `minhas faltas` não precisam repetir CPF/RM.

## Fallback

Se a intenção não for reconhecida, o Node-RED retorna uma mensagem amigável com opções:

- Ver meu RM
- Consultar minhas notas
- Ver matérias inscritas
- Consultar faltas/presença
- Ver meu curso
- Ver turnos
