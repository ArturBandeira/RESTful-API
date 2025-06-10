*** Settings ***
Library           RequestsLibrary
Variables         produto_api_vars.py
Suite Setup       Create Session    produto_api    ${API_URL}    auth=${ADMIN_CREDENTIALS}

*** Variables ***
${EP_ADD}        /create/adicionar_produto
${EP_LIST}       /read/ler_produtos
${EP_READ}       /read/ler_produto
${EP_UPDATE}     /update/atualizar_produto
${EP_DELETE}     /delete/apagar_produto

*** Test Cases ***
Adicionar Produto Válido
    [Tags]    positive
    &{payload}=    Create Dictionary    nome=Produto Teste    velocidade=100    preco=50    disponibilidade=1
    ${response}=   POST On Session     produto_api    ${EP_ADD}       json=${payload}
    Should Be Equal As Integers       ${response.status_code}    200
    Should Contain                     ${response.content}        Produto adicionado!

Listar Produtos Disponíveis
    [Tags]    positive
    ${response}=   GET On Session      produto_api    ${EP_LIST}
    Should Be Equal As Integers       ${response.status_code}    200
    ${body}=        To Json            ${response.content}
    Should Be True                     isinstance(${body}, list)

Ler Produto Existente
    [Tags]    positive
    &{payload}=    Create Dictionary    id=2
    ${response}=   GET On Session      produto_api    ${EP_READ}      json=${payload}
    Should Be Equal As Integers       ${response.status_code}    200
    Should Contain                     ${response.content}        nome

Atualizar Produto
    [Tags]    positive
    &{payload}=    Create Dictionary    id=1    nome=Produto Atualizado    velocidade=200    preco=75    disponibilidade=1
    ${response}=   PUT On Session      produto_api    ${EP_UPDATE}    json=${payload}
    Should Be Equal As Integers       ${response.status_code}    200
    Should Contain                     ${response.content}        Produto atualizado!

Remover Produto
    [Tags]    positive
    &{payload}=    Create Dictionary    id=1
    ${response}=   DELETE On Session   produto_api    ${EP_DELETE}    json=${payload}
    Should Be Equal As Integers       ${response.status_code}    200
    Should Contain                     ${response.content}        Produto apagado!

Cadastrar Produto Duplicado
    [Tags]    negative
    &{payload}=    Create Dictionary    nome=Produto Teste    velocidade=100    preco=50    disponibilidade=1
    ${response}=   POST On Session     produto_api    ${EP_ADD}       json=${payload}
    Should Be True                     ${response.status_code} == 200

Consultar Produto Inexistente
    [Tags]    negative
    &{payload}=    Create Dictionary    id=9999
    ${response}=   GET On Session      produto_api    ${EP_READ}      json=${payload}
    Should Be True                     ${response.status_code} == 200

Remover Produto Inexistente
    [Tags]    negative
    &{payload}=    Create Dictionary    id=9999
    ${response}=   DELETE On Session   produto_api    ${EP_DELETE}    json=${payload}
    Should Be True                     ${response.status_code} == 200