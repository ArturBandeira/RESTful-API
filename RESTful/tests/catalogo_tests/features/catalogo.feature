Feature: API de Catálogo
  Validar o relacionamento Cliente ↔ Produto

  Background:
    Given a API de Catálogo está no ar em "http://127.0.0.1:5000"

  Scenario: Associar um cliente a um produto
    Given que existe um cliente com id 1
    And que existe um produto com id 1
    When eu envio um POST para "/create/adicionar_clientes_produtos" com JSON
      """
      {
        "id_cliente": "1",
        "id_produto": "1"
      }
      """
    Then a resposta deve ter status 200
    And o corpo deve conter "Relacao adicionada!"

  Scenario: Listar produtos de um cliente
    Given que existe um cliente com id 1
    When eu envio um GET para "/read/ler_produtos_do_cliente" com JSON
      """
      {
        "id": "1"
      }
      """
    Then a resposta deve ter status 200
    And a resposta JSON deve ser uma lista

  Scenario: Listar clientes de um produto
    Given que existe um produto com id 1
    When eu envio um GET para "/read/ler_clientes_do_produto" com JSON
      """
      {
        "id": "1"
      }
      """
    Then a resposta deve ter status 200
    And a resposta JSON deve ser uma lista

  Scenario: Desassociar um cliente de um produto
    Given que existe um cliente com id 1
    And que existe um produto com id 1
    When eu envio um DELETE para "/delete/apagar_clientes_produtos" com JSON
      """
      {
        "id_cliente": "1",
        "id_produto": "1"
      }
      """
    Then a resposta deve ter status 200
    And o corpo deve conter "Relacao apagada!"
