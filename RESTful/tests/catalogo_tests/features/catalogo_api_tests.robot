*** Settings ***
Library           RequestsLibrary
Variables         catalogo_api_vars.py
Suite Setup       Create Session    catalogo_api    ${API_URL}    auth=${ADMIN_CREDENTIALS}

*** Variables ***
${EP_ADD}         /create/adicionar_clientes_produtos
${EP_DELETE}      /delete/apagar_clientes_produtos
${EP_UPDATE}      /update/atualizar_clientes_produtos
${EP_PRODS}       /read/ler_produtos_do_cliente
${EP_CLIS}        /read/ler_clientes_do_produto

*** Test Cases ***
Criar Relação Cliente-Produto
    [Tags]    positive
    &{payload}=    Create Dictionary    id_cliente=1    id_produto=1
    ${r}=          POST On Session     catalogo_api    ${EP_ADD}     json=${payload}
    Should Be Equal As Integers        ${r.status_code}            200
    Should Contain                      ${r.content}               Relacao adicionada!

Listar Produtos do Cliente
    [Tags]    positive
    &{payload}=    Create Dictionary    id=1
    ${r}=          GET On Session      catalogo_api    ${EP_PRODS}   json=${payload}
    Should Be Equal As Integers        ${r.status_code}            200
    ${body}=       To Json             ${r.content}
    Should Be True                      isinstance(${body}, list)

Listar Clientes do Produto
    [Tags]    positive
    &{payload}=    Create Dictionary    id=1
    ${r}=          GET On Session      catalogo_api    ${EP_CLIS}    json=${payload}
    Should Be Equal As Integers        ${r.status_code}            200
    ${body}=       To Json             ${r.content}
    Should Be True                      isinstance(${body}, list)

Atualizar Relação Existente
    [Tags]    positive
    &{payload}=    Create Dictionary    id=1    id_cliente=1    id_produto=2
    ${r}=          PUT On Session      catalogo_api    ${EP_UPDATE}  json=${payload}
    Should Be Equal As Integers        ${r.status_code}            200
    Should Contain                      ${r.content}               Relacao atualizada!

Remover Relação Existente
    [Tags]    positive
    &{payload}=    Create Dictionary    id_cliente=1    id_produto=1
    ${r}=          DELETE On Session   catalogo_api    ${EP_DELETE}  json=${payload}
    Should Be Equal As Integers        ${r.status_code}            200
    Should Contain                      ${r.content}               Relacao apagada!

Cadastrar Relação Duplicada
    [Tags]    negative
    &{payload}=    Create Dictionary    id_cliente=1    id_produto=1
    ${r}=          POST On Session     catalogo_api    ${EP_ADD}     json=${payload}
    Should Be True                      ${r.status_code} == 200

Consultar Produtos Cliente Inexistente
    [Tags]    negative
    &{payload}=    Create Dictionary    id=9999
    ${r}=          GET On Session      catalogo_api    ${EP_PRODS}   json=${payload}
    Should Be True                      ${r.status_code} == 200

Consultar Clientes Produto Inexistente
    [Tags]    negative
    &{payload}=    Create Dictionary    id=9999
    ${r}=          GET On Session      catalogo_api    ${EP_CLIS}    json=${payload}
    Should Be True                      ${r.status_code} == 200

Atualizar Relação Inexistente
    [Tags]    negative
    &{payload}=    Create Dictionary    id=9999    id_cliente=1    id_produto=1
    ${r}=          PUT On Session      catalogo_api    ${EP_UPDATE}  json=${payload}
    Should Be True                      ${r.status_code} == 200

Remover Relação Inexistente
    [Tags]    negative
    &{payload}=    Create Dictionary    id_cliente=9999    id_produto=9999
    ${r}=          DELETE On Session   catalogo_api    ${EP_DELETE}  json=${payload}
    Should Be True                      ${r.status_code} == 200
