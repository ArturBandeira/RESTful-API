Feature: Gestão de produtos (Visão de Mercado)
  Como gestor de catálogo
  Quero gerenciar o portfólio de produtos
  Para garantir oferta atualizada e competitiva

  Background:
    Dado que o sistema de produtos está disponível para operação

  # Cenários Positivos
  Scenario: Adicionar novo produto válido
    Given não existe produto com nome "Produto Teste"
    When é realizado o cadastro de produto com nome "Produto Teste", velocidade 100, preço 50 e disponibilidade ativa
    Then o produto é registrado com sucesso

  Scenario: Consultar lista de produtos disponíveis
    Given existem produtos cadastrados no sistema
    When a lista de produtos é solicitada
    Then é retornada uma lista de produtos com nome, velocidade e preço

  Scenario: Atualizar informações de produto existente
    Given existe produto com id 1
    When suas informações são alteradas para nome "Produto Atualizado", velocidade 200, preço 75 e disponibilidade ativa
    Then a atualização é confirmada com sucesso

  Scenario: Remover produto do catálogo
    Given existe produto com id 1
    When o produto é removido
    Then o produto não aparece mais na listagem

  # Cenários Negativos
  Scenario: Tentar cadastrar produto duplicado
    Given existe produto com nome "Produto Teste"
    When é realizado o cadastro de produto com nome "Produto Teste", velocidade 100, preço 50 e disponibilidade ativa
    Then o sistema rejeita o cadastro

  Scenario: Consultar produto inexistente
    Given não existe produto com id 9999
    When é solicitada consulta para id 9999
    Then o sistema informa que não encontrou o registro

  Scenario: Atualizar produto sem nome
    Given existe produto com id 1
    When é solicitada atualização de produto id 1 sem informar nome
    Then o sistema rejeita a atualização

  Scenario: Remover produto inexistente
    Given não existe produto com id 9999
    When é solicitada remoção de produto id 9999
    Then o sistema informa que não encontrou o registro