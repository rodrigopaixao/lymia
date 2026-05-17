# Explicacao do Codigo das Funcoes

Este documento explica as principais funcoes JavaScript usadas dentro do Node-RED.

## Funcao `Preparar entrada Watson`

Objetivo: adaptar a mensagem do Telegram para o Watson Assistant.

### Extracao do chat e texto

```js
const payload = msg.payload || {};
const chatId = payload.chatId || payload.chatid || payload.message?.chat?.id;
const text = String(payload.content || payload.text || payload.message?.text || '').trim();
```

O node Telegram pode entregar a mensagem em formatos diferentes. Por isso o codigo tenta varias propriedades.

### Validacao basica

```js
if (!chatId) {
    node.warn('Mensagem sem chatId recebida do Telegram.');
    return null;
}
```

Sem `chatId`, nao da para responder ao aluno correto.

### Sessao do Watson

```js
msg.params = {
    session_id: String(chatId),
    return_context: true,
    alternate_intents: true
};
```

O `session_id` usa o `chatId`, para que cada conversa do Telegram tenha uma sessao separada no Watson.

### Contexto adicional

```js
msg.additional_context = {
    telegram_chat_id: String(chatId),
    aluno_identificado: aluno.status === 'identified',
    aluno_id: aluno.alunoId || null,
    aluno_nome: aluno.nome || null,
    aluno_cpf: aluno.cpf || null,
    aluno_rm: aluno.rm || null,
    aluno_curso: aluno.curso || null
};
```

Esses dados sao enviados para o Watson saber se o aluno ja foi identificado.

## Funcao `Interpretar acao do Watson`

Objetivo: receber a resposta do Watson e decidir o proximo passo.

### Busca de variaveis do Watson

```js
function findUserDefined() {
    const skills = watson.context?.skills || {};
    const merged = {};
    for (const skill of Object.values(skills)) {
        if (skill?.user_defined) {
            Object.assign(merged, skill.user_defined);
        }
    }
    return merged;
}
```

O Watson pode retornar variaveis em `main skill` ou `actions skill`. Esta funcao procura em todas as skills.

### Normalizacao

```js
function normalize(value) {
    return String(value || '')
        .normalize('NFD')
        .replace(/[\\u0300-\\u036f]/g, '')
        .toLowerCase()
        .trim();
}
```

Remove acentos, transforma em minusculo e limpa espacos. Isso facilita comparar textos como `matérias`, `materias`, `MATERIAS`.

### Acoes aceitas

```js
function canonicalAction(action) {
    const aliases = {
        consultar_rm: 'rm',
        consultar_notas: 'notas',
        consultar_materias: 'materias',
        consultar_faltas: 'faltas',
        consultar_turnos: 'turnos'
    };
    return aliases[action] || '';
}
```

A ideia e aceitar nomes diferentes vindos do Watson e transformar tudo em uma acao padrao.

Exemplo:

```text
consultar_rm -> rm
consultar_notas -> notas
```

### RM flexivel

O codigo aceita:

```text
RM572956
572956
```

Ambos viram:

```text
RM572956
```

Se o aluno digitar apenas:

```text
RM
10
```

o bot pede o numero completo.

### Uso do contexto

Depois que o aluno ja foi identificado, o codigo pode usar:

```js
session.alunoId
```

Assim, perguntas como `minhas notas` ou `minhas faltas` nao precisam repetir RM ou CPF.

### Montagem das queries

A funcao `buildQuery(action, identifier)` monta o SQL correto para cada acao.

Exemplos:

- `rm`, `curso`, `perfil`: buscam dados basicos do aluno.
- `notas`: busca notas e media final.
- `materias`: busca materias inscritas.
- `turnos`: busca turnos das materias.
- `faltas`: calcula faltas a partir da carga horaria e presencas registradas.

## Funcao `Formatar resposta academica`

Objetivo: transformar o resultado SQL em mensagem amigavel.

### Quando nao encontra aluno

```js
return reply(`Nao encontrei nenhum aluno com ${id}. Pode conferir se o CPF ou RM esta certinho e me mandar novamente?`);
```

Mensagem educada para erro de busca.

### Quando identifica aluno

```text
Pronto, encontrei seu cadastro, Manuela de Lima Ramos.
Seu RM e RM572956.
```

Depois disso, salva o aluno no contexto.

### Notas

Resposta inclui:

- Materia.
- CP1.
- CP2.
- GS1.
- CH1.
- Media final.

### Faltas

No schema atual nao existe uma coluna direta de faltas. Entao o projeto calcula:

```text
faltas = total_horas - presencas_registradas
```

Isso e explicado na resposta ao aluno.
