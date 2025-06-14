
import datetime as dt
from datetime import timedelta, datetime, date
import cx_Oracle
from mysql.connector import errorcode
import mysql.connector
import keyring as kr
import os;
from abc import ABC, abstractmethod
import traceback;

class DatabaseConnector(ABC):
    
    @abstractmethod
    def connect(self):
        pass

    @abstractmethod
    def execute_query(self, query: str):
        pass


class OracleConnectorProd(DatabaseConnector):
    def __init__(self, user, password, host='10.128.546.27', port='1515', service_name='OracleProd'):
        self.dsn = cx_Oracle.makedsn(host, port, service_name=service_name)
        self.user = user
        if password is None:
            self.password = kr.get_password('Oracle', user)
        else: self.password = password
        self.conn = None

    def connect(self):
        try:
            print('conectando no oracle')
            self.conn = cx_Oracle.connect(self.user, self.password, self.dsn)
            return self.conn
        except BaseException as erro:
            print(erro)
            print(traceback.format_exc())

    def execute_query(self, query):
        try:
            print('gerando cursor oracle e executando query')
            with self.conn.cursor() as cursor:
                cursor.execute(query)
                return cursor.fetchall()
        except BaseException as erro:
            print(erro)
            print(traceback.format_exc())
        

class MySQLConnector(DatabaseConnector):
    def __init__(self, user, password, host='10.128.246.32', database='atendimentos', port='1516'):
        self.config = {
            'user': user,
            'password': password,
            'host': host,
            'database': database,
            'port': port
        }
        self.conn = None

    def connect(self):
        try:
            print('iniciando conexao do mysql')
            self.conn = mysql.connector.connect(**self.config)
            return self.conn
        except BaseException as erro:
            print(erro)
            print(traceback.format_exc())

    def execute_query(self, query):
        try:
            print('iniciando cursor do mysql')
            cursor = self.conn.cursor()
            cursor.execute(query)
            return cursor.fetchall()
        except BaseException as erro:
            print(erro)
            print(traceback.format_exc())


class DBConnectorFactory:
    @staticmethod
    def get_connector(db_type: str, **kwargs):
        if db_type == 'oracle_prod':
            return OracleConnectorProd(**kwargs)
        elif db_type == 'mysql':
            return MySQLConnector(**kwargs)
        else:
            raise ValueError(f"Unsupported DB type: {db_type}")
