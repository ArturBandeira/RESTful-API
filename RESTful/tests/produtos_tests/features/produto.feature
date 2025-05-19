Feature: API de produtos
    Validar as operações CRUD para os produtos

    Background: 
        Given a API de Produtos está no ar em "http://127.0.0.1:5000"

    Scenario: Criar um produto novo
        When eu envio um POST para "/create/adicionar_produto" com JSON
        """
        {
            "nome": "produto_teste",
            "velocidade": "100",
            "preco": "100",
            "disponibilidade": "1"
        }
        """
        Then a resposta deve ter status 200
        And o corpo deve conter "Produto adicionado!"
    
    Scenario: Listar produtos
        When eu envio um GET para "/read/ler_produtos"
        Then a resposta deve ter status 200
        And a resposta JSON deve ser uma lista

    Scenario: Atualizar um produto existente
        Given que existe um produto com id 1
        When eu envio um PUT para "/update/atualizar_produto" com JSON
        """
        {
            "id": "1",
            "nome": "prod_att",
            "velocidade": "100",
            "preco": "100",
            "disponibilidade": "0"
        }
        """
        Then a resposta deve ter status 200
        And o corpo deve conter "Produto atualizado!"

    Scenario: Apagar um produto
        Given que existe um produto com id 1
        When eu envio um DELETE para "/delete/apagar_produto" com JSON
        """
        { "id": "1" }
        """
        Then a resposta deve ter status 200
        And o corpo deve conter "Produto apagado!"