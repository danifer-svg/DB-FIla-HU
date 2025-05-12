-- Construção da arquitetura do Banco de Consultas do HU.

-- 1. Tabela de Solicitações - Armazena os dados centrais de cada pedido no sistema
CREATE TABLE Solicitacoes (
    id NUMBER PRIMARY KEY,      -- Identificador único da solicitação
    usuario_id NUMBER,          -- FK para tabela Usuarios
    tipo_solicitacao_id NUMBER, -- FK para TiposSolicitacao
    situacao_id NUMBER,         -- FK para Situacoes
    sigtap_id NUMBER,           -- FK para SIGTAP
    procedimento VARCHAR2(255),
    swalis_id NUMBER,           -- FK para SWALIS
    data_solicitacao DATE,
    tipo_leito_id NUMBER,       -- FK para TiposLeito
    especialidade_id NUMBER,    -- FK para Especialidades
    cid_id NUMBER,              -- FK para CID
    data_autorizacao DATE,
    profissional_regulador VARCHAR2(255),
    leito_id NUMBER,            -- FK para Leitos
    tempo_espera_dias NUMBER,
    status VARCHAR2(50),
    data_ultima_atualizacao DATE,
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    CONSTRAINT fk_tipo_solicitacao FOREIGN KEY (tipo_solicitacao_id) REFERENCES TiposSolicitacao(id),
    CONSTRAINT fk_situacao FOREIGN KEY (situacao_id) REFERENCES Situacoes(id),
    CONSTRAINT fk_sigtap FOREIGN KEY (sigtap_id) REFERENCES SIGTAP(id),
    CONSTRAINT fk_swalis FOREIGN KEY (swalis_id) REFERENCES Swalis(id),
    CONSTRAINT fk_tipo_leito FOREIGN KEY (tipo_leito_id) REFERENCES TiposLeito(id),
    CONSTRAINT fk_especialidade FOREIGN KEY (especialidade_id) REFERENCES Especialidades(id),
    CONSTRAINT fk_cid FOREIGN KEY (cid_id) REFERENCES CID(id),
    CONSTRAINT fk_leito FOREIGN KEY (leito_id) REFERENCES Leitos(id)
);

-- 2. Tabela de Usuários - Contém os dados pessoais do paciente
CREATE TABLE Usuarios (
    id NUMBER PRIMARY KEY,
    nome VARCHAR2(255),
    idade NUMBER,
    nome_mae VARCHAR2(255),
    data_nascimento DATE,
    telefone VARCHAR2(20),
    endereco VARCHAR2(255),
    gestante CHAR(1) CHECK (gestante IN ('S','N')),
    CONSTRAINT fk_municipio_residencia FOREIGN KEY (municipio_residencia_id) REFERENCES Municipios(id),
);

-- 3. Tabela de Estabelecimentos - Pode ser Solicitante ou Realizador
CREATE TABLE Estabelecimentos (
    id NUMBER PRIMARY KEY,
    nome VARCHAR2(255),
    tipo VARCHAR2(20) CHECK (tipo IN ('Solicitante', 'Realizador')),
    regiao_id NUMBER, -- FK para Regioes
    CONSTRAINT fk_regiao FOREIGN KEY (regiao_id) REFERENCES Regioes(id)
);

-- 4. Tabela de Regiões - Usada tanto para origem quanto destino
CREATE TABLE Regioes (
    id NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    tipo VARCHAR2(10) CHECK (tipo IN ('Origem', 'Destino'))
);

-- 5. Tabela de Municípios - Armazena os nomes e estados
CREATE TABLE Municipios (
    id NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    estado VARCHAR2(2)
);

-- 6. Tabela JudicialMandados - Registra se houve ação judicial e o mandado
CREATE TABLE JudicialMandados (
    id NUMBER PRIMARY KEY,
    solicitacao_id NUMBER, -- FK para Solicitacoes
    judicial CHAR(1) CHECK (judicial IN ('S', 'N')),
    mandado_judicial VARCHAR2(255),
    CONSTRAINT fk_solicitacao_judicial FOREIGN KEY (solicitacao_id) REFERENCES Solicitacoes(id)
);

-- 7. Tabela de Agendamentos - Dados da fila e agendamento da solicitação
CREATE TABLE Agendamentos (
    id NUMBER PRIMARY KEY,
    solicitacao_id NUMBER, -- FK para Solicitacoes
    data_agendamento DATE,
    posicao_fila NUMBER,
    CONSTRAINT fk_solicitacao_agendamento FOREIGN KEY (solicitacao_id) REFERENCES Solicitacoes(id)
);

-- 8. Tabela Swalis - Armazena código e nome do SWALIS
CREATE TABLE Swalis (
    id NUMBER PRIMARY KEY,
    cod_swalis VARCHAR2(50),
    nome VARCHAR2(255)
);

-- 9. Tabela SIGTAP - Referência de procedimentos
CREATE TABLE SIGTAP (
    id NUMBER PRIMARY KEY,
    codigo VARCHAR2(50),
    nome VARCHAR2(255),
    grupo_sus_id NUMBER,            -- FK para GrupoSUS
    subgrupo_sus_id NUMBER,         -- FK para SubgrupoSUS
    forma_sus_id NUMBER,            -- FK para FormaSUS
    CONSTRAINT fk_grupo_sus FOREIGN KEY (grupo_sus_id) REFERENCES GrupoSUS(id),
    CONSTRAINT fk_subgrupo_sus FOREIGN KEY (subgrupo_sus_id) REFERENCES SubgrupoSUS(id),
    CONSTRAINT fk_forma_sus FOREIGN KEY (forma_sus_id) REFERENCES FormaSUS(id)
);
