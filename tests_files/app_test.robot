*** Settings ***
Documentation     Testes automatizados para a API de Clientes
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library           String

*** Variables ***
${BASE_URL}       http://a31c4664ccba4453997722464909a7df-865583725.us-east-2.elb.amazonaws.com
${ROOT_ENDPOINT}  /
${CLIENTES_ENDPOINT}  /read/ler_clientes
${TIMEOUT}        30s

*** Test Cases ***
Verificar Se Aplicação Está Online
    [Documentation]  Testa se a aplicação está respondendo no endpoint raiz
    [Tags]  smoke  health-check
    ${response}=  GET  ${BASE_URL}${ROOT_ENDPOINT}  timeout=${TIMEOUT}
    Status Should Be  200  ${response}
    Should Be Equal As Strings  ${response.text}  OK

Listar Todos Os Clientes
    [Documentation]  Testa o endpoint de listagem de clientes
    [Tags]  api  clientes
    ${response}=  GET  ${BASE_URL}${CLIENTES_ENDPOINT}  timeout=${TIMEOUT}
    Status Should Be  200  ${response}
    
    # Verifica se a resposta é um JSON válido
    ${json_response}=  Set Variable  ${response.json()}
    Should Not Be Empty  ${json_response}
    
    # Verifica se é uma lista
    Should Be True  isinstance(${json_response}, list)
    
    # Verifica se há pelo menos um cliente
    ${clientes_count}=  Get Length  ${json_response}
    Should Be True  ${clientes_count} > 0

Verificar Estrutura Dos Dados Do Cliente
    [Documentation]  Verifica se os dados dos clientes têm a estrutura correta
    [Tags]  api  clientes  estrutura
    ${response}=  GET  ${BASE_URL}${CLIENTES_ENDPOINT}  timeout=${TIMEOUT}
    Status Should Be  200  ${response}
    
    ${json_response}=  Set Variable  ${response.json()}
    Should Not Be Empty  ${json_response}
    
    # Verifica a estrutura de cada cliente
    FOR  ${cliente}  IN  @{json_response}
        Dictionary Should Contain Key  ${cliente}  cpf
        Dictionary Should Contain Key  ${cliente}  email
        Dictionary Should Contain Key  ${cliente}  id
        Dictionary Should Contain Key  ${cliente}  idade
        Dictionary Should Contain Key  ${cliente}  nome
        
        # Verifica tipos dos campos
        Should Be True  isinstance(${cliente}[cpf], str)
        Should Be True  isinstance(${cliente}[email], str)
        Should Be True  isinstance(${cliente}[id], int)
        Should Be True  isinstance(${cliente}[idade], int)
        Should Be True  isinstance(${cliente}[nome], str)
    END

Verificar Dados Específicos Do Cliente
    [Documentation]  Verifica se os dados específicos do cliente estão presentes
    [Tags]  api  clientes  dados-especificos
    ${response}=  GET  ${BASE_URL}${CLIENTES_ENDPOINT}  timeout=${TIMEOUT}
    Status Should Be  200  ${response}
    
    ${json_response}=  Set Variable  ${response.json()}
    
    # Procura pelo cliente específico
    ${cliente_encontrado}=  Set Variable  False
    FOR  ${cliente}  IN  @{json_response}
        ${cpf_match}=  Run Keyword And Return Status  Should Be Equal As Strings  ${cliente}[cpf]  04049445157
        ${email_match}=  Run Keyword And Return Status  Should Be Equal As Strings  ${cliente}[email]  arturbchanj3@gmail.com
        ${nome_match}=  Run Keyword And Return Status  Should Be Equal As Strings  ${cliente}[nome]  nome_teste3
        ${idade_match}=  Run Keyword And Return Status  Should Be Equal As Numbers  ${cliente}[idade]  20
        
        IF  ${cpf_match} and ${email_match} and ${nome_match} and ${idade_match}
            ${cliente_encontrado}=  Set Variable  True
            Exit For Loop
        END
    END
    
    Should Be True  ${cliente_encontrado}  Cliente com dados específicos não foi encontrado

Teste De Performance Básico
    [Documentation]  Testa o tempo de resposta da API
    [Tags]  performance
    ${start_time}=  Get Time  epoch
    ${response}=  GET  ${BASE_URL}${CLIENTES_ENDPOINT}  timeout=${TIMEOUT}
    ${end_time}=  Get Time  epoch
    ${response_time}=  Evaluate  ${end_time} - ${start_time}
    
    Status Should Be  200  ${response}
    Should Be True  ${response_time} < 5  Tempo de resposta muito alto: ${response_time}s

*** Keywords ***
Status Should Be
    [Arguments]  ${expected_status}  ${response}
    Should Be Equal As Numbers  ${response.status_code}  ${expected_status}

Should Be True
    [Arguments]  ${condition}  ${message}=${EMPTY}
    Run Keyword If  not ${condition}  Fail  ${message} 