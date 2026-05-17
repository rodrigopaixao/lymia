CREATE TABLE IF NOT EXISTS clientes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cpf TEXT NOT NULL UNIQUE,
  nome TEXT NOT NULL,
  status TEXT NOT NULL,
  plano TEXT,
  atualizado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO clientes (cpf, nome, status, plano)
VALUES
  ('52998224725', 'Maria Oliveira', 'ativo', 'Premium'),
  ('11144477735', 'Joao da Silva', 'pendente', 'Essencial'),
  ('12345678909', 'Ana Souza', 'bloqueado', 'Basico')
ON CONFLICT(cpf) DO UPDATE SET
  nome = excluded.nome,
  status = excluded.status,
  plano = excluded.plano,
  atualizado_em = CURRENT_TIMESTAMP;
