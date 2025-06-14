# AnalyticsEngineer
## ELT Base: Transferência e Modelagem de Dados OLTP → OLAP
Este repositório é uma base para construção de pipelines de ELT com foco em extração de dados de um banco transacional (OLTP) e carga em um data warehouse analítico (OLAP). A estrutura proposta permite extensibilidade, modularidade e algumas boas práticas de desenvolvimento com Python e orientação a objetos. - Obviamente que sempre pode ser melhor :P

✨ ### Funcionalidades
Conexões abstratas com múltiplos bancos de dados (MySQL, Oracle, etc) via padrão Abstract Factory.
#### Módulo ELT com funções para:
* Transferência de dados entre bancos (source → target)
* Execução de stored procedures no destino

#### Exemplo prático com modelagem de:
* Tabelas stage, dimensão, fato
* Procedure para transformação de dados da stage para a fato
* Pipeline de carga de uma dimensão (dim_user)

#### Boas práticas:
* Organização modular
* Uso de keyring para proteção de credenciais sensíveis

📁 ### Estrutura do Projeto - Ler AnalyticsEngineer.txt

🚀 ### Como Usar:

#### 1. Clone o repositório
  git clone https://github.com/amandapaura/AnalyticsEngineer.git
  cd etl-base

#### 2. Configure o ambiente
Python 3.8+
Instale as dependências necessárias:
  pip install -r requirements.txt
Configure o acesso aos bancos usando keyring para armazenar senhas de forma segura:
  import keyring
  keyring.set_password("mysql", "usuario", "sua_senha")

#### 3. Execute o pipeline de exemplo
  python dim_user_etl.py

📌 ### Objetivos do Projeto
* Servir como ponto de partida para equipes que desejam construir seus próprios pipelines de ETL/ELT
* Mostrar como organizar um projeto de ETL de forma modular e orientada a objetos
* Ilustrar práticas comuns em ambientes de BI, como uso de staging, temp tables, e transformações SQL

📚 ### O que falta / O que você pode contribuir
Criação de pipelines para novas dimensões
* Expansão das classes de conexão para outros bancos
* Melhoria de performance nas transferências
* Automatização de deploy - esse codigo foi pensado em uso via airflow, mas pode ser usado por outra estrutura de outra maneira, claro!

🧠 ### Tecnologias utilizadas
* Python
* SQL (MySQL, Oracle)
* keyring para segurança
* Padrão de projeto: Abstract Factory
* Data Warehouse design (Kimball-like)

🤝 ### Contribuições
Sinta-se à vontade para abrir issues, propor pull requests, ou adaptar o projeto para sua realidade. A ideia é evoluí-lo de forma colaborativa.





