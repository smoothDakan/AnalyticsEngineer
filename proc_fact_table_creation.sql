CREATE OR REPLACE PROCEDURE PROC_FACT_TABLE (
    v_limite IN NUMBER DEFAULT NULL
) AS

BEGIN

    DBMS_OUTPUT.PUT_LINE('Starting first stage: LAGS');

    -- 1. Popular TMP_LAGS
    INSERT /*+ parallel(TMP_FATO_LAGS, 8) */ INTO TMP_FATO_LAGS
    SELECT 
        ticket_id, history_type_id, create_time, owner_id, change_by, queue_id, status_id, type_id,
        LAG(owner_id) OVER (PARTITION BY ticket_id ORDER BY create_time) AS prev_owner,
        LAG(change_by) OVER (PARTITION BY ticket_id ORDER BY create_time) AS prev_attendent,
        LAG(queue_id) OVER (PARTITION BY ticket_id ORDER BY create_time) AS prev_queue,
        LAG(status_id) OVER (PARTITION BY ticket_id ORDER BY create_time) AS prev_status,
        LAG(type_id) OVER (PARTITION BY ticket_id ORDER BY create_time) AS prev_type,
        ROW_NUMBER() OVER (PARTITION BY ticket_id ORDER BY create_time) AS ordem_ticket,
        DATA_INCLUSAO
    FROM STAGE_ATENDIMENTO
    WHERE v_limite IS NULL OR ROWNUM <= v_limite;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Starting second stage: checking marks');
    
    -- 2. Popular TMP_MARCACOES
    INSERT /*+ parallel(TMP_FATO_MARCACOES, 8) */ INTO TMP_FATO_MARCACOES (
        ticket_id, history_type_id, create_time, owner_id, change_by, 
        queue_id, status_id, type_id,ordem_ticket, data_inclusao, mudou
        )
    SELECT ticket_id, history_type_id, create_time, owner_id, change_by, queue_id, status_id, type_id, ordem_ticket, data_inclusao,
        CASE 
            WHEN queue_id  <> prev_queue
              OR status_id <> prev_status
              OR owner_id <> prev_owner
              OR change_by <> prev_attendent
              OR type_id <> prev_type
            THEN 1 ELSE 0
        END AS mudou
    FROM TMP_FATO_LAGS
    ORDER BY TICKET_ID, ORDEM_TICKET;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Starting third stage: summarization');
    
    -- 3. Popular TMP_GRUPOS
    INSERT /*+ parallel(TMP_FATO_GRUPOS, 8) */ INTO TMP_FATO_GRUPOS (
        ticket_id, history_type_id, create_time, owner_id, change_by, 
        queue_id, status_id, type_id,data_inclusao,mudou,grupo
        )
    SELECT ticket_id, history_type_id, create_time, owner_id, change_by, 
        queue_id, status_id, type_id,data_inclusao,mudou,
        SUM(mudou) OVER (
            PARTITION BY ticket_id 
            ORDER BY ordem_ticket
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS grupo
    FROM TMP_FATO_MARCACOES
    ORDER BY TICKET_ID, ORDEM_TICKET;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Starting fourth stage: insert fact table');
    
    --- 4 Populando FACT TABLE
    INSERT /*+ parallel(FATO_ATENDIMENTO, 8) */ INTO FATO_ATENDIMENTO (
        TICKET_ID, ACTION_ID, OWNER_ID, START_TIME, END_TIME,
        CHANGE_BY_ID, QUEUE_ID, STATUS_ID, TYPE_ID, SECONDS_IN_STATE, MINUTES_IN_STATE,
        HOURS_IN_STATE, DAYS_IN_STATE, DATA_INCLUSAO
        )
    SELECT 
        ticket_id,
        MIN(history_type_id),
        MAX(owner_id),
        MIN(create_time),
        MAX(create_time),
        MAX(change_by),
        MAX(queue_id),
        MAX(status_id),
        MAX(type_id),
        EXTRACT(SECOND FROM MAX(create_time) - MIN(create_time)) as SECONDS_IN_STATE,
        EXTRACT(MINUTE FROM MAX(create_time) - MIN(create_time)) as MINUTES_IN_STATE,
        EXTRACT(HOUR FROM MAX(create_time) - MIN(create_time)) as HOURS_IN_STATE,
        EXTRACT(DAY FROM MAX(create_time) - MIN(create_time))as DAYS_IN_STATE,
        MIN(DATA_INCLUSAO) as DATA_INCLUSAO
    FROM TMP_FATO_GRUPOS
    GROUP BY ticket_id, grupo;
    
    COMMIT;

END;