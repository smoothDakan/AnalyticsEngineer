import os
import sys
import keyring as kr;
from ConexaoBD import *;
from DataPipeline import *;

   
#--------------------- VARIABLES ----------------------------------
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
      login,		
      title,	
      first_name,		
      last_name,		
      NOW() as DATA_INCLUSAO
      FROM users
      WHERE valid_id = 1
"""

columns = ['ID', 'LOGIN', 'TITLE','FIRST_NAME', 'LAST_NAME','DATA_INCLUSAO']

#------------ PIPELINE ---------------
try:
    # ------ Conexão MySQL e Oracle  ------ 
    mysql_connector = DBConnectorFactory.get_connector('mysql', **params_mysql)
    oracle_connector =  DBConnectorFactory.get_connector('oracle_prod',**params_ora_p)


    # ----------------- Extract e Load ---------------------
    elt = ETLProcessor(mysql_connector,oracle_connector)

    elt.truncate_table("DIMENSAO_USER")

    elt.transfer_data_batch(
        source_query=query,
        target_table="DIMENSAO_USER",
        target_columns=columns
    )

    elt.close_cursor()

    print('elt completed')
    
except BaseException as error:
    print(error)
    print(traceback.format_exc())