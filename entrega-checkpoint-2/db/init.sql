PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

DROP TABLE IF EXISTS notas;
DROP TABLE IF EXISTS aluno_materia;
DROP TABLE IF EXISTS materia;
DROP TABLE IF EXISTS aluno;
DROP TABLE IF EXISTS curso;
DROP TABLE IF EXISTS clientes;

CREATE TABLE curso (
  id INTEGER PRIMARY KEY,
  nome TEXT NOT NULL COLLATE NOCASE,
  criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_curso_nome UNIQUE (nome),
  CONSTRAINT ck_curso_nome_not_blank CHECK (length(trim(nome)) > 0)
);

CREATE TABLE aluno (
  id INTEGER PRIMARY KEY,
  nome TEXT NOT NULL COLLATE NOCASE,
  cpf TEXT NOT NULL,
  rm TEXT NOT NULL COLLATE NOCASE,
  curso_id INTEGER NOT NULL,
  criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_aluno_cpf UNIQUE (cpf),
  CONSTRAINT uq_aluno_rm UNIQUE (rm),
  CONSTRAINT ck_aluno_nome_not_blank CHECK (length(trim(nome)) > 0),
  CONSTRAINT ck_aluno_cpf_digits CHECK (length(cpf) = 11 AND cpf NOT GLOB '*[^0-9]*'),
  CONSTRAINT ck_aluno_rm_not_blank CHECK (length(trim(rm)) > 0),
  CONSTRAINT fk_aluno_curso
    FOREIGN KEY (curso_id)
    REFERENCES curso (id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE materia (
  id INTEGER PRIMARY KEY,
  curso_id INTEGER NOT NULL,
  nome TEXT NOT NULL COLLATE NOCASE,
  turno TEXT NOT NULL COLLATE NOCASE,
  total_horas INTEGER NOT NULL,
  criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_materia_curso_nome_turno UNIQUE (curso_id, nome, turno),
  CONSTRAINT ck_materia_nome_not_blank CHECK (length(trim(nome)) > 0),
  CONSTRAINT ck_materia_turno CHECK (turno IN ('manha', 'tarde', 'noite', 'integral')),
  CONSTRAINT ck_materia_total_horas CHECK (total_horas > 0),
  CONSTRAINT fk_materia_curso
    FOREIGN KEY (curso_id)
    REFERENCES curso (id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE aluno_materia (
  aluno_id INTEGER NOT NULL,
  materia_id INTEGER NOT NULL,
  data_presenca TEXT NOT NULL,
  criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_aluno_materia PRIMARY KEY (aluno_id, materia_id, data_presenca),
  CONSTRAINT ck_aluno_materia_data_presenca CHECK (data_presenca = date(data_presenca)),
  CONSTRAINT fk_aluno_materia_aluno
    FOREIGN KEY (aluno_id)
    REFERENCES aluno (id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_aluno_materia_materia
    FOREIGN KEY (materia_id)
    REFERENCES materia (id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE notas (
  aluno_id INTEGER NOT NULL,
  materia_id INTEGER NOT NULL,
  cp_1 REAL NOT NULL DEFAULT 0,
  cp_2 REAL NOT NULL DEFAULT 0,
  gs_1 REAL NOT NULL DEFAULT 0,
  ch_1 REAL NOT NULL DEFAULT 0,
  media_final REAL GENERATED ALWAYS AS (round((cp_1 + cp_2 + gs_1 + ch_1) / 4.0, 2)) STORED,
  criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_notas PRIMARY KEY (aluno_id, materia_id),
  CONSTRAINT ck_notas_cp_1 CHECK (cp_1 BETWEEN 0 AND 10),
  CONSTRAINT ck_notas_cp_2 CHECK (cp_2 BETWEEN 0 AND 10),
  CONSTRAINT ck_notas_gs_1 CHECK (gs_1 BETWEEN 0 AND 10),
  CONSTRAINT ck_notas_ch_1 CHECK (ch_1 BETWEEN 0 AND 10),
  CONSTRAINT fk_notas_aluno
    FOREIGN KEY (aluno_id)
    REFERENCES aluno (id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_notas_materia
    FOREIGN KEY (materia_id)
    REFERENCES materia (id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE INDEX idx_aluno_curso_id ON aluno (curso_id);
CREATE INDEX idx_materia_curso_id ON materia (curso_id);
CREATE INDEX idx_aluno_materia_materia_id ON aluno_materia (materia_id);
CREATE INDEX idx_notas_materia_id ON notas (materia_id);

CREATE TRIGGER trg_curso_atualizado_em
AFTER UPDATE ON curso
FOR EACH ROW
WHEN NEW.atualizado_em = OLD.atualizado_em
BEGIN
  UPDATE curso SET atualizado_em = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER trg_aluno_atualizado_em
AFTER UPDATE ON aluno
FOR EACH ROW
WHEN NEW.atualizado_em = OLD.atualizado_em
BEGIN
  UPDATE aluno SET atualizado_em = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER trg_materia_atualizado_em
AFTER UPDATE ON materia
FOR EACH ROW
WHEN NEW.atualizado_em = OLD.atualizado_em
BEGIN
  UPDATE materia SET atualizado_em = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER trg_aluno_materia_atualizado_em
AFTER UPDATE ON aluno_materia
FOR EACH ROW
WHEN NEW.atualizado_em = OLD.atualizado_em
BEGIN
  UPDATE aluno_materia
  SET atualizado_em = CURRENT_TIMESTAMP
  WHERE aluno_id = NEW.aluno_id
    AND materia_id = NEW.materia_id
    AND data_presenca = NEW.data_presenca;
END;

CREATE TRIGGER trg_notas_atualizado_em
AFTER UPDATE ON notas
FOR EACH ROW
WHEN NEW.atualizado_em = OLD.atualizado_em
BEGIN
  UPDATE notas
  SET atualizado_em = CURRENT_TIMESTAMP
  WHERE aluno_id = NEW.aluno_id
    AND materia_id = NEW.materia_id;
END;

INSERT INTO curso (id, nome)
VALUES
  (1, 'Analise e Desenvolvimento de Sistemas'),
  (2, 'Sistemas de Informacao'),
  (3, 'Ciencia da Computacao');

INSERT INTO aluno (id, nome, cpf, rm, curso_id)
VALUES
  (1, 'Manuela de Lima Ramos', '54692465824', 'RM572956', 1),
  (2, 'Lena Halawi', '60403347890', 'RM572258', 1),
  (3, 'Yasmin Souza Silva Martins', '54957620881', 'RM572102', 2),
  (4, 'Lyvia Correa de Amorim', '46217429810', 'RM569851', 3);

INSERT INTO materia (id, curso_id, nome, turno, total_horas)
VALUES
  (1, 1, 'Integracao entre Sistemas', 'noite', 80),
  (2, 1, 'Banco de Dados', 'noite', 80),
  (3, 1, 'Inteligencia Artificial e Chatbot', 'noite', 60),
  (4, 2, 'Engenharia de Software', 'manha', 80),
  (5, 2, 'Governanca de Dados', 'manha', 60),
  (6, 3, 'Arquitetura de Computadores', 'tarde', 80),
  (7, 3, 'Programacao Web', 'tarde', 80);

INSERT INTO aluno_materia (aluno_id, materia_id, data_presenca)
VALUES
  (1, 1, '2026-05-01'),
  (1, 1, '2026-05-08'),
  (1, 2, '2026-05-02'),
  (1, 3, '2026-05-03'),
  (2, 1, '2026-05-01'),
  (2, 2, '2026-05-02'),
  (2, 2, '2026-05-09'),
  (2, 3, '2026-05-03'),
  (3, 4, '2026-05-04'),
  (3, 4, '2026-05-11'),
  (3, 5, '2026-05-05'),
  (4, 6, '2026-05-06'),
  (4, 7, '2026-05-07'),
  (4, 7, '2026-05-14');

INSERT INTO notas (aluno_id, materia_id, cp_1, cp_2, gs_1, ch_1)
VALUES
  (1, 1, 8.5, 9.0, 8.0, 9.5),
  (1, 2, 7.5, 8.0, 8.5, 8.0),
  (1, 3, 9.0, 9.5, 9.0, 10.0),
  (2, 1, 7.0, 7.5, 8.0, 7.5),
  (2, 2, 8.0, 8.5, 8.0, 8.5),
  (2, 3, 6.5, 7.0, 7.5, 8.0),
  (3, 4, 9.0, 8.5, 9.5, 9.0),
  (3, 5, 8.0, 8.0, 8.5, 9.0),
  (4, 6, 7.5, 8.0, 7.0, 8.5),
  (4, 7, 9.5, 9.0, 9.0, 9.5);

COMMIT;
