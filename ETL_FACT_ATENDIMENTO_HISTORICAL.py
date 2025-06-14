import os
import sys
import keyring as kr;
from ConexaoBD import *;
from DataPipeline import *;

#----------- VARIABLES ------------

params_mysql = {
    'user': 'Amanda',
    'password':kr.get_password('MYSQL','Amanda')
}

params_ora_p = {
    'user': 'Amanda',
    'password':kr.get_password('Oracle', 'Amanda')
}

query = """
    SELECT 
    id,
    ticket_id, 
    history_type_id, 
    create_time, 
    owner_id, 
    change_by, 
    queue_id, 
    state_id as status_id, 
    type_id,
    NOW() as DATA_INCLUSAO
    FROM attendance_historical
    WHERE year(create_time)>=2024
"""

columns = ['ID', 'TICKET_ID', 'HISTORY_TYPE_ID', 'CREATE_TIME', 'OWNER_ID',
    'CHANGE_BY', 'QUEUE_ID', 'STATUS_ID', 'TYPE_ID', 'DATA_INCLUSAO']

#---------------------- PIPELINE ---------------------------------

try:
    # ------ Conexão MySQL e Oracle ------ 
    mysql_connector = DBConnectorFactory.get_connector('mysql', **params_mysql)
    oracle_connector =  DBConnectorFactory.get_connector('oracle_prod',**params_ora_p)

    # ----------------- Extract e Load ---------------------
    elt = ETLProcessor(mysql_connector,oracle_connector)

    elt.trunc_table('STAGE_ATENDIMENTO')
    elt.transfer_data_batch(
        source_query=query,
        target_table="STAGE_ATENDIMENTO",
        target_columns=columns
    )

    #--------------- Transform ---------------- 
    elt.trunc_table('FATO_ATENDIMENTO')
    elt.parallel_session_insert()
    elt.execute_proc('PROC_FACT_TABLE')
    elt.close_cursor()

    print('Execution concluded')

except BaseException as erro:
    print(erro)
    print(traceback.format_exc())
    