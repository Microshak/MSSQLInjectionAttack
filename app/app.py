import pyodbc
import flask
from flask import request
import pandas
import logging
import pymssql

driver= '{ODBC Driver 18 for SQL Server}'
conn = pyodbc.connect('DRIVER='+driver+';SERVER=db;PORT=1433;DATABASE=test;UID=sa;PWD=PlassBird9000!;TrustServerCertificate=yes')



from flask import Flask, render_template

app = Flask(__name__)


@app.route('/')
def hello():
    return render_template('index.html')

@app.route("/setup")
def helloworldz():



   # conn = pyodbc.connect(
   # 'DRIVER='+driver+';SERVER=172.0.0.1;DATABASE=test;UID=sa;PWD=PlassBird9000!; TrustServerCertificate=yes', autocommit=True)
    cur = conn.cursor()
    cur.execute(
    """if not exists (select * from sysobjects where name='Account' and xtype='U')
    create table Account (
        Name varchar(64) not null
    )
""")
    cur.execute(
    """if not exists (select * from sysobjects where name='Loan' and xtype='U')
    create table Loan (
        Amount varchar(64) not null
    )
""")
    conn.commit()
    cur.close()
    conn.close()
    return "Tales Created"


@app.route("/pyhack")
def pyhack():
    cnxn = pymssql.connect(
        "db", "sa","PlassBird9000!","test",
    )
    cursor = cnxn.cursor()
    table = request.args.get('table')
    name = request.args.get('name') 
    
    cursor.execute(f"INSERT INTO  {table} (Name) VALUES (%s)", name)
    cnxn.commit()
    return "hacked"

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')




