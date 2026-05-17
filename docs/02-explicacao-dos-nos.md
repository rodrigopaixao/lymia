# Explicacao dos Nos do Node-RED

Este documento explica cada no do fluxo `Lyvia Chatbot`.

## 1. `LyviaBot`

Tipo: `telegram bot`

Configuracao do bot do Telegram. Ele guarda informacoes como token, modo de atualizacao e polling.

Ponto importante:

- O token real nao deve ir para o Git.
- Ele deve ser configurado no editor do Node-RED.

## 2. `sqlite-db-config`

Tipo: `sqlitedb`

Configura o banco SQLite usado pelo fluxo.

String/caminho de conexao dentro do container:

```text
/data/escola.db
```

No computador local, esse arquivo fica em:

```text
nodered-data/escola.db
```

## 3. `Receber Telegram`

Tipo: `telegram receiver`

Recebe mensagens enviadas pelo aluno no Telegram.

Saida:

- Envia a mensagem para `Preparar entrada Watson`.
- Tambem envia para `DEBUG entrada Telegram`.

## 4. `Preparar entrada Watson`

Tipo: `function`

Transforma a mensagem recebida pelo Telegram no formato esperado pelo node `IBM Watson Assistant V2`.

Principais responsabilidades:

- Descobrir o `chatId` do Telegram.
- Extrair o texto digitado pelo aluno.
- Guardar o texto original em `msg.originalText`.
- Criar `msg.params.session_id` usando o `chatId`.
- Enviar contexto adicional ao Watson.

Por que `session_id` usa o `chatId`?

Porque cada conversa do Telegram precisa manter sua propria sessao no Watson. Assim, dois alunos diferentes nao misturam contexto.

## 5. `IBM Watson Assistant V2`

Tipo: `watson-assistant-v2`

Node oficial instalado pelo pacote `node-red-node-watson`.

Responsabilidade:

- Enviar a mensagem ao Watson Assistant.
- Receber a resposta do Watson.
- Manter a sessao de conversa.

Configuracoes necessarias:

- API Key.
- Service Endpoint.
- Assistant ID ou Draft Environment ID.

## 6. `Interpretar acao do Watson`

Tipo: `function`

Este e o principal no de integracao entre Watson e banco.

Ele le a resposta do Watson e decide se:

- Deve apenas responder ao Telegram.
- Deve consultar o SQLite.
- Deve pedir RM/CPF.
- Deve mostrar opcoes de fallback.

Importante: o Watson e o cerebro da conversa. O Node-RED nao tenta substituir o Watson; ele apenas interpreta as variaveis que o Watson devolve.

Variaveis esperadas do Watson:

```text
acao_consulta
acao_pendente
cpf
rm
```

## 7. `Consultar SQLite`

Tipo: `sqlite`

Executa a query SQL montada pelo no `Interpretar acao do Watson`.

Ele usa:

```text
msg.topic
```

como comando SQL.

## 8. `Formatar resposta academica`

Tipo: `function`

Recebe as linhas retornadas pelo SQLite e transforma em texto amigavel para o aluno.

Exemplos de respostas:

```text
O RM de Manuela de Lima Ramos e RM572956.
```

```text
Aqui estao as notas que encontrei:
- Banco de Dados: CP1 7, CP2 7.5, GS1 8, CH1 8.5, media 7.75
```

Tambem salva o aluno no contexto do Node-RED quando uma consulta identifica o aluno.

## 9. `Responder Telegram`

Tipo: `telegram sender`

Envia a resposta final ao aluno pelo Telegram.

## 10. Nos Debug

Os nos debug foram adicionados para estudar e demonstrar o fluxo.

| Debug | O que mostra |
| --- | --- |
| `DEBUG entrada Telegram` | Mensagem original recebida do Telegram. |
| `DEBUG entrada Watson` | Payload enviado ao Watson. |
| `DEBUG retorno Watson bruto` | Resposta completa do Watson. |
| `DEBUG acao Watson -> SQLite` | Mensagem que vai gerar consulta SQL. |
| `DEBUG resposta direta Watson` | Resposta que nao passa pelo banco. |
| `DEBUG retorno SQLite bruto` | Resultado cru da query. |
| `DEBUG resposta academica formatada` | Texto final formatado. |
| `DEBUG saida Telegram` | Payload enviado ao Telegram. |
