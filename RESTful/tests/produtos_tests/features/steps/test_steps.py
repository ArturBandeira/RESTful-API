import json
import requests
from behave import given, when, then

BASIC_AUTH = ('admin', 'senha_teste')

@given('a API de Produtos está no ar em "{base_url}"')
def step_set_produtos_base_url(context, base_url):
    context.base_url = base_url.rstrip('/')

@given('que existe um produto com id {ident:d}')
def step_produto_exists(context, ident):
    context.entity_id = ident

@when('eu envio um POST para "{path}" com JSON')
def step_post_with_json(context, path):
    url     = context.base_url + path
    payload = json.loads(context.text)
    context.response = requests.post(url,
                                     json=payload,
                                     auth=BASIC_AUTH)

@when('eu envio um GET para "{path}"')
def step_get(context, path):
    url = context.base_url + path
    context.response = requests.get(url, auth=BASIC_AUTH)

@when('eu envio um PUT para "{path}" com JSON')
def step_put_with_json(context, path):
    url     = context.base_url + path
    payload = json.loads(context.text)
    context.response = requests.put(url,
                                    json=payload,
                                    auth=BASIC_AUTH)

@when('eu envio um DELETE para "{path}" com JSON')
def step_delete_with_json(context, path):
    url     = context.base_url + path
    payload = json.loads(context.text)
    context.response = requests.delete(url,
                                       json=payload,
                                       auth=BASIC_AUTH)

@then('a resposta deve ter status {status_code:d}')
def step_check_status(context, status_code):
    actual = context.response.status_code
    assert actual == status_code, (
        f"Esperava status {status_code}, mas recebeu {actual}:\n"
        f"{context.response.text}"
    )

@then('o corpo deve conter "{texto}"')
def step_body_contains(context, texto):
    body = context.response.text
    assert texto in body, f'Esperava "{texto}" no body:\n{body}'

@then('a resposta JSON deve ser uma lista')
def step_response_json_list(context):
    data = context.response.json()
    assert isinstance(data, list), (
        f"Esperava lista, recebeu {type(data)}:\n{data}"
    )