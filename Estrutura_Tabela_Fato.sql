-- 1. Criar a tabela
CREATE TABLE FATO_ATENDIMENTO (
    ID                      NUMBER(19) CONSTRAINT pk_fato_id PRIMARY KEY,
    TICKET_ID               NUMBER(19),
    START_TIME              TIMESTAMP,
    END_TIME                TIMESTAMP,
    OWNER_ID                NUMBER(10),
    TICKET_TYPE             VARCHAR2(200),
    ACTION_ID               NUMBER(5),
    CHANGE_BY_ID            NUMBER(10),
    QUEUE_ID                NUMBER(10),
    STATUS_ID               NUMBER(5),
    SECONDS_IN_STATE        NUMBER(10),
    MINUTES_IN_STATE        NUMBER(10),
    HOURS_IN_STATE          NUMBER(5),
    DAYS_IN_STATE           NUMBER(5),
    DATA_INCLUSAO           TIMESTAMP,
    ULTIMA_DATA_ALTERACAO   TIMESTAMP DEFAULT SYSTIMESTAMP
)
SEGMENT CREATION DEFERRED
PARALLEL
COMPRESS BASIC;

-- 2. Criar a sequência para o ID
CREATE SEQUENCE SEQ_FATO_ID
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 3. Criar o índice secundário
CREATE INDEX IDX_FATO_ATENDIMENTO
ON FATO_ATENDIMENTO (
    TICKET_ID,
    OWNER_ID,
    CHANGE_BY_ID,
    QUEUE_ID,
    STATUS_ID,
    START_TIME
);