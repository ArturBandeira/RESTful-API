from faker import Faker
import requests
import time
import random
from requests.auth import HTTPBasicAuth
import sys

fake = Faker(locale = "pt_BR")

url_clientes = "http://127.0.0.1:5000/create/adicionar_cliente"
url_produtos = "http://127.0.0.1:5000/create/adicionar_produto"
url_catalogo = "http://127.0.0.1:5000/create/adicionar_clientes_produtos"
products_names = ["banda larga", "fibra optica", "telefonia", "TV por assinatura"]
i = 0

if(sys.argv[1] == "clientes"):
    while i < 100:
        payload = {
        "nome" : fake.name(),
        "idade" : str(random.randint(20, 80)),
        "cpf" : fake.cpf().replace(".","").replace("-",""),
        "email": fake.email()
        }
        request = requests.post(url_clientes, json = payload, auth = HTTPBasicAuth("admin", "senha_teste"))
        time.sleep(0.5)
        i+=1

elif(sys.argv[1] == "produtos"):
    while i < 100:
        payload = {
            "nome" : products_names[random.randint(0, len(products_names)- 1)],
            "velocidade" : str(random.randint(10,100)),
            "preco" : str(random.randint(100,500)),
            "disponibilidade" : str(random.randint(0,1))
        }
        request = requests.post(url_produtos, json = payload, auth = HTTPBasicAuth("admin", "senha_teste"))
        time.sleep(0.5)
        i+=1

elif(sys.argv[1] == "clientes_produtos"):
    while i < 100:
        payload = {
            "id_cliente" : str(random.randint(20,60)),
            "id_produto" : str(random.randint(50,70))
        }
        request = requests.post(url_catalogo, json = payload, auth = HTTPBasicAuth("admin", "senha_teste"))
        time.sleep(0.5)
        i+=1