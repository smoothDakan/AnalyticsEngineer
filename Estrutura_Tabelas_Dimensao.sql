----- Dimensão ATENDIMENTO Status
CREATE TABLE DIMENSAO_STATUS (
    ID                      NUMBER(3) NOT NULL PRIMARY KEY,
    NAME                    VARCHAR2(200),
    TYPE_NAME               VARCHAR2(200),
    DATA_INCLUSAO           TIMESTAMP,
    ULTIMA_DATA_ALTERACAO   TIMESTAMP DEFAULT SYSTIMESTAMP
)

CREATE INDEX IDX_DIMENSAO_STATUS
ON DIMENSAO_STATUS (
    ID
);

----- Dimensão ATENDIMENTO Fila
CREATE TABLE DIMENSAO_FILA (
     ID                       NUMBER(19) NOT NULL PRIMARY KEY
    , NAME                    VARCHAR2(200)		
    , SYSTEM_ADDRESS          VARCHAR2(200)		
    , SYSTEM_ADDRESS_NAME     VARCHAR2(200)		
    , DATA_INCLUSAO           TIMESTAMP		
    , ULTIMA_DATA_ALTERACAO   TIMESTAMP	DEFAULT SYSTIMESTAMP
)

CREATE INDEX IDX_DIMENSAO_FILA
ON DIMENSAO_FILA (
    ID
);

----- Dimensão ATENDIMENTO User
CREATE TABLE DIMENSAO_USER (
     ID                            NUMBER(10)	NOT NULL PRIMARY KEY	
    , LOGIN                         VARCHAR2(200)		
    , TITLE                         VARCHAR2(50)		
    , FIRST_NAME                    VARCHAR2(100)		
    , LAST_NAME                     VARCHAR2(100)		
    , DATA_INCLUSAO                 TIMESTAMP		
    , ULTIMA_DATA_ALTERACAO         TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE INDEX IDX_DIMENSAO_USER
ON DIMENSAO_USER (
    ID
);

----- Dimensão ATENDIMENTO
CREATE TABLE DIMENSAO_ATENDIMENTO (
     ID                            NUMBER(10)	NOT NULL PRIMARY KEY
    , TN                            VARCHAR(50)	NOT NULL
    , TITLE                         VARCHAR2(50)
    , SLA_NAME                      VARCHAR2(200)		
    , SLA_FIRST_RESPONSE_TIME       NUMBER(10)
    , SLA_SOLUTION_TIME             NUMBER(10)
    , PRIORITY                      VARCHAR2(200)		
    , CREATE_TIME                   TIMESTAMP		
    , DATA_INCLUSAO                 TIMESTAMP		
    , ULTIMA_DATA_ALTERACAO         TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE INDEX IDX_DIMENSAO_ATENDIMENTO
ON DIMENSAO_ATENDIMENTO (
    ID,
    TN
);

----- Dimensão History Type
CREATE TABLE DIMENSAO_HIST_TYPE (
     ID                            NUMBER(5)	NOT NULL PRIMARY KEY
    , NAME                          VARCHAR2(200)	
    , DATA_INCLUSAO                 TIMESTAMP		
    , ULTIMA_DATA_ALTERACAO         TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE INDEX IDX_DIMENSAO_HIST_TYPE
ON DIMENSAO_HIST_TYPE (
    ID
);

----- Dimensão Service
CREATE TABLE DIMENSAO_SERVICE (
     ID                            NUMBER(5)	NOT NULL PRIMARY KEY
    , NAME                          VARCHAR2(200)
    , CRITICALITY                   VARCHAR2(200)	
    , DATA_INCLUSAO                 TIMESTAMP		
    , ULTIMA_DATA_ALTERACAO         TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE INDEX IDX_DIMENSAO_SERVICE
ON DIMENSAO_SERVICE (
    ID
);
