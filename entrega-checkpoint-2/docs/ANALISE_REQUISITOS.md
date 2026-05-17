# Analise dos Requisitos do CheckPoint 2

Fonte analisada: `Aula 10 - CheckPoint 2.pdf`.

## Requisitos técnicos mínimos

| Requisito | Status | Evidência / Observação |
| --- | --- | --- |
| Integração Telegram | Atendido | Fluxo possui nodes `telegram receiver` e `telegram sender`. |
| Integração Watson Assistant | Atendido no Node-RED | Fluxo usa o node `watson-assistant-v2`. Credenciais devem ser configuradas no editor. |
| Node-RED como middleware | Atendido | Todo o fluxo está orquestrado em `nodered-data/flows.json`. |
| Banco de dados anexado | Atendido | Incluídos `nodered-data/escola.db` e `db/init.sql`. |
| Consulta dinâmica ao BD via Node-RED | Atendido | Node `Consultar SQLite` usa queries geradas pelo fluxo. |
| Coleta e validação de dado | Atendido parcialmente | O fluxo valida CPF/RM e consulta o BD. A validação por Entidades/Variáveis precisa estar configurada no Watson. |
| Fallback educado | Atendido | O bot retorna opções amigáveis quando não entende a pergunta. |
| Watson treinado com pelo menos 5 intenções | Não verificável no repositório | Precisa confirmar no IBM Cloud. Sugestões: `consultar_rm`, `consultar_notas`, `consultar_materias`, `consultar_faltas`, `consultar_turnos`, `consultar_curso`. |
| Vídeo de até 5 minutos | Pendente | Deve ser gravado e enviado/linkado por e-mail. |

## Pontos a confirmar antes do envio

- O Watson Assistant está no servidor EUA - Washington.
- O campo do Node-RED `Assistant ID` recebeu o Draft Environment ID, conforme orientação do PDF.
- O Watson possui pelo menos 5 intenções treinadas.
- As variáveis do Watson retornam `acao_consulta` ou `acao_pendente` conforme o contrato documentado no README principal.
- O vídeo mostra:
  - Tabelas/dados do SQLite.
  - Fluxo no Node-RED.
  - Chatbot funcionando no Telegram.

## Corpo do e-mail

O PDF pede que o corpo do e-mail contenha:

- Turma: `1TDSXX`
- RM e nome dos alunos do grupo.
- Link do vídeo, caso publicado no YouTube.

Destinatário informado no PDF:

```text
profalfonso.rodriguez@fiap.com.br
```
