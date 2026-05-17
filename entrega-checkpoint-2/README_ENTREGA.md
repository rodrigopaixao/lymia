# CheckPoint 2 - Chatbot Telegram + Watson + Node-RED + SQLite

## Projeto

Chatbot acadêmico integrado ao Telegram, IBM Watson Assistant, Node-RED e banco SQLite.

## Como executar

1. Copiar `.env.example` para `.env` na raiz do projeto original.
2. Configurar o token do Telegram no node `LyviaBot` do Node-RED.
3. Configurar o node `IBM Watson Assistant V2` com:
   - API Key
   - Service Endpoint
   - Assistant ID / Draft Environment ID
4. Criar o banco:

```bash
sqlite3 nodered-data/escola.db < db/init.sql
```

5. Subir o ambiente:

```bash
docker compose up --build
```

6. Abrir:

```text
http://localhost:1880
```

## Arquivos principais

- `nodered-data/flows.json`: fluxo Node-RED exportado.
- `nodered-data/escola.db`: banco SQLite usado no projeto.
- `db/init.sql`: script de criação e carga inicial do banco.
- `docker-compose.yml`: ambiente Node-RED.
- `Dockerfile`: instalação dos nodes Telegram, SQLite e IBM Watson.
- `.env.example`: exemplo de variáveis, sem chaves reais.

## Observação sobre credenciais

Credenciais reais não foram incluídas no pacote por segurança. Elas devem ser configuradas diretamente no Node-RED ou via ambiente local.
