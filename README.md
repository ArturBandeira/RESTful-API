# RESTful Microservices em Flask com BDD e Robot Framework

Este repositório contém três microserviços em Flask — **Clientes**, **Produtos** e **Catálogo** — que expõem APIs RESTful para gerenciar clientes, produtos e suas relações, além de uma suíte de testes de aceitação (BDD com **behave**) e testes de integração de API com **Robot Framework**.

---

## 📦 Funcionalidades

### 1. Clientes API  
- **POST** `/create/adicionar_cliente`  
- **GET** `/read/ler_cliente` (por ID)  
- **GET** `/read/ler_clientes` (todos)  
- **PUT** `/update/atualiza_cliente`  
- **DELETE** `/delete/apagar_cliente`  

### 2. Produtos API  
- **POST** `/create/adicionar_produto`  
- **GET** `/read/ler_produto` (por ID)  
- **GET** `/read/ler_produtos` (todos)  
- **PUT** `/update/atualizar_produto`  
- **DELETE** `/delete/apagar_produto`  

### 3. Catálogo API  
- **POST** `/create/adicionar_clientes_produtos`  
- **GET** `/read/ler_produtos_do_cliente`  
- **GET** `/read/ler_clientes_do_produto`  
- **PUT** `/update/atualizar_clientes_produtos`  
- **DELETE** `/delete/apagar_clientes_produtos`  

Todas as operações são protegidas por autenticação básica HTTP (usuário `admin`, senha `senha_teste`).

---

## ⚙️ Pré-requisitos

- Python ≥ 3.8  
- MySQL / MariaDB (com os bancos `db_clientes`, `db_produtos` e `db_catalogo` e suas *stored procedures*)  
- Virtualenv (recomendado)  


## Cobertura dos testes
Testes desenvolvidos sob uma visão de mercado, descritos em Gherkin e implementados com Behave e Robot.

---

## Automação do envio de requests
O código request_sender.c deve ser compilado e executado em ambiente Linux. Este envia, a cada 5 minutos, uma request GET para a API de clientes.
