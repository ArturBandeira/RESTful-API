*** Settings ***
Library           RequestsLibrary
Variables         cliente_api_vars.py
Suite Setup       Create Session    cliente_api    ${API_URL}    auth=${ADMIN_CREDENTIALS}

*** Variables ***
${ENDPOINT_ADD}         /create/adicionar_cliente
${ENDPOINT_LIST}        /read/ler_clientes
${ENDPOINT_READ}        /read/ler_cliente
${ENDPOINT_UPDATE}      /update/atualiza_cliente
${ENDPOINT_REMOVE}      /delete/apagar_cliente

*** Test Cases ***
Adicionar Cliente Válido
    [Tags]    positive
    ${payload}=    Create Dictionary    nome=Ana Silva    idade=30    cpf=12345678901    email=ana@usp.br
    ${response}=    POST On Session    cliente_api    ${ENDPOINT_ADD}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Contain    ${response.content}    Cliente adicionado!

Listar Clientes Ativos
    [Tags]    positive
    ${response}=    GET On Session    cliente_api    ${ENDPOINT_LIST}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    To Json    ${response.content}
    Should Be True    isinstance(${body}, list)

Ler Cliente Existente
    [Tags]    positive
    ${payload}=    Create Dictionary    id=2
    ${response}=    GET On Session    cliente_api    ${ENDPOINT_READ}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    ${cli}=    To Json    ${response.content}
    Should Contain    ${response.content}    1

Atualizar Cliente
    [Tags]    positive
    ${payload}=    Create Dictionary    id=1    nome=Ana Souza    idade=31    cpf=12345678901    email=ana.souza@usp.br
    ${response}=    PUT On Session    cliente_api    ${ENDPOINT_UPDATE}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Contain    ${response.content}    Cliente atualizado!

Apagar Cliente
    [Tags]    positive
    ${payload}=    Create Dictionary    id=1
    ${response}=    DELETE On Session    cliente_api    ${ENDPOINT_REMOVE}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Contain    ${response.content}    Cliente apagado!

Cadastrar Sem Campo Obrigatório
    ${response}=    Post Request    cliente_api    /create/adicionar_cliente    json={}
    Should Be True    ${response.status_code} >= 400

Atualizar Sem Nome
    &{payload}=    Create Dictionary    id=1    idade=30    cpf=12345678901    email=test@ex.com
    ${response}=    Put Request    cliente_api    /update/atualiza_cliente    json=${payload}
    Should Be True    ${response.status_code} >= 400

Apagar Cliente Inexistente
    [Tags]    negative
    ${payload}=    Create Dictionary    id=9999
    ${response}=    DELETE On Session    cliente_api    ${ENDPOINT_REMOVE}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200
