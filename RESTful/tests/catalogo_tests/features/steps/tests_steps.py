import json
import requests
from behave import given, when, then

BASIC_AUTH = ('admin', 'senha_teste')

@given('a API de Catálogo está no ar em "{base_url}"')
def step_set_catalogo_base_url(context, base_url):
    context.base_url = base_url.rstrip('/')

@given('que existe um cliente com id {cliente_id:d}')
def step_cliente_exists(context, cliente_id):
    context.cliente_id = cliente_id

@given('que existe um produto com id {produto_id:d}')
def step_produto_exists(context, produto_id):
    context.produto_id = produto_id

@when('eu envio um POST para "{path}" com JSON')
def step_post_with_json(context, path):
    url     = f"{context.base_url}{path}"
    payload = json.loads(context.text)
    context.response = requests.post(url,
                                     json=payload,
                                     auth=BASIC_AUTH)

@when('eu envio um GET para "{path}" com JSON')
def step_get_with_json(context, path):
    url     = f"{context.base_url}{path}"
    payload = json.loads(context.text)
    context.response = requests.get(url,
                                    json=payload,
                                    auth=BASIC_AUTH)

@when('eu envio um DELETE para "{path}" com JSON')
def step_delete_with_json(context, path):
    url     = f"{context.base_url}{path}"
    payload = json.loads(context.text)
    context.response = requests.delete(url,
                                       json=payload,
                                       auth=BASIC_AUTH)

@then('a resposta deve ter status {status_code:d}')
def step_assert_status(context, status_code):
    actual = context.response.status_code
    assert actual == status_code, (
        f"Esperava status {status_code}, mas recebeu {actual}:\n"
        f"{context.response.text}"
    )

@then('o corpo deve conter "{texto}"')
def step_assert_body_contains(context, texto):
    body = context.response.text
    assert texto in body, (
        f'Esperava encontrar "{texto}" no corpo da resposta, mas recebi:\n{body}'
    )

@then('a resposta JSON deve ser uma lista')
def step_assert_json_is_list(context):
    data = context.response.json()
    assert isinstance(data, list), (
        f"Esperava que a resposta JSON fosse uma lista, mas recebi {type(data)}:\n{data}"
    )