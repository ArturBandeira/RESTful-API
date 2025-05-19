Feature: API de Clientes
  Validar operações CRUD de clientes

  Background:
    Given a API de Clientes está no ar em "http://127.0.0.1:5000"

  Scenario: Criar um cliente novo
    When eu envio um POST para "/create/adicionar_cliente" com JSON
      """
      {
        "nome": "Ana Silva",
        "idade": "30",
        "cpf": "12345678901",
        "email": "ana@usp.br"
      }
      """
    Then a resposta deve ter status 200
    And o corpo deve conter "Employee added successfully!"

  Scenario: Listar clientes
    When eu envio um GET para "/read/ler_clientes"
    Then a resposta deve ter status 200
    And a resposta JSON deve ser uma lista

  Scenario: Atualizar um cliente existente
    Given que existe um cliente com id 1
    When eu envio um PUT para "/update/atualiza_cliente" com JSON
      """
      {
        "id": "1",
        "nome": "Ana dos Santos",
        "idade": "31",
        "cpf": "12345678901",
        "email": "ana.santos@usp.br"
      }
      """
    Then a resposta deve ter status 200
    And o corpo deve conter "Cliente atualizado!"

  Scenario: Apagar um cliente
    Given que existe um cliente com id 1
    When eu envio um DELETE para "/delete/apagar_cliente" com JSON
      """
      { "id": "1" }
      """
    Then a resposta deve ter status 200
    And o corpo deve conter "Cliente apagado!"