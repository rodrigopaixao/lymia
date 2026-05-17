# Validacoes e Tratamento de Erros

Este documento lista as principais validacoes e como o bot responde a erros.

## Validacoes no Node-RED

### Chat sem `chatId`

Se uma mensagem chega sem `chatId`, o fluxo registra aviso:

```text
Mensagem sem chatId recebida do Telegram.
```

E nao continua, porque nao saberia para quem responder.

### Watson sem `chatId`

Se o Watson retorna sem identificador de conversa, o fluxo registra:

```text
Watson retornou sem chatId de Telegram.
```

### RM flexivel

Aceitos:

```text
RM572956
572956
```

Nao aceitos:

```text
RM
10
123
```

Mensagem:

```text
Para consultar pelo RM, preciso do numero completo com 6 digitos. Exemplo: RM572956 ou apenas 572956.
```

### Fallback de entendimento

Quando nem o Watson nem o texto indicam uma acao reconhecida, o bot oferece opcoes.

Sem aluno identificado:

```text
Eu ainda nao entendi direitinho, mas posso te ajudar com estas opcoes:

- Ver meu RM
- Consultar minhas notas
- Ver materias inscritas
- Consultar faltas/presenca
- Ver meu curso
- Ver turnos

Se for sua primeira consulta, me envie tambem seu RM ou CPF.
```

Com aluno identificado:

```text
Eu ainda nao entendi direitinho, Manuela de Lima Ramos, mas posso te ajudar com estas opcoes:

- Ver meu RM
- Consultar minhas notas
- Ver materias inscritas
- Consultar faltas/presenca
- Ver meu curso
- Ver turnos

Pode responder com uma delas, por exemplo: "minhas notas" ou "faltas".
```

## Validacoes no banco

### Chaves estrangeiras

O script usa:

```sql
PRAGMA foreign_keys = ON;
```

Isso ativa validacao de relacionamento no SQLite.

### CPF

```sql
CHECK (length(cpf) = 11 AND cpf NOT GLOB '*[^0-9]*')
```

Garante CPF com 11 digitos numericos.

### Notas

```sql
CHECK (cp_1 BETWEEN 0 AND 10)
```

Todas as notas possuem restricao entre 0 e 10.

### Turno

```sql
CHECK (turno IN ('manha', 'tarde', 'noite', 'integral'))
```

Evita valores inconsistentes.

## Pontos de atencao

### Erro de credencial do Watson

Se aparecer no log:

```text
Missing Watson Assistant service credentials
```

Significa que o node `IBM Watson Assistant V2` nao recebeu API Key, URL ou Assistant ID.

### Erro de polling no Telegram

Se aparecer:

```text
409 Conflict: terminated by other getUpdates request
```

Significa que o mesmo token do bot esta sendo usado por outra instancia em polling.

### Dados nao encontrados

Se nao encontrar aluno:

```text
Nao encontrei nenhum aluno com RM572956. Pode conferir se o CPF ou RM esta certinho e me mandar novamente?
```

## Limite conhecido

Faltas sao calculadas com base em:

```text
total_horas - presencas_registradas
```

Em um sistema real, o ideal seria ter uma tabela propria de aulas ou frequencia por aula.
