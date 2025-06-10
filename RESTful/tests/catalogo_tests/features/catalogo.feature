Feature: Gestão de catálogo (Visão de Mercado)
  Como gestor de portfólio
  Quero relacionar clientes e produtos
  Para criar ofertas e pacotes integrados

  Background:
    Dado que o sistema de catálogo está disponível para operação

  # Cenários Positivos
  Scenario: Criar nova relação cliente-produto
    Given existe cliente com id 1
    And existe produto com id 1
    When é realizada a relação entre cliente 1 e produto 1
    Then a relação é registrada com sucesso

  Scenario: Consultar produtos de um cliente
    Given existe cliente com id 1 e ele possui produtos relacionados
    When é solicitada a lista de produtos do cliente 1
    Then é retornada uma lista de produtos contendo id_produto e detalhes

  Scenario: Consultar clientes de um produto
    Given existe produto com id 1 e ele possui clientes relacionados
    When é solicitada a lista de clientes do produto 1
    Then é retornada uma lista de clientes contendo id_cliente e detalhes

  Scenario: Atualizar relação existente
    Given existe relação com id 1 ligando cliente 1 ao produto 1
    And existe produto com id 2
    When a relação 1 é atualizada para cliente 1 e produto 2
    Then a atualização é confirmada com sucesso

  Scenario: Remover relação existente
    Given existe relação com id 1
    When a relação 1 é removida
    Then a relação não aparece mais nas consultas

  # Cenários Negativos
  Scenario: Tentar criar relação duplicada
    Given já existe relação entre cliente 1 e produto 1
    When é realizada novamente a relação entre cliente 1 e produto 1
    Then o sistema rejeita o cadastro

  Scenario: Consultar produtos de cliente inexistente
    Given não existe cliente com id 9999
    When é solicitada a lista de produtos do cliente 9999
    Then o sistema informa que não encontrou o registro

  Scenario: Consultar clientes de produto inexistente
    Given não existe produto com id 9999
    When é solicitada a lista de clientes do produto 9999
    Then o sistema informa que não encontrou o registro

  Scenario: Atualizar relação inexistente
    Given não existe relação com id 9999
    When é solicitada atualização da relação 9999
    Then o sistema informa que não encontrou o registro

  Scenario: Remover relação inexistente
    Given não existe relação com id 9999
    When é solicitada remoção da relação 9999
    Then o sistema informa que não encontrou o registro

  Scenario: Tentar cadastrar sem informar campos obrigatórios
    When é realizada a relação sem informar id_cliente ou id_produto
    Then o sistema rejeita por dados incompletos