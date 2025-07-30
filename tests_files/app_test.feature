# language: pt
Funcionalidade: Teste da API de Clientes
  Como um usuário da aplicação
  Eu quero acessar os endpoints da API
  Para verificar se a aplicação está funcionando corretamente

  Cenário: Verificar se a aplicação está online
    Dado que a aplicação está rodando na URL "http://a31c4664ccba4453997722464909a7df-865583725.us-east-2.elb.amazonaws.com/"
    Quando eu faço uma requisição GET para o endpoint raiz
    Então o status da resposta deve ser 200
    E o corpo da resposta deve conter "OK"

  Cenário: Listar todos os clientes
    Dado que a aplicação está rodando na URL "http://a31c4664ccba4453997722464909a7df-865583725.us-east-2.elb.amazonaws.com/"
    Quando eu faço uma requisição GET para o endpoint "/read/ler_clientes"
    Então o status da resposta deve ser 200
    E a resposta deve ser um JSON válido
    E a resposta deve conter uma lista de clientes
    E cada cliente deve ter os campos "cpf", "email", "id", "idade" e "nome"

  Cenário: Verificar estrutura dos dados do cliente
    Dado que a aplicação está rodando na URL "http://a31c4664ccba4453997722464909a7df-865583725.us-east-2.elb.amazonaws.com/"
    Quando eu faço uma requisição GET para o endpoint "/read/ler_clientes"
    Então o status da resposta deve ser 200
    E pelo menos um cliente deve ter o CPF "04049445157"
    E pelo menos um cliente deve ter o email "arturbchanj3@gmail.com"
    E pelo menos um cliente deve ter o nome "nome_teste3"
    E pelo menos um cliente deve ter a idade 20 