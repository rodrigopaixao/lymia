# Roteiro para Apresentacao

Use este roteiro para explicar o projeto ao professor e ao grupo.

## 1. Introducao

Este projeto e um chatbot academico que permite ao aluno consultar informacoes pelo Telegram.

Tecnologias usadas:

- Telegram BotFather.
- IBM Watson Assistant.
- Node-RED.
- SQLite.
- Docker.

## 2. Explicar a arquitetura

Diga:

> O Telegram e a interface do aluno. O Watson entende a intencao. O Node-RED orquestra o fluxo e consulta o banco SQLite. O SQLite armazena alunos, cursos, materias, presencas e notas.

Mostre o fluxo no Node-RED.

## 3. Explicar o papel do Watson

Diga:

> O Watson controla a conversa. Ele identifica se o aluno quer consultar RM, notas, materias, faltas, curso ou turnos. Quando precisa consultar o banco, ele envia uma variavel de acao para o Node-RED.

Exemplo:

```text
acao_consulta = notas
rm = RM572956
```

## 4. Explicar o papel do Node-RED

Diga:

> O Node-RED recebe a mensagem do Telegram, envia para o Watson, interpreta a acao retornada e executa a consulta no banco quando necessario.

Mostre os nos:

- `Receber Telegram`
- `Preparar entrada Watson`
- `IBM Watson Assistant V2`
- `Interpretar acao do Watson`
- `Consultar SQLite`
- `Formatar resposta academica`
- `Responder Telegram`

## 5. Demonstrar contexto

Mostre:

```text
Aluno: 546.924.658-24
Bot: Pronto, encontrei seu cadastro...
Aluno: minhas notas
Bot: retorna notas sem pedir CPF/RM de novo
```

Explique:

> Depois da primeira identificacao, o Node-RED salva o aluno no contexto da conversa.

## 6. Demonstrar validacao

Mostre:

```text
Aluno: RM
Bot: Para consultar pelo RM, preciso do numero completo com 6 digitos...
```

Mostre tambem:

```text
Aluno: 572956
Bot: encontra RM572956
```

Explique:

> O sistema aceita RM572956 ou apenas 572956, mas exige 6 digitos quando for numerico.

## 7. Demonstrar fallback

Digite algo que o bot nao entende.

Explique:

> Em vez de travar, o bot oferece opcoes de conversa, cumprindo o requisito de fallback educado.

## 8. Mostrar o banco

Mostre o schema ou o arquivo `db/init.sql`.

Explique tabelas:

- `curso`
- `aluno`
- `materia`
- `aluno_materia`
- `notas`

## 9. Fechamento

Diga:

> O projeto cumpre a integracao plena entre Telegram, Watson, Node-RED e banco de dados, com contexto de conversa, fallback amigavel e consulta dinamica ao SQLite.

## Checklist para o video

- Mostrar Telegram funcionando.
- Mostrar Watson configurado.
- Mostrar fluxo Node-RED.
- Mostrar banco SQLite/tabelas.
- Mostrar consulta de RM.
- Mostrar consulta de notas.
- Mostrar consulta de faltas ou materias.
- Mostrar fallback.
