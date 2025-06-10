Feature: Gestão de clientes (Visão de Mercado)
  Como gestor de negócios
  Quero gerenciar o cadastro de clientes
  Para oferecer serviços e produtos personalizados

  Background:
    Dado que o sistema de clientes está disponível para operação

  # Cenários Positivos
  Scenario: Adicionar um novo cliente válido ao portfólio
    Given não existe cliente com CPF "12345678901"
    When um novo cliente é registrado com nome "Ana Silva" e CPF "12345678901"
    Then o cadastro é aceito e retorno de sucesso ocorre

  Scenario: Consultar lista de clientes ativos
    Given existem clientes cadastrados no sistema
    When a lista de clientes é solicitada
    Then é retornada uma lista de clientes com informações de nome e CPF

  Scenario: Atualizar informações de um cliente existente
    Given existe cliente com CPF "12345678901"
    When suas informações de nome são alteradas para "Ana Souza"
    Then a atualização é confirmada com sucesso

  Scenario: Remover cliente do ciclo de atendimento
    Given existe cliente com CPF "12345678901"
    When o cliente é marcado como inativo
    Then o cliente não aparece em listagens de ativos

  # Cenários Negativos
  Scenario: Tentar cadastrar cliente com nome já cadastrado
    Given existe cliente com nome "Ana Silva"
    When um novo cliente é registrado com nome "Ana Silva"
    Then nada acontece

  Scenario: Consultar cliente inexistente
    Given não existe cliente com CPF "00000000000"
    When é solicitada consulta para CPF "00000000000"
    Then nada acontece

  Scenario: Remover cliente inexistente
    Given não existe cliente com CPF "00000000002"
    When a remoção de CPF "00000000002" é solicitada
    Then nada acontece